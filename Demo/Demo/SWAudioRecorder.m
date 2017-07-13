//
//  SWAudioRecorder.m
//  Demo
//
//  Created by 李长浩 on 2017/7/13.
//  Copyright © 2017年 huayutime. All rights reserved.
//

#import "SWAudioRecorder.h"
#import <AVFoundation/AVFoundation.h>
#import "lame.h"

// 录音最大时长
static NSUInteger const MAXSECOND = 60;

@interface SWAudioRecorder ()

// 倒计时
@property (nonatomic, assign) NSInteger countDown;

// 定时器
@property (nonatomic, strong) NSTimer *timer;

//
@property (nonatomic, strong) AVAudioSession *session;

// 录音器
@property (nonatomic, strong) AVAudioRecorder *recorder;

// 录音文件路径
@property (nonatomic, copy) NSString *audioPath;

// MP3文件路径
@property (nonatomic, copy) NSString *mp3Path;

// 播放器
@property (nonatomic, strong) AVAudioPlayer *player;

@end

@implementation SWAudioRecorder

#pragma mark - public method
// 开始录音
- (void)startRecord {
    self.countDown = 60;
    
    self.session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [self.session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    if (!self.session) {
        NSLog(@"Error creating session: %@",[sessionError description]);
        return;
    }
    [self.session setActive:YES error:nil];
    
    // 获取沙盒路径
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    self.audioPath = [documentPath stringByAppendingString:@"/AudioRecord.caf"];
    NSLog(@"%@", self.audioPath);
    // 获取文件路径
    NSURL *recordFileURL = [NSURL URLWithString:self.audioPath];
    /*
     * settings 参数
     1.AVFormatIDKey 音频格式
     2.AVNumberOfChannelsKey 通道数 通常为双声道 (值2), 单声道 (值1)
     3.AVSampleRateKey 采样率 单位HZ 通常设置成44100 (8000/11025/22050/44100/96000) 也就是44.1k,采样率必须要设为11025才能使转化成mp3格式后不会失真
     4.AVLinearPCMBitDepthKey 比特率 8 16 24 32 默认为16
     5.AVEncoderAudioQualityKey 声音质量
         ① AVAudioQualityMin  = 0, 最小的质量
         ② AVAudioQualityLow  = 0x20, 比较低的质量
         ③ AVAudioQualityMedium = 0x40, 中间的质量
         ④ AVAudioQualityHigh  = 0x60,高的质量
         ⑤ AVAudioQualityMax  = 0x7F 最好的质量
     6.AVEncoderBitRateKey 音频编码的比特率 单位Kbps 传输的速率 一般设置128000 也就是128kbps

     */
    // 设置参数
    NSDictionary *recordSettings = @{AVFormatIDKey : @(kAudioFormatLinearPCM), AVSampleRateKey : @(11025.0), AVNumberOfChannelsKey : @2, AVEncoderBitDepthHintKey : @16, AVEncoderAudioQualityKey : @(AVAudioQualityHigh)};
    
    self.recorder = [[AVAudioRecorder alloc] initWithURL:recordFileURL settings:recordSettings error:nil];
    
    if (self.recorder) {
        [self addTimer];
        // 开启仪表计数功能,必须开启这个功能，才能检测音频值
        self.recorder.meteringEnabled = YES;
        [self.recorder prepareToRecord];
        [self.recorder record];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MAXSECOND * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self stopRecord];
        });
    }
    
}

// 停止录音
- (void)stopRecord {
    [self removeTimer];
    
    if ([self.recorder isRecording]) {
        [self.recorder stop];
    }
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:self.audioPath]) {
        // 启用一个新的线程用来将pcm转成mp3
        [NSThread detachNewThreadSelector:@selector(audio_PCMToMP3) toTarget:self withObject:nil];
    }
}

// 播放录音
- (void)playRecord {
    if ([self.player isPlaying]) {
        return;
    }
    [self.session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    NSURL *mp3URL = [NSURL fileURLWithPath:self.mp3Path];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:mp3URL error:nil];
    self.player.numberOfLoops = 0;
    [self.player play];
}

#pragma mark - private method
// 添加定时器
- (void)addTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerCountDown) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

// 移除定时器
- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
}

// 定时器倒计时
- (void)timerCountDown {
    self.countDown--;
    NSUInteger currentSecond = MAXSECOND - (long)self.countDown;
    if ([self.delegate respondsToSelector:@selector(getCurrentRecorderSecond:)]) {
        [self.delegate getCurrentRecorderSecond:currentSecond];
    }
}

- (void)audio_PCMToMP3 {
    
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    self.mp3Path = [documentPath stringByAppendingString:@"/AudioRecordMP3.mp3"];
    NSLog(@"%@", self.mp3Path);
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([self.audioPath cStringUsingEncoding:1], "rb");   //source 被转换的音频文件位置
        fseek(pcm, 4 * 1024, SEEK_CUR);//删除头，否则在前一秒钟会有杂音
        FILE *mp3 = fopen([self.mp3Path cStringUsingEncoding:1], "wb"); //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE * 2];
        unsigned char mp3_buffer[MP3_SIZE];
        // 这里要注意，lame的配置要跟AVAudioRecorder的配置一致，否则会造成转换不成功
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);//采样率
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = (int)fread(pcm_buffer, 2 * sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        NSLog(@"MP3生成成功");
        NSFileManager *manager = [NSFileManager defaultManager];
        if ([manager fileExistsAtPath:self.audioPath]) {
            [manager removeItemAtPath:self.audioPath error:nil];
            NSLog(@"caf文件删除成功");
        }
        NSLog(@"录了 %ld 秒,文件大小为 %.2fKb", MAXSECOND - (long)self.countDown, [[manager attributesOfItemAtPath:self.mp3Path error:nil] fileSize]/1024.0);
    }
}

@end

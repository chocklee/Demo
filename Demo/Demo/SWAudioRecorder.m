//
//  SWAudioRecorder.m
//  Demo
//
//  Created by 李长浩 on 2017/7/13.
//  Copyright © 2017年 huayutime. All rights reserved.
//

#import "SWAudioRecorder.h"
#import <AVFoundation/AVFoundation.h>

@interface SWAudioRecorder ()

// 录音最大时长
@property (nonatomic, assign) NSInteger maxSecond;

// 定时器
@property (nonatomic, strong) NSTimer *timer;

// 录音器
@property (nonatomic, strong) AVAudioRecorder *recorder;

@end

@implementation SWAudioRecorder

#pragma mark - public method
// 开始录音
- (void)startRecord {
    self.maxSecond = 60;
    [self addTimer];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    if (!session) {
        NSLog(@"Error creating session: %@",[sessionError description]);
        return;
    }
    [session setActive:YES error:nil];
    
    // 获取沙盒路径
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *audioPath = [documentPath stringByAppendingString:@"audioRecord.caf"];
    
    
}

// 停止录音
- (void)stopRecord {
    
}

// 播放录音
- (void)playRecord {
    
}

#pragma mark - private method
// 添加定时器
- (void)addTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshProgressView) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

// 刷新进度条
- (void)refreshProgressView {
    
}

@end

//
//  SWAudioPlayer.m
//  Demo
//
//  Created by 李长浩 on 2017/7/12.
//  Copyright © 2017年 huayutime. All rights reserved.
//

#import "SWAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>


@interface SWAudioPlayer ()

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, assign) BOOL isPlay;

@end

@implementation SWAudioPlayer

+ (instancetype)player {
    static SWAudioPlayer *player = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[SWAudioPlayer alloc] init];
        [player remoteControlEventHandler];
    });
    return player;
}

#pragma mark - public method
// 根据url播放音频
- (void)playWithURL:(NSURL *)url {
    AVPlayerItem *currentItem = [[AVPlayerItem alloc] initWithURL:url];
    [self.player replaceCurrentItemWithPlayerItem:currentItem];
    [self play];
    [self updatelockScreenInfo];
}

//播放
- (void)play {
    [self.player play];
    self.isPlay = YES;
}

//暂停
- (void)pause {
    [self.player pause];
    self.isPlay = NO;
}

// 设置音频在后台及静音模式下播放
+ (void)audioPlayInBackground {
    // 获取音频的会话
    AVAudioSession *session = [AVAudioSession sharedInstance];
    // 设置后台播放类型
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    // 激活会话
    [session setActive:YES error:nil];
}

#pragma mark - private method
// 在需要处理远程控制事件的具体控制器或其它类中实现
- (void)remoteControlEventHandler {
    // 直接使用sharedCommandCenter来获取MPRemoteCommandCenter的shared实例
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    
    // 播放, 暂停, 上下曲的命令默认都是启用状态, 即enabled默认为YES
    // 播放
    [commandCenter.playCommand addTarget:self action:@selector(playAction:)];
    // 暂停
    [commandCenter.pauseCommand addTarget:self action:@selector(pauseAction:)];
    // 上一曲
    [commandCenter.previousTrackCommand addTarget:self action:@selector(previousTrackAction:)];
    // 下一曲
    [commandCenter.nextTrackCommand addTarget:self action:@selector(nextTrackAction:)];
    
    // 启用耳机的播放/暂停命令 (耳机上的播放按钮触发的命令)
    commandCenter.togglePlayPauseCommand.enabled = YES;
    // 为耳机的按钮操作添加相关的响应事件
    [commandCenter.togglePlayPauseCommand addTarget:self action:@selector(playOrPauseAction:)];
}

- (void)playAction:(MPRemoteCommandCenter *)sender {
    [self play];
}

- (void)pauseAction:(MPRemoteCommandCenter *)sender {
    [self pause];
}

- (void)previousTrackAction:(MPRemoteCommandCenter *)sender {
    NSLog(@"上一首");
}

- (void)nextTrackAction:(MPRemoteCommandCenter *)sender {
    NSLog(@"下一首");
}

- (void)playOrPauseAction:(MPRemoteCommandCenter *)sender {
    if (self.isPlay) {
        [self pause];
    } else {
        [self play];
    }
}


- (void)updatelockScreenInfo {
    // 直接使用defaultCenter来获取MPNowPlayingInfoCenter的默认唯一实例
    MPNowPlayingInfoCenter *infoCenter = [MPNowPlayingInfoCenter defaultCenter];
    
    // MPMediaItemArtwork 用来表示锁屏界面图片的类型
    // 海报图片
    UIImage *posterImage = [UIImage imageNamed:@"u40"];
    UIImageView *wordCardView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 328, 328)];
    wordCardView.image = posterImage;
    wordCardView.contentMode = UIViewContentModeScaleAspectFill;
    // 获取添加了词卡的海报图片
    
    UIGraphicsBeginImageContextWithOptions(wordCardView.frame.size, NO, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [wordCardView.layer renderInContext:context];
    posterImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:posterImage];
    
    // 通过配置nowPlayingInfo的值来更新锁屏界面的信息
    infoCenter.nowPlayingInfo = @{MPMediaItemPropertyTitle : @"歌曲名", MPMediaItemPropertyArtist : @"艺术家名", MPMediaItemPropertyAlbumTitle : @"专辑名字", MPMediaItemPropertyArtwork : artwork};
    // MPMediaItemPropertyPlaybackDuration - 歌曲时长
    // MPNowPlayingInfoPropertyElapsedPlaybackTime - 已经播放时长
}

#pragma mark - lazy
- (AVPlayer *)player {
    if (!_player) {
        _player = [[AVPlayer alloc] init];
    }
    return _player;
}

@end

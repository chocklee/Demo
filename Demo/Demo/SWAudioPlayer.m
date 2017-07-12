//
//  SWAudioPlayer.m
//  Demo
//
//  Created by 李长浩 on 2017/7/12.
//  Copyright © 2017年 huayutime. All rights reserved.
//

#import "SWAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface SWAudioPlayer ()

@property (nonatomic, strong) AVPlayer *player;

//播放状态
@property (nonatomic,assign) BOOL isPlay;

@end

@implementation SWAudioPlayer

+ (instancetype)player {
    static SWAudioPlayer *player = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[SWAudioPlayer alloc] init];
        //静音状态下播放
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    });
    return player;
}

#pragma mark - public method
// 根据url播放音频
- (void)playWithURL:(NSURL *)url {
    AVPlayerItem *currentItem = [[AVPlayerItem alloc] initWithURL:url];
    [self.player replaceCurrentItemWithPlayerItem:currentItem];
    [self play];
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

//改变播放进度
- (void)seekToTime:(NSInteger)time {
    //如果是播放状态
    if (self.isPlay) {
        //先暂停当前歌曲
        [self pause];
        //改变播放进度
        [self.player seekToTime:CMTimeMake(time * self.player.currentTime.timescale, self.player.currentTime.timescale)];
        //继续播放
        [self play];
    } else {
        //改变播放进度
        [self.player seekToTime:CMTimeMake(time * self.player.currentTime.timescale, self.player.currentTime.timescale)];
    }
}

#pragma mark - lazy
- (AVPlayer *)player {
    if (!_player) {
        _player = [[AVPlayer alloc] init];
    }
    return _player;
}

@end

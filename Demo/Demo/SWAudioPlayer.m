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

//播放状态
@property (nonatomic,assign) BOOL isPlay;

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

#pragma mark - private method
// 在需要处理远程控制事件的具体控制器或其它类中实现
- (void)remoteControlEventHandler {
    // 直接使用sharedCommandCenter来获取MPRemoteCommandCenter的shared实例
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    
    // 启用播放命令 (锁屏界面和上拉快捷功能菜单处的播放按钮触发的命令)
    commandCenter.playCommand.enabled = YES;
    // 为播放命令添加响应事件, 在点击后触发
    [commandCenter.playCommand addTarget:self action:@selector(playAction:)];
    
    // 播放, 暂停, 上下曲的命令默认都是启用状态, 即enabled默认为YES
    // 为暂停, 上一曲, 下一曲分别添加对应的响应事件
    [commandCenter.pauseCommand addTarget:self action:@selector(pauseAction:)];
    [commandCenter.previousTrackCommand addTarget:self action:@selector(previousTrackAction:)];
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
    
}


- (void)updatelockScreenInfo {
    // 直接使用defaultCenter来获取MPNowPlayingInfoCenter的默认唯一实例
    MPNowPlayingInfoCenter *infoCenter = [MPNowPlayingInfoCenter defaultCenter];
    
    // MPMediaItemArtwork 用来表示锁屏界面图片的类型
    //    MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:image];
    
    // 通过配置nowPlayingInfo的值来更新锁屏界面的信息
    infoCenter.nowPlayingInfo = @{
                                  // 歌曲名
                                  MPMediaItemPropertyTitle : @"西红柿",
                                  // 艺术家名
                                  MPMediaItemPropertyArtist : @"Integrated Chinese: Level 2, Part 1",
                                  // 专辑名字
                                  //                                  MPMediaItemPropertyAlbumTitle : music.album,
                                  // 歌曲总时长
                                  //                                  MPMediaItemPropertyPlaybackDuration : @(duration),
                                  // 歌曲的当前时间
                                  //                                  MPNowPlayingInfoPropertyElapsedPlaybackTime : @(currentTime),
                                  // 歌曲的插图, 类型是MPMeidaItemArtwork对象
                                  //                                  MPMediaItemPropertyArtwork : artwork,
                                  
                                  // 无效的, 歌词的展示是通过图片绘制完成的, 即将歌词绘制到歌曲插图, 通过更新插图来实现歌词的更新的
                                  // MPMediaItemPropertyLyrics : lyric.content,
                                  };
}


#pragma mark - lazy
- (AVPlayer *)player {
    if (!_player) {
        _player = [[AVPlayer alloc] init];
    }
    return _player;
}

@end

//
//  SWAudioPlayer.h
//  Demo
//
//  Created by 李长浩 on 2017/7/12.
//  Copyright © 2017年 huayutime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWAudioPlayer : NSObject

+ (instancetype)player;

// 根据url播放音频
- (void)playWithURL:(NSURL *)url;

// 播放
- (void)play;

// 暂停
- (void)pause;

// 设置音频在后台及静音模式下播放
+ (void)audioPlayInBackground;


@end

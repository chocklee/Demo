//
//  SWAudioRecorder.h
//  Demo
//
//  Created by 李长浩 on 2017/7/13.
//  Copyright © 2017年 huayutime. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SWAudioRecorderDelegate <NSObject>

@optional
- (void)getCurrentRecorderSecond:(NSUInteger)second;

@end

@interface SWAudioRecorder : NSObject

@property (nonatomic, weak) id<SWAudioRecorderDelegate> delegate;

// 开始录音
- (void)startRecord;

// 停止录音
- (void)stopRecord;

// 播放录音
- (void)playRecord;

@end

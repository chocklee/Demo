//
//  SWNetworkStatus.h
//  Demo
//
//  Created by 李长浩 on 2017/7/13.
//  Copyright © 2017年 huayutime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWNetworkStatus : NSObject

// 实时监测网络状态
+ (void)monitorNetworkStatus;

// 获取当前最新网络状态
+ (void)getCurrentNetworkStatus;


@end

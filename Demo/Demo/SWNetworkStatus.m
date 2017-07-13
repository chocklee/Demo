//
//  SWNetworkStatus.m
//  Demo
//
//  Created by 李长浩 on 2017/7/13.
//  Copyright © 2017年 huayutime. All rights reserved.
//

#import "SWNetworkStatus.h"
#import <PPNetworkHelper.h>

@implementation SWNetworkStatus

// 实时监测网络状态
+ (void)monitorNetworkStatus {
    // 网络状态改变一次, networkStatusWithBlock就会响应一次
    [PPNetworkHelper networkStatusWithBlock:^(PPNetworkStatusType networkStatus) {
        switch (networkStatus) {
                // 未知网络
            case PPNetworkStatusUnknown:
                // 无网络
            case PPNetworkStatusNotReachable:
                NSLog(@"无网络");
                break;
                // 手机网络
            case PPNetworkStatusReachableViaWWAN:
                NSLog(@"手机网络");
                break;
                // 无线网络
            case PPNetworkStatusReachableViaWiFi:
                NSLog(@"无线网络");
                break;
        }
    }];
}

// 获取当前最新网络状态
+ (void)getCurrentNetworkStatus {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (kIsNetwork) {
            if (kIsWWANNetwork) {
                NSLog(@"手机网络");
            } else if (kIsWiFiNetwork){
                NSLog(@"WiFi网络");
            }
        } else {
            NSLog(@"无网络");
        }
    });
}

@end

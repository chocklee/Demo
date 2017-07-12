//
//  AppDelegate.m
//  Demo
//
//  Created by 李长浩 on 2017/7/12.
//  Copyright © 2017年 huayutime. All rights reserved.
//

#import "AppDelegate.h"
#import <PPNetworkHelper.h>
#import <AVFoundation/AVFoundation.h>
#import "SWAudioPlayer.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 实时监测网络状态
    [self monitorNetworkStatus];
    
    [self audioPlayInBackground];
    
    return YES;
}

- (void)monitorNetworkStatus {
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

// 设置音频在后台及静音模式下播放
- (void)audioPlayInBackground {
    // 获取音频的会话
    AVAudioSession *session = [AVAudioSession sharedInstance];
    // 设置后台播放类型
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    // 激活会话
    [session setActive:YES error:nil];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

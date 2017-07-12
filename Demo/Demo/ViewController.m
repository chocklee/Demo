//
//  ViewController.m
//  Demo
//
//  Created by 李长浩 on 2017/7/12.
//  Copyright © 2017年 huayutime. All rights reserved.
//

#import "ViewController.h"
#import <YYText.h>
#import "SWPinyinRichText.h"
#import "SWHTTPRequest.h"
#import <PPNetworkHelper.h>
#import "SWAudioPlayer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    YYLabel *label = [[YYLabel alloc] init];
//    NSMutableAttributedString *text = [SWPinyinRichText pinyinRichTextWithHanzi:@"签证" andErrorSounds:@[@"eng"] MissedSounds:@[@"zh"]];
//    text.yy_font = [UIFont boldSystemFontOfSize:30];
//    label.attributedText = text;
//    [label sizeToFit];
//    label.center = self.view.center;
//    [self.view addSubview:label];

    
    // 开启日志打印
    //    [PPNetworkHelper openLog];
    // 获取网络缓存大小
    //    NSLog(@"网络缓存大小cache = %fKB",[PPNetworkCache getAllHttpCacheSize] / 1024.f);
    // 清理缓存
    //    [PPNetworkCache removeAllHttpCache];
    
//    NSDictionary *params = @{@"account":@"teacher05@anhui", @"password":@"123456"};
//    [SWHTTPRequest getLoginWithParameters:params success:^(NSDictionary *response) {
//        NSLog(@"%@", response);
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self getCurrentNetworkStatus];
//    });
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"music" ofType:@"mp3"];
    [[SWAudioPlayer player] playWithURL:[NSURL fileURLWithPath:path]];
}

#pragma mark - 一次性获取当前最新网络状态
- (void)getCurrentNetworkStatus {
    if (kIsNetwork) {
        if (kIsWWANNetwork) {
            NSLog(@"手机网络");
        } else if (kIsWiFiNetwork){
            NSLog(@"WiFi网络");
        }
    } else {
        NSLog(@"无网络");
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

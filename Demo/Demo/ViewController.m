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
#import "SWNetworkStatus.h"
#import "SWAudioRecorder.h"

@interface ViewController () <SWAudioRecorderDelegate>

@property (nonatomic, strong) SWAudioRecorder *recorder;

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
    
//    [SWNetworkStatus getCurrentNetworkStatus];
//    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"music" ofType:@"mp3"];
//    [[SWAudioPlayer player] playWithURL:[NSURL fileURLWithPath:path]];
    
    self.recorder = [[SWAudioRecorder alloc] init];
    self.recorder.delegate = self;
}

- (void)getCurrentRecorderSecond:(NSUInteger)second {
    NSLog(@"%lu", second);
}

- (IBAction)startRecord:(id)sender {
    [self.recorder startRecord];
}

- (IBAction)stopRecord:(id)sender {
    [self.recorder stopRecord];
}

- (IBAction)playRecord:(id)sender {
    [self.recorder playRecord];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

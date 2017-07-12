//
//  SWPinyinRichText.h
//  Demo
//
//  Created by 李长浩 on 2017/7/12.
//  Copyright © 2017年 huayutime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWPinyinRichText : NSObject

/**
 根据汉字和错误音、漏掉音转成拼音的属性字符串

 @param hanzi 汉字
 @param errorSounds 错误音数组
 @param missedSounds 漏掉音数组
 @return 拼音的属性字符串
 */
+ (NSMutableAttributedString *)pinyinRichTextWithHanzi:(NSString *)hanzi andErrorSounds:(NSArray *)errorSounds MissedSounds:(NSArray *)missedSounds;

@end

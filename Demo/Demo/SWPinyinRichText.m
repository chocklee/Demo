//
//  SWPinyinRichText.m
//  Demo
//
//  Created by 李长浩 on 2017/7/12.
//  Copyright © 2017年 huayutime. All rights reserved.
//

#import "SWPinyinRichText.h"
#import <UIKit/UIKit.h>

@implementation SWPinyinRichText

+ (NSMutableAttributedString *)pinyinRichTextWithHanzi:(NSString *)hanzi andErrorSounds:(NSArray *)errorSounds MissedSounds:(NSArray *)missedSounds {
    
    // 汉字转带声调的拼音
    NSMutableString *pinyin = hanzi.mutableCopy;
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    
    // 拼音转属性字符串
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:pinyin];
    
    // 取range时将拼音的声调去掉
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    
    for (NSString *errorSound in errorSounds) {
        // 错误音range
        NSRange errorSoundRange = [pinyin rangeOfString:errorSound];
        if (errorSoundRange.location != NSNotFound) {
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:errorSoundRange];
        }
    }
    
    for (NSString *missedSound in missedSounds) {
        // 漏掉音range
        NSRange missedSoundRange = [pinyin rangeOfString:missedSound];
        if (missedSoundRange.location != NSNotFound) {
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:missedSoundRange];
        }
    }

    return attributedString;
}

@end

//
//  SWInterfacedConst.h
//  Demo
//
//  Created by 李长浩 on 2017/7/12.
//  Copyright © 2017年 huayutime. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 将项目中所有的接口写在这里,方便统一管理,降低耦合
 
 这里通过宏定义来切换当前的服务器类型,
 将要切换的服务器类型宏后面置为真(即>0即可),其余为假(置为0)
 */
#define DevelopSever 1
#define TestSever    0
#define ProductSever 0

// 接口前缀
UIKIT_EXTERN NSString *const kApiPrefix;

#pragma mark - 登录
// 登录
UIKIT_EXTERN NSString *const kLogin;

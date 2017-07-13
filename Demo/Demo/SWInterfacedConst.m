//
//  SWInterfacedConst.m
//  Demo
//
//  Created by 李长浩 on 2017/7/12.
//  Copyright © 2017年 huayutime. All rights reserved.
//

#import "SWInterfacedConst.h"

#if DevelopSever
// 接口前缀-开发服务器
NSString *const kApiPrefix = @"";

#elif TestSever
// 接口前缀-测试服务器
NSString *const kApiPrefix = @"";

#elif ProductSever
// 接口前缀-生产服务器
NSString *const kApiPrefix = @"";

#endif

#pragma mark - 登录
NSString *const kLogin = @"";

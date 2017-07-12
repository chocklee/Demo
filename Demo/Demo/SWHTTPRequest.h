//
//  SWHTTPRequest.h
//  Demo
//
//  Created by 李长浩 on 2017/7/12.
//  Copyright © 2017年 huayutime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWHTTPRequest : NSObject

/** 
 缓存的Block
 
 @param responseCache 返回缓存数据
 */
typedef void(^SWRequestCache)(id responseCache);
/**
 请求成功的block

 @param response 返回数据
 */
typedef void(^SWRequestSuccess)(id response);
/**
 请求失败的block
 
 @param error 错误信息
 */
typedef void(^SWRequestFailure)(NSError *error);

#pragma mark - 登录
+ (void)getLoginWithParameters:(NSDictionary *)parameters success:(SWRequestSuccess)success failure:(SWRequestFailure)failure;

@end

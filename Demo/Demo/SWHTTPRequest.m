//
//  SWHTTPRequest.m
//  Demo
//
//  Created by 李长浩 on 2017/7/12.
//  Copyright © 2017年 huayutime. All rights reserved.
//

#import "SWHTTPRequest.h"
#import "SWInterfacedConst.h"
#import <PPNetworkHelper.h>

@implementation SWHTTPRequest

#pragma mark - 登录
+ (void)getLoginWithParameters:(NSDictionary *)parameters success:(SWRequestSuccess)success failure:(SWRequestFailure)failure {
    [self postRequestWithURL:kLogin parameters:parameters responseCache:nil success:^(id response) {
        success(response);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - 请求的公共方法
+ (NSURLSessionTask *)postRequestWithURL:(NSString *)URL parameters:(NSDictionary *)parameter responseCache:(PPHttpRequestCache)responseCache success:(SWRequestSuccess)success failure:(SWRequestFailure)failure {
    // 将请求前缀与请求路径拼接成一个完整的url
    NSString *url = [NSString stringWithFormat:@"%@%@",kApiPrefix,URL];
    return [PPNetworkHelper POST:url parameters:parameter responseCache:responseCache success:^(id responseObject) {
        // 在这里你可以根据项目自定义其他一些重复操作,比如加载页面时候的等待效果, 提醒弹窗....
        success(responseObject);
    } failure:^(NSError *error) {
        // 在这里你可以根据项目自定义其他一些重复操作,比如加载页面时候的等待效果, 提醒弹窗....
        failure(error);
    }];
}

+ (NSURLSessionTask *)getRequestWithURL:(NSString *)URL parameters:(NSDictionary *)parameter responseCache:(PPHttpRequestCache)responseCache success:(SWRequestSuccess)success failure:(SWRequestFailure)failure {
    NSString *url = [NSString stringWithFormat:@"%@%@",kApiPrefix,URL];
    return [PPNetworkHelper GET:url parameters:parameter responseCache:responseCache success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

@end

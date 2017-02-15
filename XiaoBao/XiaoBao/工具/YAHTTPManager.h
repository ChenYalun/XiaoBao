//
//  YAHTTPManager.h
//  NanDe
//
//  Created by 陈亚伦 on 2017/2/13.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
//请求成功回调block
typedef void (^requestSuccessBlock)(id responseObject);

//请求失败回调block
typedef void (^requestFailureBlock)(NSError *error);

//请求方法
typedef NS_ENUM(NSUInteger, YAHTTPMethod) {
    GET,
    POST,
    PUT,
    DELETE,
    HEAD
};



@interface YAHTTPManager : AFHTTPSessionManager


// 单例manager
+ (instancetype)sharedManager;

/**
 发送网络请求

 @param method 请求方法类型
 @param path 请求路径
 @param parameters 参数
 @param success 成功回调
 @param failure 失败回调
 */
- (void)requestWithMethod:(YAHTTPMethod)method
                 WithPath:(NSString *)path
               WithParameters:(NSDictionary *)parameters
         WithSuccessBlock:(requestSuccessBlock)success
          WithFailurBlock:(requestFailureBlock)failure;
@end

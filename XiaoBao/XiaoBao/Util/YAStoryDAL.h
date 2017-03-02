//
//  YAStoryDAL.h
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/3/2.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm.h>
#import "YAStoryItem.h"

// 获取最新story成功回调,返回模型数组以及dateID便于下次请求
typedef void(^obtainNewStorySuccessBlock)(NSArray <YAStoryItem *> * topStoryItems, NSArray <YAStoryItem *> * storyItems, NSString *dateID);

// 获取往日story成功回调,返回模型数组以及dateID便于下次请求
typedef void(^obtainStorySuccessBlock)(NSArray <YAStoryItem *> * storyItems, NSString *dateID);
// 获取story失败回调
typedef void(^obtainStoryFailureBlock)(NSError *error);

@interface YAStoryDAL : NSObject

// 获取最新数据
+ (void)obtainNewStoryItemsWithSuccessBlock:(obtainNewStorySuccessBlock)successBlock failureBlock:(obtainStoryFailureBlock)failureBlock;

// 获取往日数据
+ (void)obtainStoryItemsWithDateID:(NSString *)date successBlock:(obtainStorySuccessBlock)successBlock failureBlock:(obtainStoryFailureBlock)failureBlock;
@end

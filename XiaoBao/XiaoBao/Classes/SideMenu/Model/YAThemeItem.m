//
//  YAThemeItem.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/18.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YAThemeItem.h"
#import <MJExtension.h>

@implementation YAThemeItem

#pragma mark - event response

// 关键字替换
+ (NSDictionary *)mj_replacedKeyFromPropertyName { // 自己打算使用新的替换旧的
    return @{@"desc" : @"description", @"ID" : @"id"};
}

// 快速字典转模型
+ (NSArray<YAThemeItem *> *)setupThemeItemsWithArray:(NSArray *)array {
    NSArray *itemArray = [YAThemeItem mj_objectArrayWithKeyValuesArray:array];
    
    // 对图片url进行防盗链处理
    for (YAThemeItem *item in itemArray) {
        NSString *url = [@"http://read.html5.qq.com/image?src=forum&q=5&r=0&imgflag=7&imageUrl=" stringByAppendingString:item.thumbnail];
        item.thumbnail = url;
    }
    return itemArray;
    
}

+ (NSArray<YAThemeItem *> *)themeItemsWithOtherKeyValues:(id)responseObject {
    return [YAThemeItem  setupThemeItemsWithArray:responseObject[@"others"]];
}

+ (NSArray<YAThemeItem *> *)themeItemsWithSubscribedKeyValues:(id)responseObject {
    return [YAThemeItem  setupThemeItemsWithArray:responseObject[@"subscribed"]];
}


@end

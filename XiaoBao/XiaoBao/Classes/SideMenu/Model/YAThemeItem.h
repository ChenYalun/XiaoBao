//
//  YAThemeItem.h
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/18.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YAThemeItem : NSObject
/** 缩略图 */
@property (nonatomic,copy) NSString *thumbnail;
/** 主题名称 */
@property (nonatomic,copy) NSString *name;
/** 主题描述 */
@property (nonatomic,copy) NSString *desc;
/** 主题id */
@property (nonatomic,copy) NSString *ID;


// 字典转模型
// 未订阅
+ (NSArray <YAThemeItem *> *)themeItemsWithOtherKeyValues:(id)responseObject;
// 已经订阅
+ (NSArray <YAThemeItem *> *)themeItemsWithSubscribedKeyValues:(id)responseObject;
@end

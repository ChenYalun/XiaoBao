//
//  YAStoryItem.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/15.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YAStoryItem.h"
#import <MJExtension.h>

@implementation YAStoryItem


#pragma mark - 数据库相关
//主键
+ (NSString *)primaryKey {
    return @"ID";
}

//需要添加索引的属性
+ (NSArray *)indexedProperties {
    return @[@"storyDate"];
}

//一般来说,属性为nil的话realm会抛出异常,但是如果实现了这个方法的话,就只有ID为nil会抛出异常,也就是说现在其他属性可以为空了
+ (NSArray *)requiredProperties {
    return @[@"ID"];
}

// 忽略属性images
+ (NSArray *)ignoredProperties {
    return @[@"images"];
}

#pragma mark - event response

// 替换关键字
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

+ (NSArray <YAStoryItem *> *)storyItemsWithKeyValues:(id)responseObject {
    NSArray *stories = [YAStoryItem mj_objectArrayWithKeyValuesArray:responseObject[@"stories"]];
    [stories enumerateObjectsUsingBlock:^(YAStoryItem *  _Nonnull storyItem, NSUInteger idx, BOOL * _Nonnull stop) {
        // 每个story添加日期属性
        storyItem.storyDate = responseObject[@"date"];
        
        // 每个story添加images属性
        RLMArray *objectImages = [[RLMArray alloc] initWithObjectClassName:[YAImageObject className]];
        [storyItem.images enumerateObjectsUsingBlock:^(NSString * _Nonnull imageURL, NSUInteger idx, BOOL * _Nonnull stop) {
            YAImageObject *object = [[YAImageObject alloc] init];
            object.url = imageURL;
            [objectImages addObject:object];
        }];
        [storyItem.imageUrls addObjects:objectImages];
    }];
    return stories;
}

+ (NSArray <YAStoryItem *> *)topStoryItemWithKeyValues:(id)responseObject {
    NSArray *array = [YAStoryItem mj_objectArrayWithKeyValuesArray:responseObject[@"top_stories"]];
    return array;
}

// 格式化时间字符串
+ (NSString *)formatStringWithDateString:(NSString *)string {
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSDate *date = [formatter dateFromString:string];
    
    NSString *firstString = [NSString stringWithFormat:@"%02ld月%02ld日",date.month,date.day];
    [formatter setDateFormat:@"EEEE"];
    
    return [NSString stringWithFormat:@"%@ %@",firstString,[formatter stringFromDate:date]];
}


@end

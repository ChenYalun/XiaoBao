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

#pragma mark - event response

// 替换关键字
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

+ (NSArray <YAStoryItem *> *)storyItemsWithKeyValues:(id)responseObject {
    NSArray *array = [YAStoryItem mj_objectArrayWithKeyValuesArray:responseObject[@"stories"]];
    return array;
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

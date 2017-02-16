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

+ (NSString *)formatStringWithDateString:(NSString *)string {
//    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyyMMdd"];
//    NSString * dateStr = @"20170214";
//    
//    NSDate * date = [formatter dateFromString:dateStr];
//    
    
    
    return string;
}
@end

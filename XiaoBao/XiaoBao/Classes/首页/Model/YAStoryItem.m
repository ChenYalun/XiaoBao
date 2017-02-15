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
+ (NSArray *)storyItemsWithKeyValues:(id)responseObject {
    NSArray *array = [YAStoryItem mj_objectArrayWithKeyValuesArray:responseObject[@"stories"]];
    return array;
}

+ (NSArray *)topStoryItemWithKeyValues:(id)responseObject {
    NSArray *array = [YAStoryItem mj_objectArrayWithKeyValuesArray:responseObject[@"top_stories"]];
    return array;
}

+ (NSString *)formatStringWithDateString:(NSString *)string {
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString * dateStr = @"20170214";
    
    NSDate * date = [formatter dateFromString:dateStr];
    
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]; // 指定日历的算法
     [calendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSDateComponents *comps = [calendar components:NSWeekdayCalendarUnit fromDate:date];
    
    return [NSString stringWithFormat:@"%ld",comps.weekday];
}
@end

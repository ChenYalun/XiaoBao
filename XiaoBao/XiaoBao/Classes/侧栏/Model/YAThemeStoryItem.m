//
//  YAThemeStoryItem.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/19.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YAThemeStoryItem.h"
#import <MJExtension.h>
@implementation YAThemeStoryItem
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"desc" :@"description"};
}

+ (YAThemeStoryItem *)themeStoryItemWithKeyValues:(id)responseObject {
    YAThemeStoryItem *themeStoryItem = [YAThemeStoryItem mj_objectWithKeyValues:responseObject];
    
    NSArray *stories = [YAStoryItem mj_objectArrayWithKeyValuesArray:responseObject[@"stories"]];
    [themeStoryItem.stories removeAllObjects];
    [themeStoryItem.stories addObjectsFromArray:stories];
    return themeStoryItem;
}
@end

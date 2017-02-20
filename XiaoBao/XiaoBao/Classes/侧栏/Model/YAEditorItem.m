//
//  YAEditorItem.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/20.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YAEditorItem.h"
#import <MJExtension.h>
@implementation YAEditorItem
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

+ (NSArray<YAEditorItem *> *)itemsWithKeyValues:(id)responseObject {
    return  [YAEditorItem mj_objectArrayWithKeyValuesArray:responseObject[@"editors"]];
}
@end

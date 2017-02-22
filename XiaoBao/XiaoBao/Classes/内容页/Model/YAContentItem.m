//
//  YAContentItem.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/22.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YAContentItem.h"
#import <MJExtension.h>
@implementation YAContentItem
+ (instancetype)contentItemWithKeyValues:(id)responseObject {
    return [YAContentItem mj_objectWithKeyValues:responseObject];
}
@end

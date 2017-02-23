//
//  YACommentModel.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/23.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YACommentModel.h"
#import <MJExtension.h>
@implementation YACommentModel
+ (NSMutableArray <YACommentModel *> *)commentModelWithKeyValues:(id)responseObject {
    NSArray *items = [YACommentItem mj_objectArrayWithKeyValuesArray:responseObject[@"comments"]];
    NSMutableArray *models = [NSMutableArray array];
    [items enumerateObjectsUsingBlock:^(YACommentItem *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    YACommentModel *model = [[YACommentModel alloc] init];
        model.avatar = obj.avatar;
        model.content = obj.content;
        model.author = obj.author;
        model.likes = obj.likes;
        model.time = @"02-20 14:25";
        
        
        
        
        [models addObject:model];
    }];
    
    return models;
}
@end

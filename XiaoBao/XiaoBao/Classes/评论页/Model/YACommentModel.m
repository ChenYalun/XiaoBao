//
//  YACommentModel.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/23.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YACommentModel.h"
#import <MJExtension.h>
#import "YACommentItem.h"
@implementation YACommentModel
+ (NSMutableArray <YACommentModel *> *)commentModelWithKeyValues:(id)responseObject {
    NSArray *items = [YACommentItem mj_objectArrayWithKeyValuesArray:responseObject[@"comments"]];
    NSMutableArray *models = [NSMutableArray array];
    [items enumerateObjectsUsingBlock:^(YACommentItem *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    YACommentModel *model = [[YACommentModel alloc] init];
        // 评论本人
        model.avatar = obj.avatar;
        model.content = obj.content;
        model.author = obj.author;
        model.likes = obj.likes;
        model.time = @"02-20 14:25";
        
        // 回复
        //model.replyName = obj.reply_to.author;
        model.replyContent = obj.reply_to.content;
        
        // 标记展开
        model.isOpen = NO;
        
        [models addObject:model];
    }];
    
    return models;
}
@end

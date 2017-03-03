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

 #pragma mark – Life Cycle

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
        model.time = [model changeDate:obj.time];
        
        // 回复
        if (obj.reply_to.content && obj.reply_to.author) {
            NSMutableAttributedString *reply = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"//%@:  ",obj.reply_to.author] attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:15.0]}];
            NSAttributedString *content = [[NSMutableAttributedString alloc] initWithString:obj.reply_to.content attributes:@{NSForegroundColorAttributeName : [UIColor darkGrayColor]}];
            
            [reply appendAttributedString:content];
            
            model.replyContent = reply;
        }

        
        // 标记展开
        model.isOpen = NO;
        
        [models addObject:model];
    }];
    
    return models;
}

 #pragma mark – Private Methods

// 时间戳转标准时间
-(NSString *)changeDate:(NSString *)utc{
    
    NSTimeInterval time = [utc doubleValue];
    
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:time];
    
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"MM-dd HH:mm"];
    
    NSString *staartstr=[dateformatter stringFromDate:date];
    
    return staartstr;
    
}

@end

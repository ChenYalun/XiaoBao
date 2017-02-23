//
//  YACommentItem.h
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/23.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YACommentItem : NSObject
/** 作者名称 */
@property (nonatomic,copy) NSString *author;
/** 内容 */
@property (nonatomic,copy) NSString *content;
/** 头像 */
@property (nonatomic,copy) NSString *avatar;
/** 时间 */
@property (nonatomic,copy) NSString *time;
/** 点赞 */
@property (nonatomic,copy) NSString *likes;

/** 回复者 */
@property (nonatomic,strong) YACommentItem *reply;


@end

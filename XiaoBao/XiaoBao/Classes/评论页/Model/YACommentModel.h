//
//  YACommentModel.h
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/23.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface YACommentModel : NSObject
/** 作者名称 */
@property (nonatomic,copy) NSString *author;
/** 内容 */
@property (nonatomic,copy) NSString *content;
/** 头像 */
@property (nonatomic,copy) NSString *avatar;
/** 时间戳 */
@property (nonatomic,copy) NSString *time;
/** 点赞 */
@property (nonatomic,copy) NSString *likes;
/** 是否展开 */
@property (nonatomic,assign) BOOL isOpen;
/** 回复者内容 */
@property (nonatomic,copy) NSAttributedString *replyContent;
// 字典转模型
+ (NSMutableArray <YACommentModel *> *)commentModelWithKeyValues:(id)responseObject;
@end

//
//  YAExtraItem.h
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/23.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YAExtraItem : NSObject
/** 长评论 */
@property (nonatomic,copy) NSString *long_comments;
/** 点赞 */
@property (nonatomic,copy) NSString *popularity;
/** 短评论 */
@property (nonatomic,copy) NSString *short_comments;
/** 总评论数 */
@property (nonatomic,copy) NSString *comments;
// 字典转模型
+ (instancetype)extraItemWithKeyValues:(id)responseObject;
@end

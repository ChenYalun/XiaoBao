//
//  YAEditorItem.h
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/20.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YAEditorItem : NSObject
/** 知乎地址 */
@property (nonatomic,copy) NSString *url;
/** bio */
@property (nonatomic,copy) NSString *bio;
/** 头像地址 */
@property (nonatomic,copy) NSString *avatar;
/** 编号id */
@property (nonatomic,copy) NSString *ID;
/** 名字 */
@property (nonatomic,copy) NSString *name;

+ (NSArray <YAEditorItem *> *)itemsWithKeyValues:(id)responseObject;
@end

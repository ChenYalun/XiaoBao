//
//  YACommentHeader.h
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/24.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YACommentHeader : UIView
// 快速创建
+ (instancetype)commentHeaderWithIndexPath:(NSInteger)section itemsCount:(NSInteger)count;

@end

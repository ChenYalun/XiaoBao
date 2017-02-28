//
//  YAThemeTableViewHeader.h
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/20.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YAEditorItem.h"

@interface YAThemeTableViewHeader : UIView

/** editors */
@property (nonatomic,strong) NSArray <YAEditorItem *> *editors;

// 快速创建
+ (instancetype)header;
@end

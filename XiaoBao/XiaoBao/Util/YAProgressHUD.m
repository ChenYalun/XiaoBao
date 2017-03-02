//
//  YAProgressHUD.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/16.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YAProgressHUD.h"
#import <SVProgressHUD.h>

@implementation YAProgressHUD

#pragma mark – Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        // 样式
        self.defaultStyle = SVProgressHUDStyleDark;
        
        // 消失时间
        self.minimumDismissTimeInterval = 2.0;
        
        // 字体
        self.font = [UIFont boldSystemFontOfSize:18];
    }
    return self;
}

@end

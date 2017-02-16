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

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.defaultStyle = SVProgressHUDStyleDark;
    }
    return self;
}

@end

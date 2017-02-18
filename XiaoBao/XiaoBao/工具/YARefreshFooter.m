//
//  YARefreshFooter.m
//  NanDe
//
//  Created by 陈亚伦 on 2017/2/13.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YARefreshFooter.h"

@implementation YARefreshFooter

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 隐藏刷新文字
        self.refreshingTitleHidden = YES;
    }
    return self;
}

@end

//
//  YARefreshFooter.m
//  NanDe
//
//  Created by 陈亚伦 on 2017/2/13.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YARefreshFooter.h"

@implementation YARefreshFooter

#pragma mark – Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 隐藏刷新文字
        self.refreshingTitleHidden = YES;
        
        // 设置文字
        [self setTitle:@"" forState:MJRefreshStateIdle];
        [self setTitle:@"" forState:MJRefreshStatePulling];
        [self setTitle:@"" forState:MJRefreshStateRefreshing];
        [self setTitle:@"" forState:MJRefreshStateWillRefresh];
        [self setTitle:@"" forState:MJRefreshStateNoMoreData];

    }
    return self;
}

@end

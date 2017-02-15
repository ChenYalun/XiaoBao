//
//  YARefreshHeader.m
//  NanDe
//
//  Created by 陈亚伦 on 2017/2/13.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YARefreshHeader.h"

@implementation YARefreshHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 自动切换透明度
        self.automaticallyChangeAlpha = YES;
        // 隐藏时间
        self.lastUpdatedTimeLabel.hidden = YES;
        // 设置文字
        [self setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
        [self setTitle:@"释放更新" forState:MJRefreshStatePulling];
        [self setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
    }
    return self;
}

@end

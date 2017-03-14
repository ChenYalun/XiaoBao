//
//  YAPhotoBrowser.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/3/14.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YAPhotoBrowser.h"

@implementation YAPhotoBrowser

- (instancetype)init {
    if (self = [super init]) {
        
        // 隐藏操作按钮
        self.displayActionButton = NO;
        // 隐藏箭头指示按钮
        self.displayArrowButton = NO;
        // 隐藏计数label
        self.displayCounterLabel = NO;
        // 隐藏完成按钮
        self.displayDoneButton = NO;
        // 点击退出浏览
        self.dismissOnTouch = YES;
        // 强制隐藏状态栏
        self.forceHideStatusBar = YES;
    }
    return self;
}
@end

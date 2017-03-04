//
//  YAPresentationController.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/3/4.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YAPresentationController.h"

@interface YAPresentationController ()
// 转场协调器
@property(nonatomic,strong)id <UIViewControllerTransitionCoordinator>transitionCoordinator;
// 暗黑背景
@property (nonatomic,strong) UIView *backgroundView;
@end
@implementation YAPresentationController

 #pragma mark – Events

//在呈现过渡即将开始的时候被调用的
- (void)presentationTransitionWillBegin{
    
    // 源控制器的View
    [self.containerView addSubview:self.presentingViewController.view];
    // 背景View
    [self.containerView addSubview:self.backgroundView];
    // 目标控制器View
    [self.containerView addSubview:self.presentedView];
    
    // 使用 presentingViewController 的 transitionCoordinator,
    // 背景 backgroundView 的淡入效果与过渡效果一起执行
    self.backgroundView.alpha = 0.0;
    self.transitionCoordinator = self.presentingViewController.transitionCoordinator;
    
    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.backgroundView.alpha = 0.7;
    } completion:nil];
    
}

//在呈现过渡结束时被调用的
//如果呈现没有完成，那就移除背景 View
- (void)presentationTransitionDidEnd:(BOOL)completed{
    if (!completed) {
        [self.backgroundView removeFromSuperview];
        
    }
}

//在退出过渡即将开始的时候被调用的
//我们在这个方法中把半透明黑色背景 View 做一个 alpha 从1到0的渐变过渡动画
- (void)dismissalTransitionWillBegin{
    // 与过渡效果一起执行背景 View 的淡出效果
    self.transitionCoordinator = self.presentingViewController.transitionCoordinator;
    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.backgroundView.alpha = 0;
    } completion:nil];
}

//在退出的过渡结束时被调用的
- (void)dismissalTransitionDidEnd:(BOOL)completed{
    if (completed) {
        [self.backgroundView removeFromSuperview];
    }
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.presentingViewController.view];
}

/*
调整呈现的View的frame
- (CGRect)frameOfPresentedViewInContainerView{
    
}
*/

 #pragma mark – Getters and Setters

- (UIView *)backgroundView {
    if (_backgroundView == nil) {
        _backgroundView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        
        // 暗色蒙版
        UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        blurView.frame = self.containerView.bounds;
        [_backgroundView insertSubview:blurView atIndex:0];
    }
    
    return _backgroundView;
}

@end

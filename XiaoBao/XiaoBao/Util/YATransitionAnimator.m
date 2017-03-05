//
//  YATransitionAnimator.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/3/4.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YATransitionAnimator.h"

#define kShareViewHeight 250
@interface YATransitionAnimator ()
@end

@implementation YATransitionAnimator

 #pragma mark – Life Cycle

+ (instancetype)transitionAnimatorWithType:(TransitionAnimatorType)transitionAnimatorType {
    YATransitionAnimator *animator = [[YATransitionAnimator alloc] init];
    animator.transitionAnimatorType = transitionAnimatorType;
    return animator;
}


#pragma mark - AnimatedTransitioning delegate

//返回动画时间
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 5.0;
}

//执行动画的地方
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {

    // 1.获取动画必要元素
    UIView *containerView = [transitionContext containerView];
    // fromeView要使用viewControllerForKey获取,否则为空
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    toView.origin = CGPointMake(0, kScreenHeight);
    // present时，要把toView加入到container的视图层级。
    // dismiss时，要把fromView从container的视图层级中移除。

    
    // 3.动画
    // 出场
    if (self.transitionAnimatorType == TransitionAnimatorPush) {
        // 2.添加toView,不一定是addSubview方式
        [containerView addSubview:toView];
        [UIView animateWithDuration:2.5 animations:^{
            toView.origin = CGPointMake(0, 0);
        } completion:^(BOOL finished) {
            // 完成
            [transitionContext completeTransition:YES];
        }];
    }


    // 消失
    if (self.transitionAnimatorType == TransitionAnimatorPop) {
        [UIView animateWithDuration:2.5 animations:^{
            fromView.origin = CGPointMake(0, kScreenHeight);
        } completion:^(BOOL finished) {
            // 2.添加toView,不一定是addSubview方式
            [fromView removeFromSuperview];
            // 完成
            [transitionContext completeTransition:YES];
        }];
    }

}

// 3.结果:完成或者取消(交互式)\
// BOOL isCancelled = transitionContext.transitionWasCancelled;
//考虑到转场中途可能取消的情况，转场结束后，恢复视图状态。
//    fromView.transform = CGAffineTransformIdentity;
//    toView.transform = CGAffineTransformIdentity;


/*
 // 可选 动画结束后调用
 - (void)animationEnded:(BOOL) transitionCompleted {
 
 }
 */


@end

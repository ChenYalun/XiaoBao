//
//  YATransitionAnimator.h
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/3/4.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TransitionAnimatorType) {
    TransitionAnimatorPresent,
    TransitionAnimatorDismiss,
};

@interface YATransitionAnimator : NSObject<UIViewControllerAnimatedTransitioning>
// 记录当前为present还是dismiss
@property (nonatomic,assign) TransitionAnimatorType transitionAnimatorType;

+ (instancetype)transitionAnimatorWithType:(TransitionAnimatorType)transitionAnimatorType;
@end

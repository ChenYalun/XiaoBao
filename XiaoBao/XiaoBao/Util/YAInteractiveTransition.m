//
//  YAInteractiveTransition.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/3/4.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YAInteractiveTransition.h"

@implementation YAInteractiveTransition


/*
 
 duration
 percentComplete
 completionSpeed
 completionCurve
 timingCurve
 
 wantsInteractiveStart

*/


// 交互控制器必须有动画控制器
- (instancetype)init {
    if (self = [super init]) {
        self.timingCurve = nil;
    }
    return self;
}

// 必须实现
- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
}

/*
// 更新交互
- (void)updateInteractiveTransition:(CGFloat)percentComplete {
    
}

// 暂停交互
- (void)pauseInteractiveTransition {
    
}

// 转场动画从当前的状态回拨到初始状态，转场取消
- (void)cancelInteractiveTransition {
    
}

// 转场动画从当前的状态将继续进行直到动画结束，转场完成
- (void)finishInteractiveTransition {
    
}
*/

@end

//
//  YARefreshHeader.m
//  NanDe
//
//  Created by 陈亚伦 on 2017/2/13.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YARefreshHeader.h"
#import <Foundation/Foundation.h>
#define kRefreshViewWH 20
@interface YARefreshHeader()

@property(nonatomic, weak) UIActivityIndicatorView *indicatorView;
@property(nonatomic, weak) CAShapeLayer *whiteCircleLayer;
@property(nonatomic, weak) CAShapeLayer *grayCircleLayer;
@property (nonatomic,weak) UIPanGestureRecognizer *pan;
/** scrollView偏移量Y */
@property (nonatomic,assign) CGFloat attachViewOffsetY;

/** 回调对象 */
@property (weak, nonatomic) id refreshingTarget;
/** 回调方法 */
@property (assign, nonatomic) SEL refreshingAction;
@end
@implementation YARefreshHeader

    
    /*
     strong属性--
     UIButton *b = [[UIButton alloc] init];
     _bu = b;
     方法经过后,对其引用计数减一
     引用计数为2
     _bu = [[UIButton alloc] init];
     引用计数为2
     效果上,是否加入新的引用都可以,不影响最终的引用计数,关键在于属性
     
     weak属性--
     UIButton *b = [[UIButton alloc] init];
     _bu = b;
     对象为空
     
     
     
     若没有其他引用,用strong
     有其他引用,比如加到子控件上,用weak
     */
#pragma mark - 属性设置
- (void)setAttachScrollView:(UIScrollView *)attachScrollView {
    _attachScrollView = attachScrollView;
    // 如果为空返回
    if (attachScrollView) {
        // 添加监听
        [self addObservers];

    }
}

#pragma mark - 控件懒加载
- (UIActivityIndicatorView *)indicatorView {
    if (_indicatorView == nil) {
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:self.bounds];
        [self addSubview:indicatorView];
        
        _indicatorView = indicatorView;
    }
    return _indicatorView;
}

- (CAShapeLayer *)whiteCircleLayer {
    if (_whiteCircleLayer == nil) {
        CAShapeLayer *whiteCircleLayer = [CAShapeLayer layer];
        whiteCircleLayer.lineWidth = 1.f;
        whiteCircleLayer.strokeColor = [UIColor whiteColor].CGColor;
        whiteCircleLayer.fillColor = [UIColor clearColor].CGColor;
        whiteCircleLayer.opacity = 0;
        whiteCircleLayer.strokeEnd = 0;
        whiteCircleLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width/2, self.width/2)
                                                               radius:self.width/2
                                                           startAngle:M_PI_2 endAngle:M_PI * 5 / 2
                                                            clockwise:YES].CGPath;
        [self.layer addSublayer:whiteCircleLayer];
        
        _whiteCircleLayer = whiteCircleLayer;
    }
    return _whiteCircleLayer;
}

- (CAShapeLayer *)grayCircleLayer {
    if (_grayCircleLayer == nil) {
        CAShapeLayer *grayCircleLayer = [CAShapeLayer layer];
        // 线宽
        grayCircleLayer.lineWidth = 1.f;
        // 画笔颜色[UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:0.3].CGColor;
        grayCircleLayer.strokeColor = kRGBAColor(215, 215, 215, 0.3).CGColor;
        // 填充
        grayCircleLayer.fillColor = [UIColor clearColor].CGColor;
        // 不透明度
        grayCircleLayer.opacity = 0;
        grayCircleLayer.path = [UIBezierPath bezierPathWithOvalInRect:self.bounds].CGPath;
        [self.layer addSublayer:grayCircleLayer];
        
        _grayCircleLayer = grayCircleLayer;
    }
    return _grayCircleLayer;
}


#pragma mark - 父类方法

- (void)dealloc {
   // self.attachScrollView remov
    [self removeObservers];
    
}


#pragma mark - KVO监听
NSString *const YARefreshKeyPathContentOffset = @"contentOffset";
NSString *const YARefreshKeyPathPanState = @"state";
- (void)addObservers
{
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.attachScrollView addObserver:self forKeyPath:YARefreshKeyPathContentOffset options:options context:nil];
    
    self.pan = self.attachScrollView.panGestureRecognizer;
    [self.pan addObserver:self forKeyPath:YARefreshKeyPathPanState options:options context:nil];
}

- (void)removeObservers
{
    [self.attachScrollView removeObserver:self forKeyPath:YARefreshKeyPathContentOffset];
    [self.attachScrollView removeObserver:self forKeyPath:YARefreshKeyPathPanState];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // 遇到这些情况就直接返回
    if (!self.userInteractionEnabled) return;
    
    
    if ([keyPath isEqualToString:YARefreshKeyPathContentOffset]) {
        [self scrollViewContentOffsetDidChange:change];
    }
    
    if ([keyPath isEqualToString:YARefreshKeyPathPanState]) {
        [self scrollViewPanStateDidChange:change];
    }

}


- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change{

    id newValue = [change objectForKey:NSKeyValueChangeNewKey];

    CGPoint newPoint = [newValue CGPointValue];
    CGFloat offsetY = newPoint.y;
    self.attachViewOffsetY = offsetY;
    // 头部刷新控件
    if (offsetY <= 0) {
        CGFloat pro = -offsetY / 60.0;
        self.hidden = NO;
        [self updateProgress:pro];
        
        // 返回顶部,停止动画
        if (offsetY == 0) {
            [self stopAnimation];
        }
        
    } else {
        self.hidden = YES;
    }
    

}

- (void)scrollViewPanStateDidChange:(NSDictionary *)change {
    id panState = [change objectForKey:NSKeyValueChangeNewKey];
    
    // 手指松开的那刻
    if ((NSNumber *)panState == [NSNumber numberWithInteger:UIGestureRecognizerStateEnded]) {
        CGFloat offsetY = self.attachViewOffsetY;
        // 开始动画并刷新
        if (-offsetY > 60.0) {
            [self startAnimation];
            [self beginRefreshing];
        }
    }

    
}



#pragma mark - 控件方法
-(void)updateProgress:(CGFloat)progress {
    if (progress <= 0) {
        self.whiteCircleLayer.opacity = 0;
        self.grayCircleLayer.opacity = 0;
    } else {
        self.whiteCircleLayer.opacity = 1;
        self.grayCircleLayer.opacity = 1;
    }
    
    if (progress > 1) {
        progress = 1;
    }
    self.whiteCircleLayer.strokeEnd = progress;
}

-(void)startAnimation {
    self.grayCircleLayer.hidden = YES;
    self.whiteCircleLayer.hidden = YES;
    [self.indicatorView startAnimating];
}

-(void)stopAnimation {
    self.grayCircleLayer.hidden = NO;
    self.whiteCircleLayer.hidden = NO;
    [self.indicatorView stopAnimating];
}

- (void)beginRefreshing {
   
    if ([self.refreshingTarget respondsToSelector:self.refreshingAction]) {
        kMsgSend(kMsgTarget(self.refreshingTarget),self.refreshingAction, self);
    };
}

#pragma mark - 控件创建
+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action {
    YARefreshHeader *header = [[YARefreshHeader alloc] initWithFrame:CGRectMake(100, 28, kRefreshViewWH, kRefreshViewWH)];
    [header setRefreshingTarget:target refreshingAction:action];
    return header;
}

- (void)setRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    self.refreshingTarget = target;
    self.refreshingAction = action;
}
@end

//
//  YARefreshHeader.m
//  NanDe
//
//  Created by 陈亚伦 on 2017/2/13.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YARefreshHeader.h"
@interface YARefreshHeader()

@property(nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property(nonatomic, weak) CAShapeLayer *whiteCircleLayer;
@property(nonatomic, weak) CAShapeLayer *grayCircleLayer;
@end

@implementation YARefreshHeader
- (UIActivityIndicatorView *)indicatorView {
    if (_indicatorView == nil) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:self.bounds];
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
       _whiteCircleLayer = whiteCircleLayer;
    }
    return _whiteCircleLayer;
}

- (CAShapeLayer *)grayCircleLayer {
    if (_grayCircleLayer == nil) {
        CAShapeLayer *grayCircleLayer = [CAShapeLayer layer];
        // 线宽
        grayCircleLayer.lineWidth = 1.f;
        // 画笔颜色
        grayCircleLayer.strokeColor = [UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:0.3].CGColor;
        // 填充
        grayCircleLayer.fillColor = [UIColor clearColor].CGColor;
        // 不透明度
        grayCircleLayer.opacity = 0;
        _grayCircleLayer = grayCircleLayer;
    }
    return _grayCircleLayer;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

#pragma mark - 设置子控件
- (void)setup {
   
    // 画圆
    self.grayCircleLayer.path = [UIBezierPath bezierPathWithOvalInRect:self.bounds].CGPath;
    
    self.whiteCircleLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width/2, self.width/2)
                                                                 radius:self.width/2
                                                             startAngle:M_PI_2 endAngle:M_PI * 5 / 2
                                                              clockwise:YES].CGPath;
    self.whiteCircleLayer.strokeEnd = 0;
    
    [self addSubview:self.indicatorView];
    [self.layer addSublayer:self.grayCircleLayer];
    [self.layer addSublayer:self.whiteCircleLayer];
}

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
@end

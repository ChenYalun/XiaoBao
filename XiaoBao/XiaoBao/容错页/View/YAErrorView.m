//
//  YAErrorView.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/26.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YAErrorView.h"
#import <POP.h>
@interface YAErrorView()



@end
@implementation YAErrorView

+ (instancetype)errorView {
    return [[YAErrorView alloc] init];
}



- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupLayerWithRadius:8 backgroundColor:[UIColor redColor] position:YES];
        
        [self setupLayerWithRadius:8 backgroundColor:kGlobalColor position:NO];

    }
    return self;
}


#pragma mark - 设置小球
- (void)setupLayerWithRadius:(CGFloat)radius backgroundColor:(UIColor *)color position:(BOOL)p{
    
    CALayer *layer = [CALayer layer];
    layer.size = CGSizeMake(radius * 2, radius * 2);
    layer.masksToBounds = YES;
    layer.cornerRadius = radius;
    layer.backgroundColor = color.CGColor;
    [self.layer addSublayer:layer];
    
    CGPoint center = CGPointMake(kScreenWidth * 0.5, kScreenHeight * 0.5);
    CFTimeInterval duration = 1;
    
    // 位置
    POPBasicAnimation *positionAnimation = [POPBasicAnimation animationWithPropertyNamed:@"position"];
    
    if (p) {
        positionAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(center.x + 20, center.y)];
        positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(center.x - 20, center.y)];
    } else {
        positionAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(center.x - 20, center.y)];
        positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(center.x + 20, center.y)];
    }

    positionAnimation.beginTime = CACurrentMediaTime();
    positionAnimation.repeatForever = YES;
    positionAnimation.autoreverses = YES;
    positionAnimation.duration = duration;
    
    // 大小
    POPBasicAnimation *sizeAnimation = [POPBasicAnimation animationWithPropertyNamed:@"size"];
    sizeAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(radius * 2, radius * 2)];
    sizeAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(radius, radius)];
    sizeAnimation.beginTime = CACurrentMediaTime();
    sizeAnimation.repeatForever = YES;
    sizeAnimation.autoreverses = YES;
    sizeAnimation.duration = duration;
    
    // 圆角半径
    POPBasicAnimation *cornerRadiusAnimation = [POPBasicAnimation animationWithPropertyNamed:@"cornerRadius"];
    cornerRadiusAnimation.fromValue = [NSNumber numberWithDouble:radius];
    cornerRadiusAnimation.toValue = [NSNumber numberWithDouble:radius * 0.5];
    cornerRadiusAnimation.beginTime = CACurrentMediaTime();
    cornerRadiusAnimation.repeatForever = YES;
    cornerRadiusAnimation.autoreverses = YES;
    cornerRadiusAnimation.duration = duration;
    
    
    [layer pop_addAnimation:positionAnimation forKey:@"firstPositionAnimation"];
    [layer pop_addAnimation:sizeAnimation forKey:@"firstSizeAnimation"];
    [layer pop_addAnimation:cornerRadiusAnimation forKey:@"firstCornerRadiusAnimation"];
}

@end




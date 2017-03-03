//
//  UIView+YAExtension.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/18.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "UIView+YAExtension.h"

@implementation UIView (YAExtension)

 #pragma mark – Getters and Setters

- (void)setYa_x:(CGFloat)ya_x {
    CGRect frame = self.frame;
    frame.origin.x = ya_x;
    self.frame = frame;
}

- (CGFloat)ya_x {
    return self.frame.origin.x;
}
- (void)setYa_y:(CGFloat)ya_y
{
    CGRect frame = self.frame;
    frame.origin.y = ya_y;
    self.frame = frame;
}

- (CGFloat)ya_y
{
    return self.frame.origin.y;
}

- (void)setYa_w:(CGFloat)ya_w
{
    CGRect frame = self.frame;
    frame.size.width = ya_w;
    self.frame = frame;
}

- (CGFloat)ya_w
{
    return self.frame.size.width;
}

- (void)setYa_h:(CGFloat)ya_h
{
    CGRect frame = self.frame;
    frame.size.height = ya_h;
    self.frame = frame;
}

- (CGFloat)ya_h
{
    return self.frame.size.height;
}

- (void)setYa_size:(CGSize)ya_size
{
    CGRect frame = self.frame;
    frame.size = ya_size;
    self.frame = frame;
}

- (CGSize)ya_size
{
    return self.frame.size;
}

- (void)setYa_origin:(CGPoint)ya_origin
{
    CGRect frame = self.frame;
    frame.origin = ya_origin;
    self.frame = frame;
}

- (CGPoint)ya_origin
{
    return self.frame.origin;
}
@end



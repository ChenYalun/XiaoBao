//
//  UIBarButtonItem+MenuBarButtonItem.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/15.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "UIBarButtonItem+MenuBarButtonItem.h"

@implementation UIBarButtonItem (MenuBarButtonItem)

#pragma mark – Life Cycle

+ (instancetype)itemWithImage:(NSString *)image selectedImage:(NSString *)selImage target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:selImage] forState:UIControlStateSelected];
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[self alloc] initWithCustomView:button];
}
@end

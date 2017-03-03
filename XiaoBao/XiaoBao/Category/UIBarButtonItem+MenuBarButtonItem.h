//
//  UIBarButtonItem+MenuBarButtonItem.h
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/15.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (MenuBarButtonItem)

+ (instancetype)itemWithImage:(NSString *)image selectedImage:(NSString *)selImage target:(id)target action:(SEL)action;
@end

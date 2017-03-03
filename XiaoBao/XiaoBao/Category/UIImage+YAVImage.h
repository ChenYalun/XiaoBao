//
//  UIImage+YAVImage.h
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/3/2.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YAVImage)

// 返回高斯模糊图片
+ (UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

// 返回圆形图片
+(UIImage *)imageToRoundImageWithImage:(UIImage *)image;
@end

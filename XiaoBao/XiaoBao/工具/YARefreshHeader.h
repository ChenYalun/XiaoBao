//
//  YARefreshHeader.h
//  NanDe
//
//  Created by 陈亚伦 on 2017/2/13.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface YARefreshHeader : UIView
-(void)updateProgress:(CGFloat)progress;
-(void)startAnimation;
-(void)stopAnimation;
@end

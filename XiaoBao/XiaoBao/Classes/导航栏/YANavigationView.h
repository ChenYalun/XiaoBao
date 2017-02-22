//
//  YANavigationView.h
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/21.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YANavigationView : UIView
/** 回退按钮 */
@property (weak, nonatomic) IBOutlet UIButton *backButton;
/** 标题 */
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic,copy) NSString *title;
+ (instancetype)navigationViewWithTitle:(NSString *)title;
@end

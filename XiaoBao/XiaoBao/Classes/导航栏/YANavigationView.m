//
//  YANavigationView.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/21.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YANavigationView.h"

@interface YANavigationView()
/** 标题 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation YANavigationView

#pragma mark - 快速创建

+ (instancetype)navigationViewWithTitle:(NSString *)title {
    YANavigationView *navigationView =  [[NSBundle mainBundle] loadNibNamed:[YANavigationView className] owner:nil options:nil].firstObject;
    navigationView.frame = CGRectMake(0, 0, kScreenWidth, 64);
    navigationView.titleLabel.text = title;
    navigationView.activityIndicatorView.hidesWhenStopped = YES;
    [navigationView.backButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [navigationView.viewController.navigationController popViewControllerAnimated:YES];
    }];
    
    // 设置背景颜色
    navigationView.dk_backgroundColorPicker = DKColorPickerWithKey(NavigationViewBackgroundColor);
    
    return navigationView;
    
}

#pragma mark - get set
- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text =title;
}
@end

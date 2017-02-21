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
+ (instancetype)navigationViewWithTitle:(NSString *)title {
    YANavigationView *navigationView =  [[NSBundle mainBundle] loadNibNamed:[YANavigationView className] owner:nil options:nil].firstObject;
    navigationView.frame = CGRectMake(0, 0, kScreenWidth, 64);
    navigationView.titleLabel.text = title;
    
    [navigationView.backButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [navigationView.viewController.navigationController popViewControllerAnimated:YES];
    }];
    return navigationView;
    
}

@end

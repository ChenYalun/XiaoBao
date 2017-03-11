//
//  YAShareViewController.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/3/4.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YAShareViewController.h"
#import "YATransitionAnimator.h"

@interface YAShareViewController () 

@end

@implementation YAShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];


}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // 获取蒙版View
    UIView *backgroundView = self.view.superview.subviews.firstObject;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissViewController:)];
    [backgroundView addGestureRecognizer:tap];
}
- (IBAction)dismissViewController:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

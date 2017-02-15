//
//  YARootViewController.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/15.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YARootViewController.h"

@interface YARootViewController ()

@end

@implementation YARootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"];
    self.leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftMenuViewController"];

    self.parallaxEnabled = NO;  //视图差效果
    self.scaleContentView = YES;  //中心视图缩放功能打开
    self.contentViewScaleValue = 1;  //侧滑出现时缩放比
    self.scaleMenuView = NO;        //侧滑出来的视图是否支持缩放
    self.contentViewShadowEnabled = YES; //中心视图阴影效果，打开显得有层次感。
    self.contentViewShadowRadius = 4.5;  //中心视图阴影效果Radius
    self.panGestureEnabled = YES;   //关闭拖动支持手势
    self.contentViewInPortraitOffsetCenterX = 50;
    //    self.contentViewInLandscapeOffsetCenterX = 300;
    
    
    //    动画持续时间
    //    @property (assign, readwrite, nonatomic) NSTimeInterval animationDuration;
    //    菜单背景图片
    //    @property (strong, readwrite, nonatomic) UIImage *backgroundImage;
    //    @property (assign, readwrite, nonatomic) BOOL panGestureEnabled;
    //    @property (assign, readwrite, nonatomic) BOOL panFromEdge;
    //    @property (assign, readwrite, nonatomic) NSUInteger panMinimumOpenThreshold;
    //    @property (assign, readwrite, nonatomic) BOOL interactivePopGestureRecognizerEnabled;
    //    @property (assign, readwrite, nonatomic) BOOL scaleContentView;
    //    @property (assign, readwrite, nonatomic) BOOL scaleBackgroundImageView;
    //    @property (assign, readwrite, nonatomic) BOOL scaleMenuView;
    //    @property (assign, readwrite, nonatomic) BOOL contentViewShadowEnabled;
    //    @property (assign, readwrite, nonatomic) UIColor *contentViewShadowColor;
    //    @property (assign, readwrite, nonatomic) CGSize contentViewShadowOffset;
    //    @property (assign, readwrite, nonatomic) CGFloat contentViewShadowOpacity;
    //    @property (assign, readwrite, nonatomic) CGFloat contentViewShadowRadius;
    //    @property (assign, readwrite, nonatomic) CGFloat contentViewScaleValue;
    //    @property (assign, readwrite, nonatomic) CGFloat contentViewInLandscapeOffsetCenterX;
    //    @property (assign, readwrite, nonatomic) CGFloat contentViewInPortraitOffsetCenterX;
    //    @property (assign, readwrite, nonatomic) CGFloat parallaxMenuMinimumRelativeValue;
    //    @property (assign, readwrite, nonatomic) CGFloat parallaxMenuMaximumRelativeValue;
    //    @property (assign, readwrite, nonatomic) CGFloat parallaxContentMinimumRelativeValue;
    //    @property (assign, readwrite, nonatomic) CGFloat parallaxContentMaximumRelativeValue;
    //    @property (assign, readwrite, nonatomic) CGAffineTransform menuViewControllerTransformation;
    //    @property (assign, readwrite, nonatomic) BOOL parallaxEnabled;
    //    @property (assign, readwrite, nonatomic) BOOL bouncesHorizontally;
    //    @property (assign, readwrite, nonatomic) UIStatusBarStyle menuPreferredStatusBarStyle;
    //    @property (assign, readwrite, nonatomic) BOOL menuPrefersStatusBarHidden;

    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

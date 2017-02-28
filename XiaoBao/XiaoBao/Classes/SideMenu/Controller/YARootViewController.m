//
//  YARootViewController.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/15.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YARootViewController.h"
#import "YAHomeViewController.h"
#import "YASideViewController.h"

@interface YARootViewController ()
@end

@implementation YARootViewController

#pragma mark - 初始化

- (instancetype)init {
    if (self = [super init]) {
        UINavigationController *contentNavigationController = [[UINavigationController alloc] initWithRootViewController:[[YAHomeViewController alloc] init]];
        self.centerViewController = contentNavigationController;
        
        self.leftDrawerViewController = [[YASideViewController alloc] init];
        
        
        // 设置打开/关闭抽屉的手势
        self.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
        self.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
        // 设置左右两边抽屉显示的多少
        self.maximumLeftDrawerWidth = 70 + 0.5 * kScreenWidth;
        
        
        
        // 设置侧边栏与中心控制器粘性滑动
        [self setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
            drawerController.leftDrawerViewController.view.ya_x = - (70 + 0.5 * kScreenWidth) * (1 - percentVisible);
        }];
        

    }
    return self;
}

#pragma mark - RESideMenu属性与方法

/*
 self.delegate = self;
 
 self.scaleContentView = NO;  //内容视图缩放功能
 self.contentViewScaleValue = 1;  //侧滑出现时缩放比
 self.scaleMenuView = NO;        //侧滑出来的视图是否支持缩放
 self.contentViewShadowEnabled = YES; //中心视图阴影效果，打开显得有层次感。
 self.contentViewShadowRadius = 4.5;  //中心视图阴影效果Radius
 self.panGestureEnabled = YES;   //关闭拖动支持手势
 self.contentViewInPortraitOffsetCenterX = 70; // 偏移中心,内容视图偏移菜单中心+70
 self.bouncesHorizontally = NO;
 self.panFromEdge = NO; // 只能从从边缘划开
 self.panMinimumOpenThreshold = 50; // 至少划开100才能打开菜单,否则弹回去
 self.interactivePopGestureRecognizerEnabled = YES;
 self.fadeMenuView = NO; // 淡出菜单视图
 //    self.menuViewControllerTransformation
 //    self.contentViewInLandscapeOffsetCenterX = 200;
 
 
 self.parallaxEnabled = NO; // 视差效果,也就是远近(大小)效果
 //    self.parallaxMenuMinimumRelativeValue = 200;// 菜单视差最小相对值
 //    self.parallaxMenuMaximumRelativeValue = 20;// 菜单视差最大相对值
 //    self.parallaxContentMinimumRelativeValue = 100;// 内容视差最小相对值
 //    self.parallaxContentMaximumRelativeValue = 10;// 内容视差最大相对值
 
 
 //        self.contentViewInLandscapeOffsetCenterX = 70;


    // 动画持续时间
    @property (assign, readwrite, nonatomic) NSTimeInterval animationDuration;
    //菜单背景图片
    @property (strong, readwrite, nonatomic) UIImage *backgroundImage;
    @property (assign, readwrite, nonatomic) BOOL panGestureEnabled;
    @property (assign, readwrite, nonatomic) BOOL panFromEdge;
    @property (assign, readwrite, nonatomic) NSUInteger panMinimumOpenThreshold;
    @property (assign, readwrite, nonatomic) BOOL interactivePopGestureRecognizerEnabled;
    @property (assign, readwrite, nonatomic) BOOL scaleContentView;
    @property (assign, readwrite, nonatomic) BOOL scaleBackgroundImageView;
    @property (assign, readwrite, nonatomic) BOOL scaleMenuView;
    @property (assign, readwrite, nonatomic) BOOL contentViewShadowEnabled;
    @property (assign, readwrite, nonatomic) UIColor *contentViewShadowColor;
    @property (assign, readwrite, nonatomic) CGSize contentViewShadowOffset;
    @property (assign, readwrite, nonatomic) CGFloat contentViewShadowOpacity;
    @property (assign, readwrite, nonatomic) CGFloat contentViewShadowRadius;
    @property (assign, readwrite, nonatomic) CGFloat contentViewScaleValue;
    @property (assign, readwrite, nonatomic) CGFloat contentViewInLandscapeOffsetCenterX;
    @property (assign, readwrite, nonatomic) CGFloat contentViewInPortraitOffsetCenterX;
    @property (assign, readwrite, nonatomic) CGFloat parallaxMenuMinimumRelativeValue;
    @property (assign, readwrite, nonatomic) CGFloat parallaxMenuMaximumRelativeValue;
    @property (assign, readwrite, nonatomic) CGFloat parallaxContentMinimumRelativeValue;
    @property (assign, readwrite, nonatomic) CGFloat parallaxContentMaximumRelativeValue;
    @property (assign, readwrite, nonatomic) CGAffineTransform menuViewControllerTransformation;
    @property (assign, readwrite, nonatomic) BOOL parallaxEnabled;
    @property (assign, readwrite, nonatomic) BOOL bouncesHorizontally;
    @property (assign, readwrite, nonatomic) UIStatusBarStyle menuPreferredStatusBarStyle;
    @property (assign, readwrite, nonatomic) BOOL menuPrefersStatusBarHidden;



- (void)sideMenu:(RESideMenu *)sideMenu didRecognizePanGesture:(UIPanGestureRecognizer *)recognizer {

    // 根据视图层级关系找到移动的view
    UIView *view = [UIApplication sharedApplication].keyWindow.subviews.firstObject.subviews.lastObject;
    if (view.ya_x >= (0.5 * kScreenWidth + 68)) {
        view.ya_x = 0.5 * kScreenWidth + 70;
    }
}

 
  */
@end

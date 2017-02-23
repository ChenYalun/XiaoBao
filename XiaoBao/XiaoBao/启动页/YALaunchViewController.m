//
//  YALaunchViewController.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/23.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YALaunchViewController.h"
#import "YAHTTPManager.h"
#import <UIImageView+YYWebImage.h>
@interface YALaunchViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIView *animationView;
@property (weak, nonatomic) IBOutlet UIView *menuView;

@end

@implementation YALaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 图片处理
    [self.backImageView yy_setImageWithURL:[NSURL URLWithString:@"https://bing.ioliu.cn/v1?w=768&h=1280"] options:YYWebImageOptionSetImageWithFadeAnimation];
    
    // json 数据: https://bing.ioliu.cn/v1
    requestSuccessBlock sblock = ^(id responseObject){
        NSString *title = responseObject[@"data"][@"title"];
        self.titleLabel.text = title;
    };
    
    [[YAHTTPManager sharedManager] requestWithMethod:GET WithPath:@"https://bing.ioliu.cn/v1" WithParameters:nil WithSuccessBlock:sblock WithFailurBlock:nil];
    
    // 圆角正方形
    CAShapeLayer *outLayer = [CAShapeLayer layer];
    outLayer.lineWidth = 1;
    outLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    outLayer.fillColor = [UIColor clearColor].CGColor;
    outLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(19, 26, 42, 42) cornerRadius:10].CGPath;
    [self.animationView.layer addSublayer:outLayer];
    


    // 动画处理
    CAShapeLayer *layer = [CAShapeLayer layer];
    // 线宽
    layer.lineWidth = 5.0;
    // 线填充色
    layer.fillColor = [UIColor clearColor].CGColor;
    // 线的颜色
    layer.strokeColor = [UIColor lightGrayColor].CGColor;
    layer.lineCap = kCALineCapRound;
    
    CGPoint center = self.animationView.center;

    layer.opacity = 0.0;
    layer.path = [UIBezierPath bezierPathWithArcCenter:center radius:12 startAngle:M_PI_2 endAngle:M_PI * 4 / 2 clockwise:YES].CGPath;
    [self.animationView.layer addSublayer:layer];

    
    
    
    

    
    self.menuView.ya_y = kScreenHeight;

    [UIView animateWithDuration:0.7 animations:^{
        self.menuView.ya_y = kScreenHeight - 95;
    } completion:^(BOOL finished) {
        layer.opacity = 1.0;
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue = [NSNumber numberWithFloat:0];
        animation.toValue = [NSNumber numberWithFloat:1.0];
        animation.duration = 1.5;
        [layer addAnimation:animation forKey:@"strokeAnimation"];
        
    }];
    
    self.view.alpha = 0.99f;//这里alpha的值和下面alpha的值不能设置为相同的，否则动画相当于瞬间执行完，启动页之后动画瞬间消失。这里alpha设为0.99，动画就不会有一闪而过的效果，而是一种类似于静态背景的效果。设为0，动画就相当于是淡入的效果了。
    
    [UIView animateWithDuration:5.0f delay:0.0f options:UIViewAnimationOptionTransitionNone animations:^{
        
        self.view.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        [self.view removeFromSuperview];
        
        
        
    }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    // 设置状态栏显示
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
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

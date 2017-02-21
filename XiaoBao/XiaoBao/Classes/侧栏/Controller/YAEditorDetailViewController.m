//
//  YAEditorDetailViewController.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/21.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YAEditorDetailViewController.h"
#import <UIImageView+YYWebImage.h>
@interface YAEditorDetailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


// 内容View高度约束
@property (weak, nonatomic) IBOutlet
NSLayoutConstraint *contentViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UILabel *urlLabel;
@property (weak, nonatomic) IBOutlet UILabel *urlTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *turnImageView;


@property (weak, nonatomic) IBOutlet UILabel *weiboLabel;
@property (weak, nonatomic) IBOutlet UILabel *siteLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@end

@implementation YAEditorDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.contentInset = UIEdgeInsetsMake(80, 0, 0, 0);
    self.contentViewHeightConstraint.constant = kScreenHeight - 64;
    
    
    
    // 导航栏标题
    self.navigationItem.title = self.editor.name;
    
    // 编辑头像
    [self.iconImageView yy_setImageWithURL:[NSURL URLWithString:self.editor.avatar] options:YYWebImageOptionShowNetworkActivity];
    // 姓名
    self.nameLabel.text = self.editor.name;
    
    // bio
    self.bioLabel.text = self.editor.bio;
    
    // 知乎地址
    if (self.editor.url) {
        self.turnImageView.hidden = NO;
        self.urlLabel.alpha = 0.7;
        self.urlTitleLabel.alpha = 1;
        self.urlLabel.text = self.editor.name;
    }
    
    // 以下信息无法从api中获取
    // 微博
    
    // 个人网站
    
    // 电子邮箱
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

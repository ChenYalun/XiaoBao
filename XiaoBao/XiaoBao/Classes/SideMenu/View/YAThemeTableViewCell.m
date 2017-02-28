//
//  YAThemeTableViewCell.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/18.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YAThemeTableViewCell.h"

#define kFontSize 15
#define kEdgeMargin 15
#define kNameLabelLeading 50

@interface YAThemeTableViewCell ()
/** 主页图片 */
@property (weak, nonatomic) IBOutlet UIImageView *homeImageView;
/** 主题文字 */
@property (weak, nonatomic) IBOutlet UILabel *themeNameLabel;
/** 订阅按钮 */
@property (weak, nonatomic) IBOutlet UIButton *subscribedButton;
/** 主题名称leading约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelLeadingConstraint;
@end

@implementation YAThemeTableViewCell

#pragma mark - getter and setter

- (void)setTheme:(YAThemeItem *)theme {
    _theme = theme;
    
    self.themeNameLabel.text = theme.name;
    
    if ([theme.name isEqualToString:@"首页"]) {
        self.homeImageView.hidden = NO;
        self.nameLabelLeadingConstraint.constant = kNameLabelLeading;
    } else {
        self.homeImageView.hidden = YES;
        self.nameLabelLeadingConstraint.constant = kEdgeMargin;
    }
    
}

#pragma mark - cell delegate
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        self.themeNameLabel.textColor = [UIColor whiteColor];
        self.themeNameLabel.font = [UIFont boldSystemFontOfSize:kFontSize];
        [self.homeImageView setHighlighted:YES];
        // 设置选中背景颜色
        self.contentView.backgroundColor = kRGBColor(27, 34, 42);
    } else {
        self.themeNameLabel.textColor = [UIColor lightGrayColor];
        self.themeNameLabel.font = [UIFont systemFontOfSize:kFontSize];
        [self.homeImageView setHighlighted:NO];
        self.contentView.backgroundColor = kRGBColor(35, 42, 50);
     
    }
    
    
}


- (IBAction)subscribeStoryTheme:(UIButton *)sender {
    
}

@end

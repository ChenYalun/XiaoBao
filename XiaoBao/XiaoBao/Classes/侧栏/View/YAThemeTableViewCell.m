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
@property (weak, nonatomic) IBOutlet UIImageView *homeImageView;
@property (weak, nonatomic) IBOutlet UILabel *themeNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *subscribedButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelLeadingConstraint;

@end
@implementation YAThemeTableViewCell

#pragma mark - 属性方法
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
- (void)awakeFromNib {
    [super awakeFromNib];

   
}

#pragma mark - 选中状态
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

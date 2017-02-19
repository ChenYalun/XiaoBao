//
//  YAThemeTableViewCell.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/18.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YAThemeTableViewCell.h"

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
        self.nameLabelLeadingConstraint.constant = 50;
    } else {
        self.homeImageView.hidden = YES;
        self.nameLabelLeadingConstraint.constant = 15;
    }
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)subscribeStoryTheme:(UIButton *)sender {
}

@end

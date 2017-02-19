//
//  YAStoryTableViewCell.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/16.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YAStoryTableViewCell.h"
#import <UIImageView+YYWebImage.h>

@interface YAStoryTableViewCell()
// 图片
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
// 标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
// 多图
@property (weak, nonatomic) IBOutlet UIImageView *multipleImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelTrailingConstraint;

@end
@implementation YAStoryTableViewCell

- (void)setStory:(YAStoryItem *)story {
    _story = story;

    // 配图
    if (story.images.count > 0) {
        self.picImageView.hidden = NO;
        [self.picImageView yy_setImageWithURL:[NSURL URLWithString:story.images.firstObject] options:YYWebImageOptionShowNetworkActivity|YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation];
        self.titleLabelTrailingConstraint.constant = 105;
        
    } else {
        self.picImageView.hidden = YES;
        self.titleLabelTrailingConstraint.constant = 15;
    }
    

    // 多图展示
    if (story.multipic && story.images.count > 0) {
        self.multipleImageView.hidden = NO;
    } else {
        self.multipleImageView.hidden = YES;
    }

    // 标题
    self.titleLabel.text = story.title;


}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

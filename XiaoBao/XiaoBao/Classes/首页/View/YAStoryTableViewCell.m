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

@end
@implementation YAStoryTableViewCell

- (void)setStory:(YAStoryItem *)story {
    _story = story;
    if (story.image) {
        NSLog(@"设置滚动image");
        [self.picImageView yy_setImageWithURL:[NSURL URLWithString:story.image] options:YYWebImageOptionShowNetworkActivity];
    } else {
        [self.picImageView yy_setImageWithURL:[NSURL URLWithString:story.images.firstObject] options:YYWebImageOptionShowNetworkActivity];
    }
    
    self.titleLabel.text = story.title;
    
    if (story.multipic) {
        self.multipleImageView.hidden = NO;
    } else {
        self.multipleImageView.hidden = YES;
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

@end

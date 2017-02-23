//
//  YACommentTableViewCell.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/23.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YACommentTableViewCell.h"
#import <UIImageView+YYWebImage.h>
@interface YACommentTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *zanButton;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
@implementation YACommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setComment:(YACommentModel *)comment {
    _comment = comment;
    
    [self.iconImageView yy_setImageWithURL:[NSURL URLWithString:comment.avatar] options:YYWebImageOptionShowNetworkActivity];
    self.nameLabel.text = comment.author;
    self.contentLabel.text = comment.content;
    self.zanButton.titleLabel.text = comment.likes;
    self.timeLabel.text = comment.time;
    self.replyLabel.text = comment.reply.content;
}

@end

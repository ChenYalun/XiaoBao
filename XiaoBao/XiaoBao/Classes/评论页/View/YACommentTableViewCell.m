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
@property (weak, nonatomic) IBOutlet UIButton *openButton;

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
    [self.zanButton setTitle:comment.likes forState:UIControlStateNormal];
    self.timeLabel.text = comment.time;
    self.replyLabel.text = comment.replyContent;
    
    // 是否隐藏展开按钮
    if (self.replyLabel.text) {
        self.openButton.hidden = NO;
    } else {
        self.openButton.hidden = YES;
    }
    
    // 显示回复
//    if (comment.isOpen) {
//        self.replyLabel.numberOfLines = 0;
//    } else {
//        self.replyLabel.numberOfLines = 2;
//    }
    
    if (comment.isOpen) {
        [self.openButton setTitle:@"收起" forState:UIControlStateNormal];
        self.replyLabel.numberOfLines = 0;
    } else {
        [self.openButton setTitle:@"展开" forState:UIControlStateNormal];
        self.replyLabel.numberOfLines = 2;
    }
    
}
- (IBAction)openReply:(UIButton *)sender {
    
    /* 方式一:使用beginUpdates\endupdates,但是cell变化太剧烈,不平滑
    self.comment.isOpen = !self.comment.isOpen;
    
    // 刷新数据
    UITableView *tableView = (UITableView *)self.superview.superview;
    [tableView beginUpdates];
    [tableView endUpdates];
   */
    
    // 刷新数据
    UITableView *tableView = (UITableView *)self.superview.superview;
    NSIndexPath *indexPath =[tableView indexPathForCell:self];
    self.comment.isOpen = !self.comment.isOpen;
    
    [tableView reloadRow:indexPath.row inSection:indexPath.section withRowAnimation:UITableViewRowAnimationFade];
    
}

@end

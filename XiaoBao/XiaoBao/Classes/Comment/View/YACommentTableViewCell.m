//
//  YACommentTableViewCell.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/23.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YACommentTableViewCell.h"
#import <UIImageView+YYWebImage.h>
#import "UIImage+YAVImage.h"

@interface YACommentTableViewCell()
/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
/** 姓名 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** 赞按钮 */
@property (weak, nonatomic) IBOutlet UIButton *zanButton;
/** 内容 */
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
/** 转发 */
@property (weak, nonatomic) IBOutlet UILabel *replyLabel;
/** 时间 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
/** 展开按钮 */
@property (weak, nonatomic) IBOutlet UIButton *openButton;
@end
@implementation YACommentTableViewCell

#pragma mark - life Cycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor = kRGBAColor(237, 237, 237, 0.8);
}

#pragma mark - getter and setter

- (void)setComment:(YACommentModel *)comment {
    _comment = comment;
    
//    [self.iconImageView yy_setImageWithURL:[NSURL URLWithString:comment.avatar] options:YYWebImageOptionShowNetworkActivity];
    [self.iconImageView yy_setImageWithURL:[NSURL URLWithString:comment.avatar]  placeholder:nil options:YYWebImageOptionShowNetworkActivity completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        UIImage *circleImage = [UIImage imageToRoundImageWithImage:image];
        self.iconImageView.image = circleImage;
    }];
    
    
    
    self.nameLabel.text = comment.author;
    self.contentLabel.text = comment.content;
    [self.zanButton setTitle:comment.likes forState:UIControlStateNormal];
    self.timeLabel.text = comment.time;
    self.replyLabel.attributedText = comment.replyContent;
    
    // 是否隐藏展开按钮
    if (self.replyLabel.attributedText) {
        self.openButton.hidden = NO;
    } else {
        self.openButton.hidden = YES;
    }
    
    // 按钮的展开与收起
    if (comment.isOpen) {
        [self.openButton setTitle:@"收起" forState:UIControlStateNormal];
        self.replyLabel.numberOfLines = 0;
    } else {
        [self.openButton setTitle:@"展开" forState:UIControlStateNormal];
        self.replyLabel.numberOfLines = 2;
    }
    
    //  两行可以显示完全则隐藏展开按钮
    CGSize contentSize = [self.replyLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth - 60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:15.0]} context:nil].size;
    
    CGFloat lineHeight = self.replyLabel.font.lineHeight;
    
    if (contentSize.height > lineHeight * 2) {
        self.openButton.hidden = NO;
    } else {
        self.openButton.hidden = YES;
    }
    
}

#pragma mark - event response

// 展开评论
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

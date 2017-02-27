//
//  YAEditorListTableViewCell.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/20.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YAEditorListTableViewCell.h"
#import <UIImageView+YYWebImage.h>

@interface YAEditorListTableViewCell()
/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
/** 姓名 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** 简介 */
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@end

@implementation YAEditorListTableViewCell

#pragma mark - life Cycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor = kRGBAColor(237, 237, 237, 0.8);

}

#pragma mark - getter and setter

- (void)setEditor:(YAEditorItem *)editor {
    _editor = editor;
    
    [self.iconImageView yy_setImageWithURL:[NSURL URLWithString:editor.avatar] options:YYWebImageOptionShowNetworkActivity];
    
    self.nameLabel.text = editor.name;
    self.bioLabel.text = editor.bio;
}
@end

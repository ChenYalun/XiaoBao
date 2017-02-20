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
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;

@end

@implementation YAEditorListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)setEditor:(YAEditorItem *)editor {
    _editor = editor;
    
    [self.iconImageView yy_setImageWithURL:[NSURL URLWithString:editor.avatar] options:YYWebImageOptionShowNetworkActivity];
    
    self.nameLabel.text = editor.name;
    self.bioLabel.text = editor.bio;
}
@end

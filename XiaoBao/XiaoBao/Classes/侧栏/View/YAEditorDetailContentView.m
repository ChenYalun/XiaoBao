//
//  YAEditorDetailContentView.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/21.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YAEditorDetailContentView.h"
#import <UIImageView+YYWebImage.h>
@interface YAEditorDetailContentView()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UILabel *urlLabel;
@property (weak, nonatomic) IBOutlet UILabel *urlTitleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *turnImageView;
@end
@implementation YAEditorDetailContentView

+ (instancetype)editorViewWithItem:(YAEditorItem *)editor {
    YAEditorDetailContentView *editorView = [[NSBundle mainBundle] loadNibNamed:[YAEditorDetailContentView className] owner:nil options:nil].firstObject;
    editorView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64);
    // 编辑头像
    [editorView.iconImageView yy_setImageWithURL:[NSURL URLWithString:editor.avatar] options:YYWebImageOptionShowNetworkActivity];
    // 姓名
    editorView.nameLabel.text = editor.name;
    
    // bio
    editorView.bioLabel.text = editor.bio;
    
    // 知乎地址
    if (editor.url) {
        editorView.turnImageView.hidden = NO;
        editorView.urlLabel.alpha = 0.7;
        editorView.urlTitleLabel.alpha = 1;
        editorView.urlLabel.text = editor.name;
    }

    return editorView;
}


@end

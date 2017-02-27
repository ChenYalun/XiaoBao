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
/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
/** 姓名 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** 简介 */
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
/** url */
@property (weak, nonatomic) IBOutlet UILabel *urlLabel;
/** url标题 */
@property (weak, nonatomic) IBOutlet UILabel *urlTitleLabel;
/** 指示图片 */
@property (weak, nonatomic) IBOutlet UIImageView *turnImageView;
@end

@implementation YAEditorDetailContentView

#pragma mark - 快速创建

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

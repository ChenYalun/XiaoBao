//
//  YAThemeTableViewHeader.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/20.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YAThemeTableViewHeader.h"
#import <UIImageView+YYWebImage.h>
#import "YAEditorListViewController.h"

@interface YAThemeTableViewHeader()
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImageView;
@property (weak, nonatomic) IBOutlet UIImageView *fourthImageView;
@property (weak, nonatomic) IBOutlet UIImageView *fifthImageView;
@end
@implementation YAThemeTableViewHeader

#pragma mark - event response

- (void)setupImageView:(UIImageView *)imageView withItem:(YAEditorItem *)item {
    if (item) {
        imageView.hidden = NO;
        [imageView yy_setImageWithURL:[NSURL URLWithString:item.avatar] options:YYWebImageOptionShowNetworkActivity];
    } else {
        imageView.hidden = YES;
    }
    
}

#pragma mark - 快速创建

+ (instancetype)header {
    return [[NSBundle mainBundle] loadNibNamed:[YAThemeTableViewHeader className] owner:nil options:nil].firstObject;
}

#pragma mark - getter and setter

- (void)setEditors:(NSArray<YAEditorItem *> *)editors {
    _editors = editors;
    
    NSInteger count = editors.count;
    if (count > 0) {
        [self setupImageView:self.firstImageView withItem:editors[0]];
    }else {
        return;
    }
    
    if (count > 1) {
        [self setupImageView:self.secondImageView withItem:editors[1]];
    }else {
        return;
    }
    
    if (count > 2) {
        [self setupImageView:self.thirdImageView withItem:editors[2]];
    }else {
        return;
    }
    
    if (count > 3) {
        [self setupImageView:self.fourthImageView withItem:editors[3]];
    }else {
        return;
    }
    
    if (count > 4) {
        [self setupImageView:self.fifthImageView withItem:editors[4]];
    }else {
        return;
    }
    
    
}

@end

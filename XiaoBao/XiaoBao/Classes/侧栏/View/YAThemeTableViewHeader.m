//
//  YAThemeTableViewHeader.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/20.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YAThemeTableViewHeader.h"
#import <UIImageView+YYWebImage.h>
#import "YAEditorListTableViewController.h"
#import <RESideMenu.h>
@interface YAThemeTableViewHeader()
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImageView;
@property (weak, nonatomic) IBOutlet UIImageView *fourthImageView;
@property (weak, nonatomic) IBOutlet UIImageView *fifthImageView;



@end
@implementation YAThemeTableViewHeader

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

- (void)setupImageView:(UIImageView *)imageView withItem:(YAEditorItem *)item {
    if (item) {
        imageView.hidden = NO;
        [imageView yy_setImageWithURL:[NSURL URLWithString:item.avatar] options:YYWebImageOptionShowNetworkActivity];
    } else {
        imageView.hidden = YES;
    }
    
}

+ (instancetype)header {
    return [[NSBundle mainBundle] loadNibNamed:[YAThemeTableViewHeader className] owner:nil options:nil].firstObject;
}


#pragma mark - 编辑人员页面跳转
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//
//    YAEditorListTableViewController *editorViewController = [[YAEditorListTableViewController alloc] init];
//    editorViewController.editors = self.editors;
//    
//    [((UINavigationController *)self.viewController.sideMenuViewController.contentViewController) pushViewController:editorViewController animated:YES];
//    
////    [self.viewController.navigationController
//    
//}
@end

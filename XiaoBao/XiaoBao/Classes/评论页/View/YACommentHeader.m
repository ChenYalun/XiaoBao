//
//  YACommentHeader.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/24.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YACommentHeader.h"
#import "YACommentViewController.h"
@interface YACommentHeader()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *indicationImageView;



@end
@implementation YACommentHeader

+ (instancetype)commentHeaderWithIndexPath:(NSInteger)section itemsCount:(NSInteger)count {
    
    YACommentHeader *header = [[NSBundle mainBundle] loadNibNamed:[YACommentHeader className] owner:nil options:nil].firstObject;
    
    if (count > 0) {
        header.hidden = NO;
    } else {
        header.hidden = YES;
    }
    
    
    if (section == 0) {
        header.titleLabel.text = [NSString stringWithFormat:@"%ld 条长评",(long)count];
        header.indicationImageView.hidden = YES;
    } else {
        header.titleLabel.text = [NSString stringWithFormat:@"%ld 条短评",(long)count];
        header.indicationImageView.hidden = NO;
    }
    
    // 更新指示数据
    BOOL isOpen = [[NSUserDefaults standardUserDefaults] boolForKey:@"YACommentHeaderIsOpen"];
    header.indicationImageView.highlighted = isOpen;
    [[NSUserDefaults standardUserDefaults] setBool:!isOpen forKey:@"YACommentHeaderIsOpen"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    return header;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    YACommentViewController *commentViewController = (YACommentViewController *)self.superview.viewController;
    
    commentViewController.isOpen = !commentViewController.isOpen;
    
    // 刷新数据
    [commentViewController.tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
    
    // tableView滚动到顶部
    if (commentViewController.isOpen) {
        [commentViewController.tableView scrollToRow:0 inSection:1 atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    
    
}

@end


















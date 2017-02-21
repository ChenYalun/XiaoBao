//
//  YAEditorDetailViewController.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/21.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YAEditorDetailViewController.h"
#import "YANavigationView.h"
#import "YAEditorDetailContentView.h"
@interface YAEditorDetailViewController ()
@property (weak, nonatomic) UIScrollView *scrollView;



@end

@implementation YAEditorDetailViewController

#pragma mark - 懒加载
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        [self.view addSubview:scrollView];
        scrollView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64);
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.contentInset = UIEdgeInsetsMake(80, 0, 0, 0);
        scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight - 143);
        
        
        _scrollView = scrollView;
    }
    return _scrollView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavigationView];

    
    YAEditorDetailContentView *editorDetailContentView = [YAEditorDetailContentView editorViewWithItem:self.editor];
    [self.scrollView addSubview:editorDetailContentView];

}

#pragma mark - 设置导航View
- (void)setupNavigationView {
    
    YANavigationView *navigation = [YANavigationView navigationViewWithTitle:self.editor.name];
    [self.view addSubview:navigation];
    
    
}
@end

//
//  YACommentViewController.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/24.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//


#import "YACommentViewController.h"
#import "YACommentTableViewCell.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "YAHTTPManager.h"
#import "YACommentHeader.h"
#import "YANavigationView.h"
#import "YAErrorView.h"

static NSString *reuseIdentifier = @"comment";

@interface YACommentViewController ()<UITableViewDelegate,UITableViewDataSource>
/** 评论数组 */
@property (nonatomic,strong) NSMutableArray <NSMutableArray *>*comments;
/** 评论数量 */
@property (nonatomic,assign) NSInteger commentCount;
/** 导航视图 */
@property (nonatomic,weak) YANavigationView *navigationView;
/** 网络延迟提示视图 */
@property (nonatomic,weak) YAErrorView *errorView;
@end

@implementation YACommentViewController

 #pragma mark – Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 网络延迟处理
    self.errorView.hidden = NO;
    
    
    // 设置YACommentHeader 按钮状态
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"YACommentHeaderIsOpen"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    // 设置导航栏
    self.automaticallyAdjustsScrollViewInsets = NO;
 
    
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:[YACommentTableViewCell className] bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    
    
    // 长评论
    [self refreshForCommentsWithId:[NSString stringWithFormat:@"%ld",self.storyID] kindOfComment:@"long-comments"];
    
    // 短评论
    [self refreshForCommentsWithId:[NSString stringWithFormat:@"%ld",self.storyID] kindOfComment:@"short-comments"];
}

 #pragma mark – Events

// 刷新评论
- (void)refreshForCommentsWithId:(NSString *)commentID kindOfComment:(NSString *)kind {
    
    // 请求路径
    NSString *path = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/story/%@/%@",commentID,kind];
    
    requestSuccessBlock sblock = ^(id responseObject){
        
        // 网络延迟处理
        if (self.navigationView.hidden) {
            self.navigationView.hidden = NO;
        }
        
        [self.errorView removeFromSuperview];
        
        NSArray *array = [YACommentModel commentModelWithKeyValues:responseObject];
        
        // 处理长评论
        if ([kind isEqualToString:@"long-comments"]) {
            [self.comments[0] addObjectsFromArray:array];
            [self.tableView reloadData];
        } else { // 短评论
            [self.comments[1] addObjectsFromArray:array];
            //[self.tableView reloadData];
        }
        
        self.commentCount += array.count;
        self.navigationView.title = [NSString stringWithFormat:@"%ld 条点评",self.commentCount];
    };
    
    [[YAHTTPManager sharedManager] requestWithMethod:GET WithPath:path WithParameters:nil WithSuccessBlock:sblock WithFailurBlock:nil];
}


#pragma mark - Table view data source and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.comments[section].count;
    } else {
        return self.isOpen ? self.comments[section].count : 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YACommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.comment = self.comments[indexPath.section][indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return [tableView fd_heightForCellWithIdentifier:reuseIdentifier cacheByIndexPath:indexPath configuration:^(YACommentTableViewCell *cell) {
        cell.comment = self.comments[indexPath.section][indexPath.row];
    }];
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YACommentHeader *header = [YACommentHeader commentHeaderWithIndexPath:section itemsCount:self.comments[section].count];
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}


#pragma mark - getter and setter

- (NSMutableArray<NSMutableArray *> *)comments {
    if (_comments == nil) {
        _comments = [NSMutableArray array];
        _comments[0] = [NSMutableArray array];
        _comments[1] = [NSMutableArray array];
    }
    return _comments;
}

- (YANavigationView *)navigationView {
    if (_navigationView == nil) {
        _navigationView = [YANavigationView navigationViewWithTitle:nil];
        _navigationView.backButton.hidden = YES;
        [self.view addSubview:_navigationView];
        _navigationView.hidden = YES;
    }
    return _navigationView;
}

- (YAErrorView *)errorView {
    if (_errorView == nil) {
        YAErrorView *errorView = [YAErrorView errorView];
        [self.view addSubview:errorView];
        _errorView = errorView;
    }
    return _errorView;
}


@end

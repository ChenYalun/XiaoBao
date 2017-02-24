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

@interface YACommentViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray <NSMutableArray *>*comments;

/** 评论数量 */
@property (nonatomic,assign) NSInteger commentCount;


/** 导航视图 */
@property (nonatomic,weak) YANavigationView *navigationView;
@end

@implementation YACommentViewController
static NSString *reuseIdentifier = @"comment";

#pragma mark - 懒加载
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
    }
    return _navigationView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
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

- (void)refreshForCommentsWithId:(NSString *)commentID kindOfComment:(NSString *)kind {
    
    // 请求路径
    NSString *path = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/story/%@/%@",commentID,kind];
    requestSuccessBlock sblock = ^(id responseObject){
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

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
    
    return [tableView fd_heightForCellWithIdentifier:reuseIdentifier configuration:^(YACommentTableViewCell *cell){
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

@end

//
//  YAEditorListViewController.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/20.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YAEditorListViewController.h"
#import "YAEditorListTableViewCell.h"
#import "YAEditorDetailViewController.h"
#import "YANavigationView.h"

// 重用ID
static NSString *reuseIdentifier = @"YAEditorListTableViewCell";

@interface YAEditorListViewController ()<UITableViewDelegate,UITableViewDataSource>
/** 数据展示tableView */
@property (weak, nonatomic)  UITableView *tableView;
@end

@implementation YAEditorListViewController


#pragma mark - life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    

    // 设置自定义导航条
    [self setupNavigationView];
    
    // 刷新数据
    [self.tableView reloadData];

}


#pragma mark - event response

// 设置导航View
- (void)setupNavigationView {
    
    YANavigationView *navigation = [YANavigationView navigationViewWithTitle:@"编辑"];
    [self.view addSubview:navigation];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.editors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YAEditorListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.editor = self.editors[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YAEditorDetailViewController *detailViewController = [[YAEditorDetailViewController alloc] init];
    detailViewController.editor = self.editors[indexPath.row];
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}


#pragma mark - getter and setter

- (UITableView *)tableView {
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc] init];
        // 代理与数据源
        tableView.delegate = self;
        tableView.dataSource = self;
        
        // 样式调整
        tableView.rowHeight = 55;
        tableView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64);
        tableView.separatorColor = kRGBAColor(237, 237, 237, 0.9);
        tableView.tableFooterView = [[UIView alloc] init];
        
        // 注册cell
        [tableView registerNib:[UINib nibWithNibName:[YAEditorListTableViewCell className] bundle:nil] forCellReuseIdentifier:reuseIdentifier];
        [self.view addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}

@end

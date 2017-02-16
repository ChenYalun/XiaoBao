//
//  YAHomeTableViewController.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/15.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YAHomeTableViewController.h"
#import "YAStoryTableViewCell.h"
#import "YARefreshHeader.h"
#import "YARefreshFooter.h"
#import "YAHTTPManager.h"
#import "YAProgressHUD.h"
#import "YASectionHeaderView.h"
#import "YAHomeHeaderScrollView.h"
@interface YAHomeTableViewController ()
/** 滚动图片新闻 */
@property (nonatomic,strong)NSMutableArray *topStoryItems;
/** 组新闻 */
@property (nonatomic,strong) NSMutableDictionary *storySection;
/** 日期20170214 */
@property (nonatomic,copy) NSString *dateID;
/** sectionID对应section标题 */
@property (nonatomic,strong) NSMutableDictionary *titleSection;
@property (nonatomic,assign) NSInteger sectionID;

@end

@implementation YAHomeTableViewController
static NSString *reuseIdentifier = @"story";
#pragma mark - 懒加载
-(NSMutableArray *)stories {
    if (_topStoryItems == nil) {
        _topStoryItems = [NSMutableArray array];
    }
    return _topStoryItems;
}

- (NSMutableDictionary *)storySection {
    if (_storySection == nil) {
        _storySection = [NSMutableDictionary dictionary];
    }
    return _storySection;
}
- (NSMutableDictionary *)titleSection {
    if (_titleSection == nil) {
        _titleSection = [NSMutableDictionary dictionary];
    }
    return _titleSection;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:[YAStoryTableViewCell className] bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    // 注册sectionHeaderView
    [self.tableView registerClass:[YASectionHeaderView class] forHeaderFooterViewReuseIdentifier:reuseIdentifier];

    // 设置tableHeaderView
    self.tableView.tableHeaderView = [[YAHomeHeaderScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    
    // 设置刷新控件
    self.tableView.mj_header = [YARefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshForNewStories)];
    self.tableView.mj_footer = [YARefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshForMoreStories)];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 刷新
- (void)refreshForNewStories {
    // 成功回调
    requestSuccessBlock sblock = ^(id responseObject){
        // 停止刷新
        [self.tableView.mj_header endRefreshing];
        
        // 获取头部视图新闻
        NSArray *topStoryItems = [YAStoryItem topStoryItemWithKeyValues:responseObject];
        [self.topStoryItems addObjectsFromArray:topStoryItems];
        YAHomeHeaderScrollView *homeHeaderScrollView = (YAHomeHeaderScrollView *)self.tableView.tableHeaderView;
        homeHeaderScrollView.storyItems = topStoryItems;
        
        // 获取普通新闻
        NSArray *storyItems = [YAStoryItem storyItemsWithKeyValues:responseObject];
        [self.storySection setObject:storyItems forKey:[NSNumber numberWithInteger:self.sectionID]];
        
        // 存储日期ID
        self.dateID = responseObject[@"date"];
        // 保存每组索引对应的标题
        [self.titleSection setObject:self.dateID forKey:[NSNumber numberWithInteger:self.sectionID]];
        // 刷新
        [self.tableView reloadData];
        
    };
    
    // 失败回调
    requestFailureBlock fblock = ^(NSError *error){
        // 停止刷新
        [self.tableView.mj_header endRefreshing];
        kLog(@"%@", error);
        [YAProgressHUD showErrorWithStatus:@"刷新失败"];
    };
    
    // 发送请求
    [[YAHTTPManager sharedManager] requestWithMethod:GET WithPath:@"http://news-at.zhihu.com/api/4/news/latest" WithParameters:nil WithSuccessBlock:sblock WithFailurBlock:fblock];
}


- (void)refreshForMoreStories {
    // 成功回调
    requestSuccessBlock sblock = ^(id responseObject){
        // 停止刷新
        [self.tableView.mj_footer endRefreshing];
        
        self.sectionID += 1;
        
        // 获取普通新闻
        NSArray *storyItems = [YAStoryItem storyItemsWithKeyValues:responseObject];
        [self.storySection setObject:storyItems forKey:[NSNumber numberWithInteger:self.sectionID]];
        
        
        
        // 存储ID
        self.dateID = responseObject[@"date"];
        // 保存每组索引对应的标题
        [self.titleSection setObject:self.dateID forKey:[NSNumber numberWithInteger:self.sectionID]];
        // 刷新
        [self.tableView reloadData];
        
    };
    
    // 失败回调
    requestFailureBlock fblock = ^(NSError *error){
        // 停止刷新
        [self.tableView.mj_header endRefreshing];
        kLog(@"%@", error);
        [YAProgressHUD showErrorWithStatus:@"刷新失败"];
    };
    
    // 发送请求
    NSString *path = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/news/before/%@",self.dateID];
    [[YAHTTPManager sharedManager] requestWithMethod:GET WithPath:path WithParameters:nil WithSuccessBlock:sblock WithFailurBlock:fblock];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.storySection.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.storySection objectForKey:[NSNumber numberWithInteger:section]] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YAStoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    // 取出该组
    NSArray *storyItems = [self.storySection objectForKey:[NSNumber numberWithInteger:indexPath.section]];
    cell.story = storyItems[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) { // 隐藏第0组标题
        return CGFLOAT_MIN;
    }
    return 35;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) { // 隐藏第0组标题
        return nil;
    }
    
    YASectionHeaderView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifier];
    NSString *formatString = [YAStoryItem formatStringWithDateString:[self.titleSection objectForKey:[NSNumber numberWithInteger:section]]];
    sectionHeaderView.sectionTitle = formatString;
    return sectionHeaderView;
}


//- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section {
//    self.navigationItem.title = @"1";
//}

//- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated {
//    if (self.storySection objectForKey:[NSNumber numberWithInteger:indexPath.s]) {
//        <#statements#>
//    }
//}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

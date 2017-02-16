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
@interface YAHomeTableViewController ()
/** 滚动图片新闻 */
@property (nonatomic,strong)NSMutableArray *topStoryItems;
/** 组新闻 */
@property (nonatomic,strong) NSMutableDictionary *storySection;

@property (nonatomic,assign) NSInteger ID;
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
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:[YAStoryTableViewCell className] bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    
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
        
        // 获取普通新闻
        NSArray *storyItems = [YAStoryItem storyItemsWithKeyValues:responseObject];
        [self.storySection setObject:storyItems forKey:[NSNumber numberWithInteger:self.sectionID]];
        
        
        
        // 存储ID
        YAStoryItem *lastItem = storyItems.lastObject;
        self.ID = lastItem.ID;
        
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

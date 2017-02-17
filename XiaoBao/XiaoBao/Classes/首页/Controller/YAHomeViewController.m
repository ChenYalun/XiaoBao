//
//  YAHomeViewController.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/15.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YAHomeViewController.h"
#import "YAStoryTableViewCell.h"
#import "YARefreshHeader.h"
#import "YARefreshFooter.h"
#import "YAHTTPManager.h"
#import "YAProgressHUD.h"
#import "YASectionHeaderView.h"
#import "YAHomeHeaderView.h"
#define kHeaderViewHeight 200
@interface YAHomeViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
/** 滚动图片新闻 */
@property (nonatomic,strong)NSMutableArray *topStoryItems;
/** 组新闻 */
@property (nonatomic,strong) NSMutableDictionary *storySection;
/** 日期20170214 */
@property (nonatomic,copy) NSString *dateID;
/** sectionID对应section标题 */
@property (nonatomic,strong) NSMutableDictionary *titleSection;
@property (nonatomic,assign) NSInteger sectionID;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *navigationView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) YAHomeHeaderView *headerView;

@end

@implementation YAHomeViewController
static NSString *reuseIdentifier = @"story";
#pragma mark - 懒加载
- (UIView *)navigationView{
    if (_navigationView == nil) {
        _navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 55)];
        _navigationView.backgroundColor = kGlobalColor;
        _navigationView.alpha = 0;
    }
    return _navigationView;
}

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
- (YAHomeHeaderView *)headerView {
    if (_headerView == nil) {
        _headerView = [[YAHomeHeaderView alloc] initWithFrame:CGRectMake(0, -20, kScreenWidth, kHeaderViewHeight + 20)];
        _headerView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _headerView;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight - 20) style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeaderViewHeight)];
        _tableView.clipsToBounds = NO;
    }
    return _tableView;
}
- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.attributedText = [[NSAttributedString alloc]
                                      initWithString:@"今日热闻"
                                      attributes:@{NSFontAttributeName:
                                                       [UIFont
                                                        systemFontOfSize:18],NSForegroundColorAttributeName:
                                                       [UIColor whiteColor]}];
        [_titleLabel sizeToFit];
        _titleLabel.centerX = self.view.centerX;
        _titleLabel.centerY = 35;
    }
    return _titleLabel;
}

  
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏
    self.automaticallyAdjustsScrollViewInsets = NO;

    // 设置控件
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.headerView];
//    [self.headerView addGestureRecognizer:self.pan];
//    [self.view addSubview:self.navigationView];
//    [self.view addSubview:self.titleLabel];
//    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:[YAStoryTableViewCell className] bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    // 注册sectionHeaderView
    [self.tableView registerClass:[YASectionHeaderView class] forHeaderFooterViewReuseIdentifier:reuseIdentifier];

    
    
    // 设置刷新控件

    self.tableView.mj_footer = [YARefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshForMoreStories)];
    [self refreshForNewStories];
}

#pragma mark - 刷新
- (void)refreshForNewStories {
    // 成功回调
    requestSuccessBlock sblock = ^(id responseObject){

        
        // 获取头部视图新闻
        NSArray *topStoryItems = [YAStoryItem topStoryItemWithKeyValues:responseObject];
        [self.topStoryItems addObjectsFromArray:topStoryItems];

        // 设置轮播图
        self.headerView.storyItems = topStoryItems;
        
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offSetY = scrollView.contentOffset.y;

    // 下拉放大
    if (offSetY < 0 ) {
        CGRect frame = self.headerView.frame;
        frame.origin.y = offSetY - 20;
        frame.size.height = -offSetY + kHeaderViewHeight + 20;
        self.headerView.frame = frame;
    }
   


}
@end

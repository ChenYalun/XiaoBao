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
#import <RESideMenu.h>
#import "YAEditorListTableViewController.h"
#define kHeaderViewHeight 200
#define kMargin 10
#define kRefreshViewWH 18
@interface YAHomeViewController ()<UITableViewDelegate,UITableViewDataSource>
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

@property (nonatomic,weak) UIButton *sideMenuButton;
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
                                                        boldSystemFontOfSize:18],NSForegroundColorAttributeName:
                                                       [UIColor whiteColor]}];
        [_titleLabel sizeToFit];
        _titleLabel.centerX = self.view.centerX;
        _titleLabel.centerY = 37;
    }
    return _titleLabel;
}

- (UIButton *)sideMenuButton {
    if (_sideMenuButton == nil) {
        UIButton *menuButton = [[UIButton alloc] init];
        [self.view addSubview:menuButton];
        menuButton.frame = CGRectMake(-10, 0, 60, 40);
        menuButton.centerY = 37;
        [menuButton setImage:kGetImage(@"Home_Icon") forState:UIControlStateNormal];
        [menuButton setImage:kGetImage(@"Home_Icon_Highlight") forState:UIControlStateHighlighted];
        _sideMenuButton = menuButton;
    }
    return _sideMenuButton;
}

#pragma mark - view初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.hidden = YES;

    // 设置控件
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.headerView];
    
    [self.view addSubview:self.navigationView];
    [self.view addSubview:self.titleLabel];
    
    self.tableView.separatorColor = kRGBAColor(237, 237, 237, 0.8);
    // 设置刷新控件
    self.tableView.mj_footer = [YARefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshForMoreStories)];
    self.view.ya_refreshHeader = [YARefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshForNewStories)];

    self.view.ya_refreshHeader.attachScrollView = self.tableView;

    // 设置侧滑
    [self.sideMenuButton addTarget:self action:@selector(setupSideMenu) forControlEvents:UIControlEventTouchUpInside];
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:[YAStoryTableViewCell className] bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    // 注册sectionHeaderView
    [self.tableView registerClass:[YASectionHeaderView class] forHeaderFooterViewReuseIdentifier:reuseIdentifier];

    
    
    


    [self.view.ya_refreshHeader beginRefreshing];

}


#pragma mark - 侧滑配置
- (void)setupSideMenu {
    [self.sideMenuViewController presentLeftMenuViewController];
}


#pragma mark - 刷新
// 加载更新
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
    
    // 发送请求
    [[YAHTTPManager sharedManager] requestWithMethod:GET WithPath:@"http://news-at.zhihu.com/api/4/news/latest" WithParameters:nil WithSuccessBlock:sblock WithFailurBlock:nil];
}

// 加载更多
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
  
    
    YASectionHeaderView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifier];
    NSString *formatString = [YAStoryItem formatStringWithDateString:[self.titleSection objectForKey:[NSNumber numberWithInteger:section]]];
    sectionHeaderView.sectionTitle = formatString;
    
    if (section == 0) { // 隐藏第0组标题
        sectionHeaderView.hidden = YES;
    } else {
        sectionHeaderView.hidden = NO;
    }
    return sectionHeaderView;
}

#pragma mark - tableView 代理
// headerView显示的那刻调用
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if (section == 0) {
        self.navigationView.height = 55;
        self.titleLabel.hidden = NO;
    }
}

// headerView消失的那刻调用
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section {
    if (section == 0) {
        self.navigationView.height = 20;
        self.titleLabel.hidden = YES;
    }
}


#pragma mark - scrollView代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offSetY = scrollView.contentOffset.y;

    // 下拉放大
    if (offSetY < 0 ) {
        CGRect frame = self.headerView.frame;
        frame.origin.y = offSetY - 20;
        frame.size.height = -offSetY + kHeaderViewHeight + 20;
        self.headerView.frame = frame;
    }
   

    // 导航view逐渐显示
    if (offSetY >= -1) {
        self.navigationView.alpha = offSetY / 200.0;
    }
    
    // 预加载
    CGSize contentSize = scrollView.contentSize;
    CGFloat y = offSetY + kScreenHeight;
    CGFloat reload_distance = 1400;
    if (y > contentSize.height - reload_distance) {
        if ([self.tableView.mj_footer isRefreshing]) {
            // 正在刷新,返回
        } else {
            [self.tableView.mj_footer beginRefreshing];
        }
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YAEditorListTableViewController *v = [[YAEditorListTableViewController alloc] init];
    [((UINavigationController *)self.sideMenuViewController.contentViewController) pushViewController:v animated:YES];

}

@end

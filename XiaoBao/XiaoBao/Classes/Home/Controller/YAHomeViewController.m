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
#import "YAContentViewController.h"
#import <UIViewController+MMDrawerController.h>
#import "YAErrorView.h"
#import "YAStoryDAL.h"

#define kHeaderViewHeight 200
#define kMargin 10
#define kRefreshViewWH 18

static NSString *reuseIdentifier = @"story";

@interface YAHomeViewController ()<UITableViewDelegate,UITableViewDataSource>
/** 滚动图片新闻 */
@property (nonatomic,strong)NSMutableArray *topStoryItems;
/** 组新闻 */
@property (nonatomic,strong) NSMutableDictionary *storySection;
///** 日期20170214 */
@property (nonatomic,copy) NSString *dateID;
/** sectionID对应section标题 */
@property (nonatomic,strong) NSMutableDictionary *titleSection;
/** 每section对应的ID */
@property (nonatomic,assign) NSInteger sectionID;
/** 展示story数据的tableView */
@property (nonatomic,strong) UITableView *tableView;
/** 自定义导航栏 */
@property (nonatomic,strong) UIView *navigationView;
/** "今日热闻"标题label */
@property (nonatomic,strong) UILabel *titleLabel;
/** 头部滚动视图 */
@property (nonatomic,strong) YAHomeHeaderView *headerView;
/** 顶部侧滑按钮 */
@property (nonatomic,weak) UIButton *sideMenuButton;
/** 加载视图 */
@property (nonatomic,weak) YAErrorView *errorView;
/** 日期格式化 */
@property (nonatomic,strong) NSDateFormatter *dateFormatter;
@end

@implementation YAHomeViewController


#pragma mark - view初始化
- (void)viewDidLoad {
    [super viewDidLoad];

    // 隐藏导航栏初始化时的黑色
    self.view.backgroundColor = [UIColor whiteColor];
    
    
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

    self.tableView.rowHeight = 90;
    // 设置侧滑
    [self.sideMenuButton addTarget:self action:@selector(setupSideMenu) forControlEvents:UIControlEventTouchUpInside];
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:[YAStoryTableViewCell className] bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    // 注册sectionHeaderView
    [self.tableView registerClass:[YASectionHeaderView class] forHeaderFooterViewReuseIdentifier:reuseIdentifier];

    // 加载视图处理
    self.errorView.hidden = NO;
    
    
    [self.view.ya_refreshHeader beginRefreshing];

}

#pragma mark - event response

//  侧滑配置
- (void)setupSideMenu {
    
    // 点击打开 再点击关闭
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];

}

// 加载最新
- (void)refreshForNewStories {
    
    [YAStoryDAL obtainNewStoryItemsWithSuccessBlock:^(NSArray<YAStoryItem *> *topStoryItems, NSArray<YAStoryItem *> *storyItems, NSString *dateID) {
        // 隐藏加载视图
        if (!self.errorView.hidden) {
            self.errorView.hidden = YES;
        }
        // 获取头部视图新闻
        [self.topStoryItems addObjectsFromArray:topStoryItems];
        
        // 设置轮播图
        self.headerView.storyItems = topStoryItems;
        self.headerView.hidden = NO;
        
        // 获取普通新闻
        [self.storySection setObject:storyItems forKey:[NSNumber numberWithInteger:self.sectionID]];
        
        // 存储日期ID
        self.dateID = dateID;
        
        // 保存每组索引对应的标题
        [self.titleSection setObject:self.dateID forKey:[NSNumber numberWithInteger:self.sectionID]];
        
        if (self.headerView.hidden) {
            self.headerView.hidden = NO;
        }
        
        // 刷新
        [self.tableView reloadData];
        

    } failureBlock:nil];

}

// 加载更多
- (void)refreshForMoreStories {
    
    [YAStoryDAL obtainStoryItemsWithDateID:self.dateID successBlock:^(NSArray<YAStoryItem *> *storyItems, NSString *dateID) {
        // 隐藏加载视图
        if (!self.errorView.hidden) {
            self.errorView.hidden = YES;
        }
        
        // 停止刷新
        [self.tableView.mj_footer endRefreshing];
        
        self.sectionID += 1;
        
        [self.storySection setObject:storyItems forKey:[NSNumber numberWithInteger:self.sectionID]];
        
        // 存储ID
        self.dateID = dateID;
        // 保存每组索引对应的标题
        [self.titleSection setObject:self.dateID forKey:[NSNumber numberWithInteger:self.sectionID]];
        // 刷新
        [self.tableView reloadData];
        
    } failureBlock:^(NSError *error) {
        // 停止刷新
        [self.tableView.mj_header endRefreshing];
    }];
    
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
    NSString *formatString = [self formatStringWithDateString:[self.titleSection objectForKey:[NSNumber numberWithInteger:section]]];
    sectionHeaderView.sectionTitle = formatString;
    
    if (section == 0) { // 隐藏第0组标题
        sectionHeaderView.hidden = YES;
    } else {
        sectionHeaderView.hidden = NO;
    }
    return sectionHeaderView;
}

#pragma mark - tableView delegate

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YAContentViewController *contentViewController =  [[YAContentViewController alloc] init];
    
    NSNumber *num = [NSNumber numberWithInteger:indexPath.section];
    YAStoryItem *story = self.storySection[num][indexPath.row];
    contentViewController.ID = story.ID;
    
    
    
    [self.navigationController pushViewController:contentViewController animated:YES];
}


#pragma mark - scrollView delegate

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


#pragma mark - Private Methods

- (void)launchAnimation {
    UIViewController *viewController = [[UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil] instantiateViewControllerWithIdentifier:@"LaunchScreen"];
    
    UIView *launchView = viewController.view;
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
    launchView.frame = [UIApplication sharedApplication].keyWindow.frame;
    [mainWindow addSubview:launchView];
    
    [UIView animateWithDuration:1.0f delay:0.5f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        launchView.alpha = 0.0f;
        launchView.layer.transform = CATransform3DScale(CATransform3DIdentity, 2.0f, 2.0f, 1.0f);
    } completion:^(BOOL finished) {
        [launchView removeFromSuperview];
    }];
}

// 格式化时间字符串
- (NSString *)formatStringWithDateString:(NSString *)string {
    [self.dateFormatter setDateFormat:@"yyyyMMdd"];
    NSDate *date = [self.dateFormatter dateFromString:string];
    
    NSString *firstString = [NSString stringWithFormat:@"%02ld月%02ld日",date.month,date.day];
    [self.dateFormatter setDateFormat:@"EEEE"];
    
    return [NSString stringWithFormat:@"%@ %@",firstString,[self.dateFormatter stringFromDate:date]];
}

#pragma mark - getter and setter

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
        // 默认没有数据时隐藏
        _headerView.hidden = YES;
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
        
        // 没有数据隐藏分割线
        _tableView.tableFooterView = [[UIView alloc] init];
        
        // 容错视图
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

- (YAErrorView *)errorView {
    if (_errorView == nil) {
        YAErrorView *errorView = [YAErrorView errorView];
        
        [self.view addSubview:errorView];
        _errorView = errorView;
    }
    return _errorView;
}

- (NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}
@end

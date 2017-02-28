//
//  YASideViewController.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/15.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YASideViewController.h"
#import "YAThemeTableViewCell.h"
#import "YAThemeItem.h"
#import "YAThemeViewController.h"
#import "YAHomeViewController.h"
#import <UIViewController+MMDrawerController.h>
#import "YASettingViewController.h"
#import "YANavigationView.h"

static NSString *reuseIdentifier = @"YAThemeTableViewCell";

@interface YASideViewController () <UITableViewDelegate,UITableViewDataSource>
/** 数据展示tableView */
@property (weak, nonatomic) IBOutlet UITableView *themeTableView;
/** theme数组 */
@property (nonatomic,strong) NSMutableArray <YAThemeItem *> *themes;
/** 首页item */
@property (nonatomic,strong) YAThemeItem *homeItem;
/** 是否正在刷新 */
@property (nonatomic,assign) BOOL isRefreshing;
@end

@implementation YASideViewController

#pragma mark - life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 注册tableView
    [self.themeTableView registerNib:[UINib nibWithNibName:[YAThemeTableViewCell className] bundle:nil] forCellReuseIdentifier:reuseIdentifier];

        
    // 自动刷新
    [self refreshForNewState];
}


#pragma mark - tableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.themes.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YAThemeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.theme = self.themes[indexPath.row];
    return cell;
}


#pragma mark - tableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *themeID = self.themes[indexPath.row].ID;
    if ([themeID isEqualToString:@"首页"]) {
        
        UINavigationController *contentNavigationController = [[UINavigationController alloc] initWithRootViewController:[[YAHomeViewController alloc] init]];

        // 设置中心控制器
        [self.mm_drawerController setCenterViewController:contentNavigationController withCloseAnimation:YES completion:nil];

    } else {
        YAThemeViewController *themeViewController = [[YAThemeViewController alloc] init];
        themeViewController.themeID = themeID;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:themeViewController];
        
        // 设置中心导航控制器
        [self.mm_drawerController setCenterViewController:navigationController withCloseAnimation:YES completion:nil];
    }
 
}


#pragma mark - scrollView delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (-offsetY > 40 && self.isRefreshing == NO) {
            // 刷新
        [self refreshForNewState];

    }
}

#pragma mark - event response

// 设置页面
- (IBAction)pushToSettingViewController:(UIButton *)sender {
    YASettingViewController *settingViewController = [YASettingViewController settingViewController];
    UINavigationController *navigationViewController = [[UINavigationController alloc] initWithRootViewController:settingViewController];
    [self.mm_drawerController setCenterViewController:navigationViewController withCloseAnimation:YES completion:nil];
}


// 夜间模式
- (IBAction)fallNightMode:(UIButton *)sender {
    DKThemeVersion *themeVersion = [DKNightVersionManager sharedManager].themeVersion;
    if ([themeVersion isEqualToString:DKThemeVersionNormal]) {
        [[DKNightVersionManager sharedManager] nightFalling];
        [sender setTitle:@"白天" forState:UIControlStateNormal];
    } else {
        [[DKNightVersionManager sharedManager] dawnComing];
        [sender setTitle:@"夜间" forState:UIControlStateNormal];
    }
    
}

// 配置刷新
- (void)refreshForNewState {
    requestSuccessBlock sblock = ^(id responseObject){
        self.isRefreshing = NO;
        [self.themes removeAllObjects];
        NSMutableArray *array = (NSMutableArray *)[YAThemeItem themeItemsWithOtherKeyValues:responseObject];
        
        [array insertObject:self.homeItem atIndex:0];
        
        [self.themes addObjectsFromArray:array];
        
        [self.themeTableView reloadData];
        
        
        // 第一次刷新后选中第一行
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            [self.themeTableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        });
        
    };
    requestFailureBlock fblock = ^(NSError *error){
        self.isRefreshing = NO;
        kLog(@"失败");
    };
    [[YAHTTPManager sharedManager] requestWithMethod:GET WithPath:@"http://news-at.zhihu.com/api/4/themes" WithParameters:nil WithSuccessBlock:sblock WithFailurBlock:fblock];
}


#pragma mark - getter and setter

- (NSMutableArray *)themes {
    if (_themes == nil) {
        _themes = [NSMutableArray array];
    }
    return _themes;
}

- (YAThemeItem *)homeItem {
    if (_homeItem == nil) {
        _homeItem = [[YAThemeItem alloc] init];
        _homeItem.name = @"首页";
        _homeItem.ID = @"首页";
    }
    return _homeItem;
}


@end

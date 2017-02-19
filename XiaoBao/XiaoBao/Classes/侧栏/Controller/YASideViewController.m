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

static NSString *reuseIdentifier = @"YAThemeTableViewCell";
@interface YASideViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *themeTableView;
/** theme数组 */
@property (nonatomic,strong) NSMutableArray <YAThemeItem *> *themes;

@property (nonatomic,assign) BOOL isRefreshing;
@end

@implementation YASideViewController

#pragma mark - 懒加载
- (NSMutableArray *)themes {
    if (_themes == nil) {
        _themes = [NSMutableArray array];
        YAThemeItem *firstItem = [[YAThemeItem alloc] init];
        firstItem.name = @"首页";
        [_themes addObject:firstItem];
    }
    return _themes;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    
    // 注册tableView
    [self.themeTableView registerNib:[UINib nibWithNibName:[YAThemeTableViewCell className] bundle:nil] forCellReuseIdentifier:reuseIdentifier];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    
    
    // 自动刷新
    [self refreshForNewState];

    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.themeTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}


#pragma mark - 配置刷新
- (void)refreshForNewState {
    requestSuccessBlock sblock = ^(id responseObject){
        self.isRefreshing = NO;
        NSArray *array = [YAThemeItem themeItemsWithOtherKeyValues:responseObject];
        [self.themes addObjectsFromArray:array];
        
        [self.themeTableView reloadData];
    };
    requestFailureBlock fblock = ^(NSError *error){
        self.isRefreshing = NO;
        kLog(@"失败");
    };
    [[YAHTTPManager sharedManager] requestWithMethod:GET WithPath:@"http://news-at.zhihu.com/api/4/themes" WithParameters:nil WithSuccessBlock:sblock WithFailurBlock:fblock];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView 数据源
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

#pragma mark - scrollView代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
   // kLog(@"%f",offsetY);

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (-offsetY > 60 && self.isRefreshing == NO) {
            // 刷新
        [self refreshForNewState];
        kLog(@"刷新");

    }
}
@end

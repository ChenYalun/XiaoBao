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
/** 首页item */
@property (nonatomic,strong) YAThemeItem *homeItem;
@property (nonatomic,assign) BOOL isRefreshing;
@end

@implementation YASideViewController

#pragma mark - 懒加载
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
    }
    return _homeItem;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    
    // 注册tableView
    [self.themeTableView registerNib:[UINib nibWithNibName:[YAThemeTableViewCell className] bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    UIImageView *i = [[UIImageView alloc] init];
//    i.layer.masksToBounds = YES;
//    i.layer.cornerRadius = i.width * 0.5;
    
    
    
    // 自动刷新
    [self refreshForNewState];

    
 
        
        
    

}



#pragma mark - 配置刷新
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
#pragma mark - tableView代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    

}

#pragma mark - scrollView代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //CGFloat offsetY = scrollView.contentOffset.y;
   // kLog(@"%f",offsetY);

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (-offsetY > 40 && self.isRefreshing == NO) {
            // 刷新
        [self refreshForNewState];

    }
}
@end

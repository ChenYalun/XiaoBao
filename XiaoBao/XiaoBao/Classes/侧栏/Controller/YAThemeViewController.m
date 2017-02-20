//
//  YAThemeViewController.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/19.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YAThemeViewController.h"
#import "YAStoryTableViewCell.h"
#import "YAHTTPManager.h"
//#import "YARefreshHeader.h"
#import "YAThemeStoryItem.h"
#import <YYWebImageManager.h>
#import <MJRefresh.h>
#import <GPUImage.h>
#import <RESideMenu.h>
static NSString *reuseIdentifier = @"story";
@interface YAThemeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray <YAStoryItem *> *stories;
@property (weak, nonatomic) IBOutlet UIImageView *topBackgroundImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBackgroundImageHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation YAThemeViewController
#pragma mark - 懒加载
- (NSMutableArray *)stories {
    if (_stories == nil) {
        _stories = [NSMutableArray array];
    }
    return _stories;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //[self setupNavigationBar];
    
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:[YAStoryTableViewCell className] bundle:nil] forCellReuseIdentifier:reuseIdentifier];
//    
//    self.tableView.ya_refreshHeader = [YARefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshForNewStories)];
//
//    self.tableView.ya_refreshHeader.attachScrollView = self.tableView;
//    
//    [self.tableView.ya_refreshHeader beginRefreshing];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshForNewStories)];
    
    [self.tableView.mj_header beginRefreshing];
}


#pragma mark - 设置导航栏
- (void)setupNavigationBar {
    // 设置导航条
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    
    // 设置导航栏按钮
    UIButton *leftButton = [[UIButton alloc] init];
    [leftButton setImage:kGetImage(@"Dark_News_Arrow") forState:UIControlStateNormal];
    leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    [leftButton sizeToFit];
    [leftButton addTarget:self action:@selector(presentMenuViewController) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton *rightButton = [[UIButton alloc] init];
    [rightButton setImage:kGetImage(@"Dark_Management_Add") forState:UIControlStateNormal];
    [rightButton setImage:kGetImage(@"Dark_Management_Cancel") forState:UIControlStateSelected];
    
    [rightButton sizeToFit];
    [rightButton addTarget:self action:@selector(subscribeTheme:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    

    
    
    
}
#pragma mark - 导航栏按钮事件
- (IBAction)presentMenuViewController:(UIButton *)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}

#warning 订阅
- (IBAction)subscribeTheme:(UIButton *)sender {
    if (sender.selected) {
        // 取消订阅
    } else {
        // 订阅
    }
}

#pragma mark - 刷新
- (void)refreshForNewStories {

    
    
    requestSuccessBlock sblock = ^(id responseObject){
        [self.tableView.mj_header endRefreshing];
        YAThemeStoryItem *themeStoryItem = [YAThemeStoryItem themeStoryItemWithKeyValues:responseObject];
        self.stories = (NSMutableArray *)themeStoryItem.stories;
        
        // 设置导航视图
        [[YYWebImageManager sharedManager]  requestImageWithURL:[NSURL URLWithString:themeStoryItem.image] options:YYWebImageOptionShowNetworkActivity progress:nil transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            
            // 高斯模糊
            dispatch_async(dispatch_get_main_queue(), ^{
                GPUImageGaussianBlurFilter * blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
                blurFilter.blurRadiusInPixels = 10;// 模糊程度
                UIImage *blurredImage = [blurFilter imageByFilteringImage:image];
                self.topBackgroundImageView.image = blurredImage;
            });

            
        }];
        
        self.titleLabel.text = themeStoryItem.name;

        
        
        [self.tableView reloadData];
        

    };
    
    
    requestFailureBlock fblock = ^(NSError *error){
        [self.tableView.mj_header endRefreshing];
        kLog(@"刷新失败");
    };
    
    // 请求路径
    NSString *urlPath = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/theme/%@",self.themeID];
    
    // 发送请求
    [[YAHTTPManager sharedManager] requestWithMethod:GET WithPath:urlPath WithParameters:nil WithSuccessBlock:sblock WithFailurBlock:fblock];
}

#pragma mark - tableView数据源
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.stories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YAStoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.story = self.stories[indexPath.row];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (-offsetY > 0) {
        self.topBackgroundImageHeightConstraint.constant = 64 - offsetY;
    } else {
        self.topBackgroundImageHeightConstraint.constant = 64;
    }
    
    kLog(@"%f",-offsetY);
    
}

@end

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
#import "YARefreshHeader.h"
#import "YAThemeStoryItem.h"
#import <YYWebImageManager.h>
#import "YAThemeTableViewHeader.h"
#import <GPUImage.h>
#import <UIViewController+MMDrawerController.h>
#import "YAEditorItem.h"
#import "YAEditorListViewController.h"
#import "YAContentViewController.h"
static NSString *reuseIdentifier = @"story";
@interface YAThemeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray <YAStoryItem *> *stories;
@property (weak, nonatomic) IBOutlet UIImageView *topBackgroundImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBackgroundImageHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** 刷新控件 */
@property (weak, nonatomic) IBOutlet YARefreshHeader *refreshHeader;
/** 高斯模糊 */
@property (nonatomic,strong) GPUImageGaussianBlurFilter * blurFilter;
@property (nonatomic,strong) UIImage *topBackgroundImage;


@property (nonatomic,strong) UITapGestureRecognizer *tap;
@end

@implementation YAThemeViewController
#pragma mark - 懒加载
- (NSMutableArray *)stories {
    if (_stories == nil) {
        _stories = [NSMutableArray array];
    }
    return _stories;
}

- (UITapGestureRecognizer *)tap {
    if (_tap == nil) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(presentEditorListTableViewController)];
        
    }
    return _tap;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //[self setupNavigationBar];
    
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    // 设置tableView header
    YAThemeTableViewHeader *headerView = [YAThemeTableViewHeader header];
    self.tableView.tableHeaderView = headerView;

    // 添加手势
    [self.tableView.tableHeaderView addGestureRecognizer:self.tap];
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:[YAStoryTableViewCell className] bundle:nil] forCellReuseIdentifier:reuseIdentifier];


    self.refreshHeader.refreshingTarget = self;
    self.refreshHeader.refreshingAction = @selector(refreshForNewStories);
    self.refreshHeader.attachScrollView = self.tableView;
    
    [self.refreshHeader beginRefreshing];
    

}

- (GPUImageGaussianBlurFilter *)blurFilter {
    if (_blurFilter == nil) {
        _blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
    }
    return _blurFilter;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
        self.tableView.tableHeaderView.height = 44;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - 导航栏按钮事件
- (IBAction)presentMenuViewController:(UIButton *)sender {
    // 点击打开 再点击关闭
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];

}

#warning 订阅
- (IBAction)subscribeTheme:(UIButton *)sender {
    if (sender.selected) {
        // 取消订阅
        
    } else {
        // 订阅
    }
    sender.selected = !sender.selected;
}


#pragma mark - 刷新
- (void)refreshForNewStories {

    
    
    requestSuccessBlock sblock = ^(id responseObject){

        YAThemeStoryItem *themeStoryItem = [YAThemeStoryItem themeStoryItemWithKeyValues:responseObject];
        self.stories = (NSMutableArray *)themeStoryItem.stories;
        
        // 设置tableView header
        YAThemeTableViewHeader *header = (YAThemeTableViewHeader *)self.tableView.tableHeaderView;
        header.editors = [YAEditorItem itemsWithKeyValues:responseObject];
        
        
        // 设置导航视图
        [[YYWebImageManager sharedManager]  requestImageWithURL:[NSURL URLWithString:themeStoryItem.background] options:YYWebImageOptionShowNetworkActivity progress:nil transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            
            self.topBackgroundImage = image;

            // 容错处理,保证image不为空
            if (image) {
                // 高斯模糊
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.blurFilter.blurRadiusInPixels = 10;// 模糊程度
                    UIImage *blurredImage = [self.blurFilter imageByFilteringImage:image];
                    self.topBackgroundImageView.image = blurredImage;
                });
            }
            
           

            
        }];
        
        // 设置标题
        self.titleLabel.text = themeStoryItem.name;

        
        
        [self.tableView reloadData];
        

    };
    
    
    requestFailureBlock fblock = ^(NSError *error){
   
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
    CGPoint contentOffset = scrollView.contentOffset;
    
    // 图片拉伸
    if (-contentOffset.y > 0) {
        self.topBackgroundImageHeightConstraint.constant = 64 - contentOffset.y;
    } else {
        self.topBackgroundImageHeightConstraint.constant = 64;
    }
    
    
    
    // 禁止继续向下拉动
    if (-contentOffset.y > 130) {
        
        contentOffset.y = -130;
        scrollView.contentOffset = contentOffset;
    }

    
    // 处理图片高斯模糊10---0  0----130
    if (-contentOffset.y > 0 && -contentOffset.y <= 130) {
        self.blurFilter.blurRadiusInPixels = 10 - (-contentOffset.y / 130.0) * 10;
        UIImage *blurredImage = [self.blurFilter imageByFilteringImage:self.topBackgroundImage];
        
        self.topBackgroundImageView.image = blurredImage;
    } else {
        self.blurFilter.blurRadiusInPixels = 10;
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YAContentViewController *contentViewController = [[YAContentViewController alloc] init];
    contentViewController.ID = self.stories[indexPath.row].ID ;

    [self.navigationController pushViewController:contentViewController animated:YES];
    

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    self.navigationController.navigationBar.hidden = YES;
    
}
#pragma mark - 页面跳转到编辑tableView
- (void)presentEditorListTableViewController {
    YAEditorListViewController *editorViewController = [[YAEditorListViewController alloc] init];
    YAThemeTableViewHeader *header = (YAThemeTableViewHeader *)self.tableView.tableHeaderView;
    editorViewController.editors = header.editors;
    [self.navigationController pushViewController:editorViewController animated:YES];
    
}
@end

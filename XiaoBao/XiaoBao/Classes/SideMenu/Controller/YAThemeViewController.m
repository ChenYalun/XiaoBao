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
#import <UIViewController+MMDrawerController.h>
#import "YAEditorItem.h"
#import "YAEditorListViewController.h"
#import "YAContentViewController.h"
#import "UIImage+YAVImage.h"

static NSString *reuseIdentifier = @"story";

@interface YAThemeViewController ()<UITableViewDelegate,UITableViewDataSource>
/** 数据展示tableView */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 存储story的数组 */
@property (nonatomic,strong) NSMutableArray <YAStoryItem *> *stories;
/** 背景图片 */
@property (weak, nonatomic) IBOutlet UIImageView *topBackgroundImageView;
/** 顶部高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBackgroundImageHeightConstraint;
/** 标题 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** 刷新控件 */
@property (weak, nonatomic) IBOutlet YARefreshHeader *refreshHeader;
/** 高斯模糊 */
//@property (nonatomic,strong) GPUImageGaussianBlurFilter * blurFilter;
/** 背景图片 */
@property (nonatomic,strong) UIImage *topBackgroundImage;
/** 点击手势 */
@property (nonatomic,strong) UITapGestureRecognizer *tap;
@end

@implementation YAThemeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    // 设置tableView header
    YAThemeTableViewHeader *headerView = [YAThemeTableViewHeader header];
    self.tableView.tableHeaderView = headerView;

    // 添加手势
    [self.tableView.tableHeaderView addGestureRecognizer:self.tap];
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:[YAStoryTableViewCell className] bundle:nil] forCellReuseIdentifier:reuseIdentifier];


    // 处理刷新控件
    self.refreshHeader.refreshingTarget = self;
    self.refreshHeader.refreshingAction = @selector(refreshForNewStories);
    self.refreshHeader.attachScrollView = self.tableView;
    
    // 开始刷新
    [self.refreshHeader beginRefreshing];

}

#pragma mark - life Cycle

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.tableView.tableHeaderView.height = 44;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
}

#pragma mark - event response

// 点击菜单按钮
- (IBAction)presentMenuViewController:(UIButton *)sender {
    
    // 点击打开 再点击关闭
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];

}

// 订阅
- (IBAction)subscribeTheme:(UIButton *)sender {
    if (sender.selected) {
        // 取消订阅
        
    } else {
        // 订阅
    }
    sender.selected = !sender.selected;
}

// 刷新
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
        
            dispatch_async(dispatch_get_main_queue(), ^{
                self.topBackgroundImageView.image = [UIImage boxblurImage:self.topBackgroundImage withBlurNumber:1];
            });
            
            
        }];
        
        // 设置标题
        self.titleLabel.text = themeStoryItem.name;

        // 刷新数据
        [self.tableView reloadData];
        
    };
    
    
    // 请求路径
    NSString *urlPath = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/theme/%@",self.themeID];
    
    // 发送请求
    [[YAHTTPManager sharedManager] requestWithMethod:GET WithPath:urlPath WithParameters:nil WithSuccessBlock:sblock WithFailurBlock:nil];
}

// 页面跳转到编辑tableView
- (void)presentEditorListTableViewController {
    YAEditorListViewController *editorViewController = [[YAEditorListViewController alloc] init];
    YAThemeTableViewHeader *header = (YAThemeTableViewHeader *)self.tableView.tableHeaderView;
    editorViewController.editors = header.editors;
    [self.navigationController pushViewController:editorViewController animated:YES];
    
}


#pragma mark - tableView datasource

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

#pragma mark - scrollView delegate

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

    // 处理图片高斯模糊1---0  0----130
    if (-contentOffset.y > 0 && -contentOffset.y <= 130) {
        CGFloat blurRadiusInPixels = 1 + contentOffset.y / 130.0 ;
        self.topBackgroundImageView.image = [UIImage boxblurImage:self.topBackgroundImage withBlurNumber:blurRadiusInPixels];
    } else {
        self.topBackgroundImageView.image = [UIImage boxblurImage:self.topBackgroundImage withBlurNumber:1];
    }
    
    
}

#pragma mark - tableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YAContentViewController *contentViewController = [[YAContentViewController alloc] init];
    contentViewController.ID = self.stories[indexPath.row].ID;
    contentViewController.isThemeStory = YES;

    [self.navigationController pushViewController:contentViewController animated:YES];
    
}


#pragma mark - getter and setter

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

//- (GPUImageGaussianBlurFilter *)blurFilter {
//    if (_blurFilter == nil) {
//        _blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
//    }
//    return _blurFilter;
//}

@end

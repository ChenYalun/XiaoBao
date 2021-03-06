//
//  YAHomeHeaderView.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/16.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YAHomeHeaderView.h"
#import "YAStoryHeaderView.h"
#import "YAContentViewController.h"

#define kHeaderViewHeight 220
#define kHeaderViewCount 5

@interface YAHomeHeaderView()<UIScrollViewDelegate>
/** 页码指示 */
@property (nonatomic,strong) UIPageControl *pageControl;
/** 滚动scrollView */
@property (nonatomic,strong) UIScrollView *picScrollView;
/** 定时器 */
@property (nonatomic,strong) NSTimer *timer;
/** 当前页码 */
@property (nonatomic,assign) NSInteger currentPageIndex;
/** 左边视图 */
@property (nonatomic,strong) YAStoryHeaderView *leftView;
/** 中间视图 */
@property (nonatomic,strong) YAStoryHeaderView *centerView;
/** 右边视图 */
@property (nonatomic,strong) YAStoryHeaderView *rightView;
/** 手势 */
@property (nonatomic,strong) UITapGestureRecognizer *tap;
@end
@implementation YAHomeHeaderView

#pragma mark - life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //         通过xib创建的view无法显示
        //        YAStoryHeaderView *headerView = [[YAStoryHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
        // 添加scrollView
        [self addSubview:self.picScrollView];
        
        // 添加imageView
        self.leftView = [[NSBundle mainBundle] loadNibNamed:[YAStoryHeaderView className] owner:nil options:nil].firstObject;
        self.centerView = [[NSBundle mainBundle] loadNibNamed:[YAStoryHeaderView className] owner:nil options:nil].firstObject;
        self.rightView = [[NSBundle mainBundle] loadNibNamed:[YAStoryHeaderView className] owner:nil options:nil].firstObject;

        [self.leftView addGestureRecognizer:self.tap];
        [self.rightView addGestureRecognizer:self.tap];
        [self.centerView addGestureRecognizer:self.tap];
        
        [self.picScrollView addSubview:self.leftView];
        [self.picScrollView addSubview:self.centerView];
        [self.picScrollView addSubview:self.rightView];
        // 添加pageControl,要注意添加到自身上
        [self addSubview:self.pageControl];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    // 添加到视图
    self.picScrollView.frame = self.bounds;
    // 先设置父视图再设置子视图
    self.leftView.frame = CGRectMake(0, 0, kScreenWidth, self.height);
    self.centerView.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, self.height);
    self.rightView.frame = CGRectMake(2 * kScreenWidth, 0, kScreenWidth, self.height);
    self.pageControl.frame = CGRectMake(0, self.height - 35, kScreenWidth, 34);
}

#pragma mark - event response

// 定时器
- (void)setupTimer {
    self.timer = [NSTimer timerWithTimeInterval:8.0 block:^(NSTimer * _Nonnull timer) {
        [self turnRightPage];
    } repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}


//  滚动视图
- (void)turnLeftPage {
    
    self.pageControl.currentPage = (self.pageControl.currentPage - 1 + kHeaderViewCount) % kHeaderViewCount;
    [self.picScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)turnRightPage {
    self.pageControl.currentPage = (self.pageControl.currentPage + 1) % kHeaderViewCount;
    [self.picScrollView setContentOffset:CGPointMake(2 * kScreenWidth, 0) animated:YES];
}

// 刷新
- (void)reloadView {
    NSInteger leftImageIndex,rightImageIndex;
    leftImageIndex = (self.pageControl.currentPage + kHeaderViewCount - 1) % kHeaderViewCount;
    rightImageIndex = (self.pageControl.currentPage + 1) % kHeaderViewCount;
    
    self.centerView.story = self.storyItems[self.pageControl.currentPage];
    self.leftView.story = self.storyItems[leftImageIndex];
    self.rightView.story = self.storyItems[rightImageIndex];
    
}


#pragma mark - 代理方法
//检测UIScrollView滚动动画是否结束
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self reloadView];
    [self.picScrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:NO];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // 停止定时器
    [self.timer invalidate];
    self.timer = nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self setupTimer];
    
    if (scrollView.contentOffset.x < kScreenWidth) {
        [self turnLeftPage];
    } else {
        [self turnRightPage];
    }
}

#pragma mark - getter and setter

- (UITapGestureRecognizer *)tap {
    if (_tap == nil) {
        _tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(UITapGestureRecognizer *  _Nonnull sender) {
            YAContentViewController *contentViewController = [[YAContentViewController alloc] init];
            YAStoryHeaderView *headerView = (YAStoryHeaderView *)sender.view;
            contentViewController.ID = headerView.story.ID;
            [self.viewController.navigationController pushViewController:contentViewController animated:YES];
        }];
    }
    return _tap;
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc]init];
        //总页数
        _pageControl.numberOfPages = kHeaderViewCount;   //NSInteger类型
        //当前第几页（范围是 0 ~ （numberOfPages - 1））
        _pageControl.currentPage = 0;  //NSInteger类型
        //只有一页的时候隐藏
        _pageControl.hidesForSinglePage = YES;//默认为NO
        //设置当前页指示器的颜色
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        //设置指示器的颜色
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        
    }
    return _pageControl;
}

- (UIScrollView *)picScrollView {
    if (_picScrollView == nil) {
        _picScrollView = [[UIScrollView alloc] init];
        _picScrollView.showsHorizontalScrollIndicator = NO;
        _picScrollView.pagingEnabled = YES;
        _picScrollView.delegate = self;
        
        // 设置无限循环
        _picScrollView.contentSize = CGSizeMake(kScreenWidth * 3, self.height);
        [_picScrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:NO];
    }
    return _picScrollView;
}

- (void)setStoryItems:(NSArray *)storyItems {
    _storyItems = storyItems;
    
    // 刷新视图并开启定时器
    [self reloadView];
    [self setupTimer];
}
@end

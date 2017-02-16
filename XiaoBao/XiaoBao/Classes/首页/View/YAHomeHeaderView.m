//
//  YAHomeHeaderView.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/16.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YAHomeHeaderView.h"
#import "YAStoryHeaderView.h"
#define kHeaderViewHeight 200
#define kHeaderViewCount 5
@interface YAHomeHeaderView()<UIScrollViewDelegate>
@property (nonatomic,strong) NSMutableArray <YAStoryHeaderView *> *headerViews;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) UIScrollView *picScrollView;
@end
@implementation YAHomeHeaderView

- (NSMutableArray<YAStoryHeaderView *> *)headerViews {
    if (_headerViews == nil) {
        _headerViews = [NSMutableArray array];
        
        for (NSInteger i = 0; i < kHeaderViewCount; i++) {
            YAStoryHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:[YAStoryHeaderView className] owner:nil options:nil].firstObject;
            [self.picScrollView addSubview:headerView];
            [_headerViews addObject:headerView];
        }

    }
    return _headerViews;
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc]init];
        //总页数
        _pageControl.numberOfPages = 5;   //NSInteger类型
        //当前第几页（范围是 0 ~ （numberOfPages - 1））
        _pageControl.currentPage = 0;  //NSInteger类型
        //只有一页的时候隐藏
        _pageControl.hidesForSinglePage = YES;//默认为NO
        //设置当前页指示器的颜色
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        //设置指示器的颜色
        _pageControl.pageIndicatorTintColor = [UIColor blackColor];
        
    }
    return _pageControl;
}

- (UIScrollView *)picScrollView {
    if (_picScrollView == nil) {
        _picScrollView = [[UIScrollView alloc] init];
        _picScrollView.contentSize = CGSizeMake(kScreenWidth * kHeaderViewCount, kHeaderViewHeight);
        _picScrollView.showsHorizontalScrollIndicator = NO;
        _picScrollView.pagingEnabled = YES;
        _picScrollView.delegate = self;
    }
    return _picScrollView;
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //         通过xib创建的view无法显示
        //        YAStoryHeaderView *headerView = [[YAStoryHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
        // 设置scrollView
        [self addSubview:self.picScrollView];
        
        // 设置pageContro
        [self addSubview:self.pageControl];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    [self.headerViews enumerateObjectsUsingBlock:^(YAStoryHeaderView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        view.frame = CGRectMake(kScreenWidth * idx, 0, kScreenWidth, kHeaderViewHeight);
    }];
    
    // 添加到视图
    self.picScrollView.frame = self.bounds;
    self.pageControl.frame = CGRectMake(0, 150, kScreenWidth, 34);
}
- (void)setStoryItems:(NSArray *)storyItems {
    _storyItems = storyItems;
    
    // 遍历YAStoryHeaderView
    // NSEnumerationConcurrent并发遍历 会出现问题
    // NSEnumerationReverse 逆制
    /*
    [self.headerViews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(YAStoryHeaderView *view, NSUInteger index, BOOL *stop) {
        view.frame = CGRectMake(kScreenWidth * index, 0, kScreenWidth, 200);
            view.story = storyItems[index];

    }];
    */
    
    // 普通遍历
    /*
    for (NSInteger i = 0; i < 5; i++) {
        self.headerViews[i].frame = CGRectMake(kScreenWidth * i, 0, kScreenWidth, 200);
        self.headerViews[i].story = storyItems[i];
    }
     */

    
    [self.headerViews enumerateObjectsUsingBlock:^(YAStoryHeaderView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        view.story = storyItems[idx];
    }];
    
}

#pragma mark - 代理方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //获取偏移量
    NSInteger currentPage = scrollView.contentOffset.x / kScreenWidth;
    //改变pageControl的显示
    self.pageControl.currentPage = currentPage;
    NSLog(@"%@",self.pageControl.superview);
}
@end

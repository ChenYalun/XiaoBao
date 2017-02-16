//
//  YAHomeHeaderScrollView.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/16.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YAHomeHeaderScrollView.h"
#import "YAStoryHeaderView.h"
#define kHeaderViewHeight 200
#define kHeaderViewCount 5
@interface YAHomeHeaderScrollView()<UIScrollViewDelegate>
@property (nonatomic,strong) NSMutableArray <YAStoryHeaderView *> *headerViews;
@end
@implementation YAHomeHeaderScrollView

- (NSMutableArray<YAStoryHeaderView *> *)headerViews {
    if (_headerViews == nil) {
        _headerViews = [NSMutableArray array];
        
        for (NSInteger i = 0; i < kHeaderViewCount; i++) {
            YAStoryHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:[YAStoryHeaderView className] owner:nil options:nil].firstObject;
            [self addSubview:headerView];
            [_headerViews addObject:headerView];
        }

    }
    return _headerViews;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//         通过xib创建的view无法显示
//        YAStoryHeaderView *headerView = [[YAStoryHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
        self.contentSize = CGSizeMake(kScreenWidth * kHeaderViewCount, kHeaderViewHeight);
        self.showsHorizontalScrollIndicator = NO;
        self.pagingEnabled = YES;
        self.delegate = self;
    }
    return self;
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
        view.frame = CGRectMake(kScreenWidth * idx, 0, kScreenWidth, kHeaderViewHeight);
        view.story = storyItems[idx];
    }];
}

#pragma mark - 代理方法

@end

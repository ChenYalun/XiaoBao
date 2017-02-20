//
//  YARefreshHeader.h
//  NanDe
//
//  Created by 陈亚伦 on 2017/2/13.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>


@interface YARefreshHeader : UIView
/** 绑定的scrollView */
@property (nonatomic,strong) UIScrollView *attachScrollView; // 使用strong
/** 回调对象 */
@property (weak, nonatomic) id refreshingTarget;
/** 回调方法 */
@property (assign, nonatomic) SEL refreshingAction;

- (void)beginRefreshing;
+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;
@end


#pragma mark 头部刷新控件分类 
@interface UIView (YARefreshHeader)
@property  YARefreshHeader *ya_refreshHeader;
@end

@implementation UIView (YARefreshHeader)

static const char YARefreshHeadererKey = '\0';

- (YARefreshHeader *)ya_refreshHeader {
    return objc_getAssociatedObject(self, &YARefreshHeadererKey);
}
- (void)setYa_refreshHeader:(UIView *)ya_refreshHeader {

    if (ya_refreshHeader != self.ya_refreshHeader) {
        [self.ya_refreshHeader removeFromSuperview];
        [self addSubview:ya_refreshHeader];
        
        objc_setAssociatedObject(self, &YARefreshHeadererKey, ya_refreshHeader, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}




@end

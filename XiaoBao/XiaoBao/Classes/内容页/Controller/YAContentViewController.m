//
//  YAContentViewController.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/21.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YAContentViewController.h"
#import <WebKit/WebKit.h>
#import "YAContentItem.h"
#import "YAHTTPManager.h"
#import <UIImageView+YYWebImage.h>

// xib 中topView高度约束
#define kTopImageHeight 220
@interface YAContentViewController ()<WKNavigationDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
/** webView */
//@property (nonatomic,weak) WKWebView *webView;
/** 头部视图 */
@property (nonatomic,weak) IBOutlet UIView *topView;
/** 头部视图图片 */
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;

@end

@implementation YAContentViewController
#pragma mark - 懒加载
//- (UIView *)topView {
//    if (_topView == nil) {
//        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kTopImageHeight)];
//        topView.contentMode = UIViewContentModeScaleAspectFill;
//        [self.view addSubview:topView];
//        _topView = topView;
//    }
//    return _topView;
//}


/*
- (WKWebView *)webView {
    if (_webView == nil) {
        
        WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 44)];
//        webView.scrollView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
        
        // 设置代理
        webView.navigationDelegate = self;
        webView.scrollView.delegate = self;
        
        // 自适应屏幕宽度js
        NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *contentController = webView.configuration.userContentController;
        
        // 添加自适应屏幕宽度js调用的方法
        [contentController addUserScript:wkUserScript];
        

        [self.view addSubview:webView];
        _webView = webView;

    }
    return _webView;
}
*/


- (void)viewDidLoad {
    [super viewDidLoad];

    self.webView.scrollView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    //self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self requestForData];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 请求数据
- (void)requestForData {
    
    NSString *requestUrl = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/news/%ld",self.story.ID];
    requestSuccessBlock sblock = ^(id responseObject){
    
        YAContentItem *content = [YAContentItem contentItemWithKeyValues:responseObject];



        // 处理内容
        NSString *htmlString = [NSString stringWithFormat:@"<html><head><link rel=\"stylesheet\" type=\"text/css\" href=%@ /></head><body>%@</body></html>", content.css.firstObject, content.body];
        [self.webView loadHTMLString:htmlString baseURL:nil];
        self.webView.scrollView.delegate = self;
        
        
        // 处理图片
        [self.topImageView yy_setImageWithURL:[NSURL URLWithString:content.image] options:YYWebImageOptionSetImageWithFadeAnimation];
        
    };
    
    requestFailureBlock fblock = ^(NSError *error){
        NSLog(@"%@",error);
    };
    
    [[YAHTTPManager sharedManager] requestWithMethod:GET WithPath:requestUrl WithParameters:nil WithSuccessBlock:sblock WithFailurBlock:fblock];

    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y +20;
    kLog(@"%f",offsetY);
    
    // 处理下拉
    if (offsetY < 0) {
        self.topViewHeightConstraint.constant = kTopImageHeight  + (- offsetY);
        
        if (offsetY < -80) {
            CGPoint point= scrollView.contentOffset;
            point.y = -100;
            scrollView.contentOffset = point;
        }
    }
    
    // 处理上拉
    if (offsetY >= 0) {
        self.topView.ya_y = - offsetY;
    }
}

@end

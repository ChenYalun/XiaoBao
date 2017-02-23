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
#import "YAExtraItem.h"
#import <UIImageView+YYWebImage.h>
#import "YALinkViewController.h"

// xib 中topView高度约束
#define kTopImageHeight 220
@interface YAContentViewController ()<WKNavigationDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeightConstraint;

/** webView */
@property (nonatomic,weak) WKWebView *webView;
/** 头部视图 */
@property (nonatomic,weak) IBOutlet UIView *topView;
/** 头部视图图片 */
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
/** 标题 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** 图片版权 */
@property (weak, nonatomic) IBOutlet UILabel *imageScourceLabel;
@property (weak, nonatomic) IBOutlet UIButton *zanButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

@end

@implementation YAContentViewController
#pragma mark - 懒加载




- (WKWebView *)webView {
    if (_webView == nil) {
        
        WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 44)];
        
        
        // 设置代理
        webView.navigationDelegate = self;
        webView.scrollView.delegate = self;
        
        // 自适应屏幕宽度js
        NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *contentController = webView.configuration.userContentController;
        
        // 添加自适应屏幕宽度js调用的方法
        [contentController addUserScript:wkUserScript];
        

        [self.view insertSubview:webView atIndex:0];
        _webView = webView;

    }
    return _webView;
}



- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    [self requestForContentData];
    [self requestForExtraData];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 请求额外信息
- (void)requestForExtraData {
    NSString *requestUrl = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/story-extra/%ld",self.story.ID];
    requestSuccessBlock sblock = ^(id responseObject){
        
        YAExtraItem *extra = [YAExtraItem extraItemWithKeyValues:responseObject];
        // 处理内容
        self.zanButton.titleLabel.text = extra.popularity;
        self.commentButton.titleLabel.text = extra.comments;
        
    };
    
    requestFailureBlock fblock = ^(NSError *error){
        NSLog(@"%@",error);
    };
    
    [[YAHTTPManager sharedManager] requestWithMethod:GET WithPath:requestUrl WithParameters:nil WithSuccessBlock:sblock WithFailurBlock:fblock];
    
    

}
#pragma mark - 请求内容数据
- (void)requestForContentData {
    
    NSString *requestUrl = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/news/%ld",self.story.ID];
    requestSuccessBlock sblock = ^(id responseObject){
    
        YAContentItem *content = [YAContentItem contentItemWithKeyValues:responseObject];



        // 处理内容
        NSString *htmlString = [NSString stringWithFormat:@"<html><head><link rel=\"stylesheet\" type=\"text/css\" href=%@ /></head><body>%@</body></html>", content.css.firstObject, content.body];
        [self.webView loadHTMLString:htmlString baseURL:nil];

        
        
        // 处理图片
        if (content.image) {
            self.webView.scrollView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
            [self.topImageView yy_setImageWithURL:[NSURL URLWithString:content.image] options:YYWebImageOptionSetImageWithFadeAnimation];
            
            // 标题
            self.titleLabel.text = content.title;
            
            // 版权
            self.imageScourceLabel.text = content.image_source;

        } else {
            self.topView.hidden = YES;
        }
        
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


#pragma mark - 按钮处理
// 返回
- (IBAction)goBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// 分享
- (IBAction)share:(UIButton *)sender {
    
}

// 赞
- (IBAction)zan:(UIButton *)sender {
    sender.selected = !sender.selected;

    
}

//下一条
- (IBAction)nextStory:(UIButton *)sender {
    
}

// 评论
- (IBAction)comment:(UIButton *)sender {


}


#pragma mark - 链接点击
// 1.在请求开始加载之前调用，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

    if ([navigationAction.request.URL.absoluteString isEqualToString:@"about:blank"]) {
        decisionHandler(WKNavigationActionPolicyAllow);
    } else {
        YALinkViewController *linkViewController = [[YALinkViewController alloc] init];
        linkViewController.request = navigationAction.request;
        [self.navigationController pushViewController:linkViewController animated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
    }

}
// 在收到响应开始加载后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{

    decisionHandler(WKNavigationResponsePolicyAllow);
}

// 2.页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {

}
// 3.当内容开始到达时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{

}
//// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{

    
    
    
}
//// 页面加载失败时调用
//- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{}
////收到服务器重定向请求后调用
//- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
//
//}




@end

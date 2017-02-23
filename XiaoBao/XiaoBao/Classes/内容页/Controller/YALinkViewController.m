//
//  YALinkViewController.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/22.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YALinkViewController.h"
#import <WebKit/WebKit.h>
#import "YANavigationView.h"
@interface YALinkViewController ()<WKNavigationDelegate>
/** webView */
@property (nonatomic,weak) WKWebView *webView;
/** 导航视图 */
@property (nonatomic,weak) YANavigationView *navigationView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *forwadrButton;
@end

@implementation YALinkViewController
#pragma mark - 懒加载

- (YANavigationView *)navigationView {
    if (_navigationView == nil) {
        YANavigationView *navigetionView = [YANavigationView navigationViewWithTitle:@"跳转中..."];
        [self.view addSubview:navigetionView];
        _navigationView = navigetionView;
    }
    return _navigationView;
}


- (WKWebView *)webView {
    if (_webView == nil) {
        
        WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 44 - 64)];
        
        // 设置代理
        webView.navigationDelegate = self;
        
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
    [self navigationView];
    [self.webView loadRequest:self.request];
    
    //[self navigationView];
    
 
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.navigationView.frame = CGRectMake(0, 0, kScreenWidth, 64);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 按钮事件处理
- (IBAction)popViewController:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)goBack:(UIButton *)sender {
    
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }
    //sender.enabled = self.webView.canGoBack;
        
}
- (IBAction)goForward:(UIButton *)sender {
    
    if (self.webView.canGoForward) {
        [self.webView goForward];
    }
    //sender.enabled = self.webView.canGoForward;
}

- (IBAction)share:(UIButton *)sender {
    
}
- (IBAction)reloadPage:(UIButton *)sender {
    [self.webView reload];
}
#pragma mark - webView代理
// 1.在请求开始加载之前调用，决定是否跳转 **频繁调用
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    [self.navigationView.activityIndicatorView startAnimating];
    self.navigationView.title = webView.title;
     decisionHandler(WKNavigationActionPolicyAllow);
//    if ([navigationAction.request.URL.absoluteString isEqualToString:@"about:blank"]) {
//        decisionHandler(WKNavigationActionPolicyAllow);
//    } else {
//        YALinkViewController *linkViewController = [[YALinkViewController alloc] init];
//        linkViewController.request = navigationAction.request;
//        [self.navigationController pushViewController:linkViewController animated:YES];
//        decisionHandler(WKNavigationActionPolicyAllow);
//    }
    
}
// 3.在收到响应开始加载后，决定是否跳转 **频繁调用
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
[self.navigationView.activityIndicatorView startAnimating];
    self.navigationView.title = webView.title;
    decisionHandler(WKNavigationResponsePolicyAllow);
}

// 2.页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self.navigationView.activityIndicatorView startAnimating];
    self.navigationView.title = webView.title;
    
}
// 4.当内容开始到达时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    [self.navigationView.activityIndicatorView stopAnimating];
    self.navigationView.title = webView.title;
    self.backButton.enabled = webView.canGoBack;
    self.forwadrButton.enabled = webView.canGoForward;
}
// 5.页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
self.navigationView.title = webView.title;
    [self.navigationView.activityIndicatorView stopAnimating];

}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    self.navigationView.title = webView.title;
    [self.navigationView.activityIndicatorView stopAnimating];
}
// 收到服务器重定向请求后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    self.navigationView.title = webView.title;
[self.navigationView.activityIndicatorView startAnimating];
}

@end

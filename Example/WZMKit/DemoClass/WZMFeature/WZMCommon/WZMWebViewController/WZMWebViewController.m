//
//  WZMWebViewController.m
//  LLCommonSDK
//
//  Created by WangZhaomeng on 2017/11/2.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "WZMWebViewController.h"
#import "WZMWebProgressLayer.h"
#import "WZMUserContentController.h"
#import "WKWebView+WZMWebViewController.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "WZMInline.h"
#import "NSString+wzmcate.h"
#import "WZMDefined.h"

@interface WZMWebViewController ()<WKNavigationDelegate,WKUIDelegate,WZMScriptMessageHandler>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSArray *scriptNames;
@property (nonatomic, strong) WZMWebProgressLayer *progressLayer;

@end

@implementation WZMWebViewController {
    NSString *_url;
    CGRect   _frame;
}

#pragma mark - init
- (instancetype)initWithUrl:(NSString *)url {
    self = [super init];
    if (self) {
        [self setConfig:WZMRectBottomArea() url:url];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame url:(NSString *)url {
    self = [super init];
    if (self) {
        [self setConfig:frame url:url];
    }
    return self;
}

- (id)initWithHtml:(NSString *)html {
    self = [super init];
    if (self) {
        [self setConfig:WZMRectBottomArea() url:[[NSBundle mainBundle] pathForResource:html ofType:@"html"]];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame html:(NSString *)html {
    self = [super init];
    if (self) {
        [self setConfig:frame url:[[NSBundle mainBundle] pathForResource:html ofType:@"html"]];
    }
    return self;
}

- (void)setConfig:(CGRect)frame url:(NSString *)url {
    if (CGRectIsNull(frame)) {
        _frame = WZMRectBottomArea();
    }
    else {
        _frame = frame;
    }
    _url = url;
    _scriptNames = @[@"universal"];
}

///导航返回相关
- (BOOL)ll_navigationShouldPop {
    if (self.webView.canGoBack) {
        [self.webView goBack];
        return NO;
    }
    return YES;
}

#pragma mark - life cyclic
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor wzm_getDynamicColorByLightColor:[UIColor whiteColor] darkColor:[UIColor blackColor]];
    [self.view addSubview:self.webView];
    [self loadUrl:_url];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.navigationController) {
        [self.navigationController.navigationBar.layer addSublayer:self.progressLayer];
    }
    else {
        [self.view.layer addSublayer:self.progressLayer];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.progressLayer removeFromSuperlayer];
}

#pragma mark - WZMScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSString *name = message.name;
    NSLog(@"==%@=%@",name,message.body);
}

#pragma mark - WKNavigationDelegate
// 请求开始前，会先调用此代理方法
//- (BOOL)webView:shouldStartLoadWithRequest:navigationType:
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

    NSURLRequest *request = navigationAction.request;
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated &&
        [request.URL.host.lowercaseString containsString:@"我的跨域标识符"]) {
        // 对于跨域，需要手动跳转
#if WZM_APP
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
#endif
        // 不允许web内跳转
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else {
        NSString *word = [request.URL.absoluteString wzm_getURLDecoded];
        if ([word hasPrefix:@"app"]) {
            NSString *script = [NSString stringWithFormat:@"alert('%@')",word];
            [self stringByEvaluatingJavaScriptFromString:script];
        }
        else {
            [self.progressLayer startLoad];
        }
        //允许web内跳转
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

// 在响应完成时，会回调此方法
// 如果设置为不允许响应，web内容就不会传过来
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}

// 开始导航跳转时会回调
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {

}

// 接收到重定向时会回调
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {

}

// 导航失败时会回调
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {

}

// 页面内容到达mainframe时回调
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {

}

// 导航完成时，会回调（也就是页面载入完成了）
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {

}

// 导航失败时会回调
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {

}

// 对于HTTPS的都会触发此代理，如果不要求验证，传默认就行
// 如果需要证书验证，与使用AFN进行HTTPS证书验证是一样的
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler {

    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
}

// 9.0才能使用，web内容处理中断时会触发
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {

}

#pragma mark - WKUIDelegate
//需要打开新界面时
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    //会拦截到window.open()事件.
    //只需要我们在在方法内进行处理
    if (navigationAction.targetFrame.isMainFrame == NO) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

- (void)webViewDidClose:(WKWebView *)webView {
    
}

// 在JS端调用alert函数时，会触发此代理方法。
// JS端调用alert时所传的数据可以通过message拿到
// 在原生得到结果后，需要回调JS，是通过completionHandler回调
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"alert" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

// JS端调用confirm函数时，会触发此方法
// 通过message可以拿到JS端所传的数据
// 在iOS端显示原生alert得到YES/NO后
// 通过completionHandler回调给JS端
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"confirm" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}

// JS端调用prompt函数时，会触发此方法
// 要求输入一段文本
// 在原生输入得到文本内容后，通过completionHandler回调给JS
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"textinput" message:prompt preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor blackColor];
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

#pragma mark - public method
/** 以文件的方式注入JS */
- (void)registerJSWithResource:(NSString *)resource ofType:(NSString *)type {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *filePath = [bundle pathForResource:resource ofType:type];
    NSString *script = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [self.webView evaluateJavaScript:script completionHandler:nil];
}

/** 以字符串的方式注入JS */
- (void)stringByEvaluatingJavaScriptFromString:(NSString *)script {
    [self.webView evaluateJavaScript:script completionHandler:nil];
}

- (void)loadUrl:(NSString *)url {
    [self.webView wzm_loadUrl:url];
}

- (void)reload {
    [self.webView reload];
}

- (void)webGoback {
    if (self.webView.canGoBack) {
        [self.webView goBack];
        return;
    }
    if (self.navigationController.topViewController == self) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - pravite method
// 添加KVO监听
- (void)addObserver {
    [self.webView addObserver:self
                   forKeyPath:@"loading"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    
    [self.webView addObserver:self
                   forKeyPath:@"title"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    
    [self.webView addObserver:self
                   forKeyPath:@"estimatedProgress"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
}

// 移除KVO监听
- (void)removeObserver {
    [self.webView removeObserver:self forKeyPath:@"loading"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

// KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"loading"]) {
        NSLog(@"loading...");
    }
    else if ([keyPath isEqualToString:@"title"]) {
        self.title = self.webView.title;
    }
    else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        NSLog(@"progress: %f", self.webView.estimatedProgress);
    }
    // 加载完成
    if (self.webView.loading == NO) {
        /*
         //手动调用JS代码
         [self stringByEvaluatingJavaScriptFromString:@""];
         */
        [self.progressLayer finishedLoad];
    }
}

#pragma mark - lazy load
- (WKWebView *)webView {
    if (_webView == nil) {
        // js配置
        WZMUserContentController *userContentController = [[WZMUserContentController alloc] init];
        userContentController.delegate = self;
        [userContentController addScriptMessageHandler:_scriptNames];
        
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.preferences = [[WKPreferences alloc] init];
        config.preferences.javaScriptEnabled = YES;
        config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        config.userContentController = userContentController;
        
        _webView = [[WKWebView alloc]initWithFrame:_frame configuration:config];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
        if (@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
#else
        self.automaticallyAdjustsScrollViewInsets = NO;
#endif
        [self addObserver];
    }
    return _webView;
}

- (WZMWebProgressLayer *)progressLayer {
    if (_progressLayer == nil) {
        _progressLayer = [[WZMWebProgressLayer alloc] init];
        if (self.navigationController) {
            _progressLayer.frame = CGRectMake(0, WZM_NAVBAR_HEIGHT-WZM_STATUS_HEIGHT-2, WZM_SCREEN_WIDTH, 2);
        }
        else {
            _progressLayer.frame = CGRectMake(0, 0, WZM_SCREEN_WIDTH, 2);
        }
    }
    return _progressLayer;
}

- (void)dealloc {
    NSLog(@"%@释放了",NSStringFromClass(self.class));
    if (_webView) {
        [self removeObserver];
        [(WZMUserContentController *)self.webView.configuration.userContentController removeScriptMessageHandler:_scriptNames];
    }
}

@end

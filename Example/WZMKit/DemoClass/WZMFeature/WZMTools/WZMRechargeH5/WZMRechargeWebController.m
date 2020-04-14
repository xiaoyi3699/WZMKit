//
//  WZMRechargeWebController.m
//  KPoint
//
//  Created by WangZhaomeng on 2019/10/29.
//  Copyright © 2019 XiaoSi. All rights reserved.
//

#import "WZMRechargeWebController.h"
#import "WZMRechargeModel.h"
#import "WZMDefined.h"
#import <WebKit/WebKit.h>

#define myUrlSchemes @"wzmkit"
#define paidNotificationKey @"paidNotification"
@interface WZMRechargeWebController ()<WKNavigationDelegate,WKUIDelegate>

@property (nonatomic, strong) NSString *urlPaid;
@property (nonatomic, strong) NSString *htmlString;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, assign, getter=isAllowLoad) BOOL allowLoad;

@end

@implementation WZMRechargeWebController

- (instancetype)initWithUrl:(NSString *)url {
    self = [super init];
    if (self) {
        self.allowLoad = YES;
        self.urlPaid = url;
        self.title = @"";
    }
    return self;
}

- (instancetype)initWithHtmlString:(NSString *)string {
    self = [super init];
    if (self) {
        self.allowLoad = YES;
        self.htmlString = string;
        self.title = @"";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.hidden = YES;
    [self.view addSubview:self.webView];
    if (self.urlPaid.length) {
        [self loadUrl:self.urlPaid];
    }
    else {
        [self loadHTMLString:self.htmlString];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payFinfsh:) name:paidNotificationKey object:nil];
}

//支付完成
- (void)payFinfsh:(NSNotification *)n {
    BOOL success = [n.object boolValue];
    if (success) {
        //验证支付结果
        [WZMViewHandle wzm_showProgressMessage:@"充值中..."];
        [self checkOrder:^(BOOL success) {
            [WZMViewHandle wzm_dismiss];
            if (success) {
                [self showAlertViewWithMessage:@"支付成功"];
                //刷新用户信息
                [self.navigationController popViewControllerAnimated:NO];
            }
            else {
                [self showAlertViewWithMessage:@"支付失败"];
                [self.navigationController popViewControllerAnimated:NO];
            }
        } count:0];
    }
    else {
        [self showAlertViewWithMessage:@"支付失败"];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

//检查订单
- (void)checkOrder:(void(^)(BOOL success))completion count:(NSInteger)count {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[WZMNetWorking shareNetWorking] GET:@"" parameters:nil callBack:^(id responseObject, NSError *error) {
            if (error) {
                //失败,由于支付延迟,尝试继续检查订单
                if (count < 3) {
                    [self checkOrder:completion count:(count+1)];
                }
                else {
                    if (completion) completion(NO);
                }
            }
            else {
                //成功
                if (completion) completion(YES);
            }
        }];
    });
}

- (void)showAlertViewWithMessage:(NSString *)message {
#if WZM_APP
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
#endif
}

//处理Appdelegate内handleUrl
+ (void)openUrl:(NSURL *)url {
    WZMRechargeModel *model = [WZMRechargeModel shareModel];
    if ([url.absoluteString containsString:model.wxAuthDomain]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:paidNotificationKey object:@(YES)];
    }
    if ([url.absoluteString containsString:model.alUrlKey]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:paidNotificationKey object:@(YES)];
    }
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
        WZMRechargeModel *model = [WZMRechargeModel shareModel];
        //在发送请求之前，决定是否跳转
        NSString *url = navigationAction.request.URL.absoluteString;
        if ([url containsString:model.wxSchemes]) {
            self.allowLoad = NO;
            NSURL *openUrl = navigationAction.request.URL;
#if WZM_APP
            [[UIApplication sharedApplication] openURL:openUrl];
#endif
            decisionHandler(WKNavigationActionPolicyCancel);
        }
        else if ([url containsString:model.wxH5Identifier] && self.isAllowLoad) {
            self.allowLoad = NO;
            NSRange range = [url rangeOfString:model.wxRedirect];
            if (range.location != NSNotFound) {
                url = [url substringToIndex:range.location];
            }
            NSURLRequest *request = navigationAction.request;
            NSMutableURLRequest *newRequest = [[NSMutableURLRequest alloc] init];
            newRequest.allHTTPHeaderFields = request.allHTTPHeaderFields;
            [newRequest setValue:model.wxAuthDomain forHTTPHeaderField: @"Referer"];
            newRequest.URL = request.URL;
            [webView loadRequest:newRequest];
            decisionHandler(WKNavigationActionPolicyCancel);
        }
        else if ([url containsString:model.alSchemes]) {
            //先解码
            NSString *encodeUrl = [url stringByRemovingPercentEncoding];
            //取出域名后面的参数  用“？”分割的
            NSArray *urlParArry = [encodeUrl componentsSeparatedByString:@"?"];
            //工具类将json字符串转成字典(自行替换)
            NSMutableDictionary *dic = [[NSString wzm_getObjByJson:urlParArry.lastObject] mutableCopy];
            [dic setObject:myUrlSchemes forKey:model.alSchemesKey];
            //将替换参数之后的dic转为json字符串
            NSString *overJsonStr = [NSString wzm_getJsonByObj:dic];
            //拼接前面的域名
            NSString *overUrlStr = [NSString stringWithFormat:@"%@?%@",urlParArry.firstObject,overJsonStr];
            //编码一下
            NSString *canUseEncodeUrl = [overUrlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            NSURL *openUrl = [NSURL URLWithString:canUseEncodeUrl];
#if WZM_APP
            [[UIApplication sharedApplication] openURL:openUrl];
#endif
            decisionHandler(WKNavigationActionPolicyCancel);
        }
        else {
            decisionHandler(WKNavigationActionPolicyAllow);
        }
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
    NSMutableURLRequest *request;
    if ([[NSFileManager defaultManager] fileExistsAtPath:url]) {
        request = [NSMutableURLRequest requestWithURL:[NSURL fileURLWithPath:url]];
    }
    else {
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    }
    if (self.type == WZMRechargeTypeWX) {
        //设置授权域名
        [request setValue:[WZMRechargeModel shareModel].wxAuthDomain forHTTPHeaderField:@"Referer"];
    }
    [self.webView loadRequest:request];
}

- (void)loadHTMLString:(NSString *)str {
    [self.webView loadHTMLString:str baseURL:nil];
}

#pragma mark - lazy load
- (WKWebView *)webView {
    if (_webView == nil) {
        _webView = [[WKWebView alloc]initWithFrame:WZMRectBottomArea()];
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
    }
    return _webView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

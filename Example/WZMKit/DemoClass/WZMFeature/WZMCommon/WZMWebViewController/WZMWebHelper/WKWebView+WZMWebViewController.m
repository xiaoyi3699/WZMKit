//
//  WKWebView+WZMWebViewController.m
//  LLCommonStatic
//
//  Created by WangZhaomeng on 2018/10/17.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import "WKWebView+WZMWebViewController.h"
#import "WZMWebHelper.h"

@implementation WKWebView (WZMWebViewController)

//加载(拼接请求头)
- (void)wzm_loadUrl:(NSString *)url {
    [self loadRequest:[WZMWebHelper handlingUrl:url]];
}

//WKScriptMessageHandler
- (void)wzm_userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSString *name = message.name;
    NSLog(@"==%@=%@",name,message.body);
}

//拦截url
- (WKNavigationActionPolicy)wzm_decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction startHandler:(void (^)())startHandler {
    NSURLRequest *request = navigationAction.request;
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated &&
        [request.URL.host.lowercaseString containsString:@"我的跨域标识符"]) {
        // 对于跨域，需要手动跳转
#if WZM_APP
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
#endif
        // 不允许web内跳转
        return WKNavigationActionPolicyCancel;
    }
    else {
        NSString *word = [request.URL.absoluteString wzm_getURLDecoded];
        if ([word hasPrefix:@"app"]) {
            NSString *script = [NSString stringWithFormat:@"alert('%@')",word];
            [self wzm_evaluateJavaScriptWithString:script];
        }
        else {
            if (startHandler) startHandler();
        }
        //允许web内跳转
        return WKNavigationActionPolicyAllow;
    }
}

//以字符串的方式注入JS
- (void)wzm_evaluateJavaScriptWithString:(NSString *)string {
    [self evaluateJavaScript:string completionHandler:nil];
}

//以文件的方式注入JS
- (void)wzm_evaluateJavaScriptWithResource:(NSString *)resource ofType:(NSString *)type {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *filePath = [bundle pathForResource:resource ofType:type];
    NSString *script = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [self evaluateJavaScript:script completionHandler:nil];
}

@end

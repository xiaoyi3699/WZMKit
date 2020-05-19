//
//  WKWebView+WZMWebViewController.h
//  LLCommonStatic
//
//  Created by WangZhaomeng on 2018/10/17.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface WKWebView (WZMWebViewController)

///加载(拼接请求头)
- (void)wzm_loadUrl:(NSString *)url;
///WKScriptMessageHandler
- (void)wzm_userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;
///拦截url
- (WKNavigationActionPolicy)wzm_decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction startHandler:(void(^)(void))startHandler;
///以字符串的方式注入JS
- (void)wzm_evaluateJavaScriptWithString:(NSString *)string;
///以文件的方式注入JS
- (void)wzm_evaluateJavaScriptWithResource:(NSString *)resource ofType:(NSString *)type;

@end

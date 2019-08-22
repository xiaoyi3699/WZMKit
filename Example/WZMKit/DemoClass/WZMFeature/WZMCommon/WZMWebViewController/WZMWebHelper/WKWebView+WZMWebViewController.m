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

- (void)webVC_loadUrl:(NSString *)url {
    [self loadRequest:[WZMWebHelper handlingUrl:url]];
}

@end

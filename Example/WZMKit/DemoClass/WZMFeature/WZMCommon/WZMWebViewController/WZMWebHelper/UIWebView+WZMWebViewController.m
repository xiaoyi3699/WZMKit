//
//  UIWebView+WZMWebViewController.m
//  LLCommonStatic
//
//  Created by WangZhaomeng on 2018/10/17.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import "UIWebView+WZMWebViewController.h"
#import "WZMWebHelper.h"

@implementation UIWebView (WZMWebViewController)

- (void)webVC_loadUrl:(NSString *)url {
    [self loadRequest:[WZMWebHelper handlingUrl:url]];
}

@end

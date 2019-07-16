//
//  UIWebView+wzmcate.m
//  WZMFoundation
//
//  Created by WangZhaomeng on 2017/9/19.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "UIWebView+wzmcate.h"
#import "NSString+wzmcate.h"

@implementation UIWebView (wzmcate)

- (void)wzm_loadUrl:(NSString *)url {
    if (url.length == 0) return;
    NSString *codeUrl = [url wzm_getURLEncoded];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:codeUrl]];
    [self loadRequest:request];
}

- (void)wzm_loadURL:(NSURL *)URL {
    if (URL == nil) return;
    [self loadRequest:[NSURLRequest requestWithURL:URL]];
}

@end

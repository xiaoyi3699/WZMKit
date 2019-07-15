//
//  UIWebView+LLAddPart.m
//  LLFoundation
//
//  Created by WangZhaomeng on 2017/9/19.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "UIWebView+LLAddPart.h"
#import "NSString+LLAddPart.h"

@implementation UIWebView (LLAddPart)

- (void)ll_loadUrl:(NSString *)url {
    if (url.length == 0) return;
    NSString *codeUrl = [url ll_getURLEncoded];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:codeUrl]];
    [self loadRequest:request];
}

- (void)ll_loadURL:(NSURL *)URL {
    if (URL == nil) return;
    [self loadRequest:[NSURLRequest requestWithURL:URL]];
}

@end

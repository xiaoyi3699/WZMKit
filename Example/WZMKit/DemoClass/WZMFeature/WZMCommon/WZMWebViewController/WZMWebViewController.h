//
//  WZMWebViewController.h
//  LLCommonSDK
//
//  Created by WangZhaomeng on 2017/11/2.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "WZMBaseViewController.h"

@interface WZMWebViewController : WZMBaseViewController

///加载网页
- (instancetype)initWithUrl:(NSString *)url;
- (instancetype)initWithFrame:(CGRect)frame url:(NSString *)url;

///加载本地html
- (id)initWithHtml:(NSString *)html;
- (id)initWithFrame:(CGRect)frame html:(NSString *)html;

- (void)reload;
- (void)webGoback;
- (void)loadUrl:(NSString *)url;

///注入JS
- (void)evaluateJavaScriptWithString:(NSString *)string;
- (void)evaluateJavaScriptWithResource:(NSString *)resource ofType:(NSString *)type;

@end

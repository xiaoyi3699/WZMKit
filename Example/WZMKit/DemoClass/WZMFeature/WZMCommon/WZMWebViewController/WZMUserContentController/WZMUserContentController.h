//
//  WZMUserContentController.h
//  LLCommonStatic
//
//  Created by WangZhaomeng on 2019/5/27.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import <WebKit/WebKit.h>
@protocol WZMScriptMessageHandler;

@interface WZMUserContentController : WKUserContentController

@property (nonatomic, weak) id<WZMScriptMessageHandler> delegate;

- (void)addScriptMessageHandler:(NSArray *)scriptNames;
- (void)removeScriptMessageHandler:(NSArray *)scriptNames;

@end

@protocol WZMScriptMessageHandler <NSObject>

@optional
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;

@end

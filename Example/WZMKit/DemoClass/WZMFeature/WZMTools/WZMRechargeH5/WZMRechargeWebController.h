//
//  WZMRechargeWebController.h
//  KPoint
//
//  Created by WangZhaomeng on 2019/10/29.
//  Copyright © 2019 XiaoSi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WZMRechargeType) {
    WZMRechargeTypeWX = 0,
    WZMRechargeTypeZFB,
};
@interface WZMRechargeWebController : UIViewController

@property (nonatomic, strong) NSString *orderNum;
@property (nonatomic, assign) WZMRechargeType type;

- (instancetype)initWithUrl:(NSString *)url;
- (instancetype)initWithHtmlString:(NSString *)string;

///处理Appdelegate内handleUrl
+ (void)openUrl:(NSURL *)url;

@end

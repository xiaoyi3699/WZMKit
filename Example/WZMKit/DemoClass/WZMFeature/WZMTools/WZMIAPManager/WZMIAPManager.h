//
//  WZMIAPManager.h
//  SQB_ScreenShot
//
//  Created by WangZhaomeng on 2019/3/1.
//  Copyright © 2019 AiZhe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZMIAPManager : NSObject

///支付结果
typedef enum : NSInteger {
    WZMIAPResultStatusSuccess           = 0,     //成功
    WZMIAPResultStatusErrorJson         = 21000, //AppStore无法读取提供的JSON数据
    WZMIAPResultStatusErrorReceipt1     = 21002, //收据数据不符合格式
    WZMIAPResultStatusErrorReceipt2     = 21003, //收据无法被验证
    WZMIAPResultStatusErrorKey          = 21004, //提供的共享密钥和账户的共享密钥不一致
    WZMIAPResultStatusErrorService      = 21005, //收据服务器当前不可用
    WZMIAPResultStatusErrorExpires      = 21006, //收据是有效的,但订阅服务已经过期
    WZMIAPResultStatusErrorEnvironment1 = 21007, //收据信息是测试用,但却被发送到产品环境中验证
    WZMIAPResultStatusErrorEnvironment2 = 21008, //收据信息是产品环境中使用,但却被发送到测试环境中验证
} WZMIAPResultStatus;

///支付类型
typedef enum : NSInteger {
    WZMIAPTypeNormal = 0,   //非订阅
    WZMIAPTypeSubscription, //订阅
} WZMIAPType;

///IAP类型
@property (nonatomic, assign) WZMIAPType type;
///共享秘钥,订阅模式需要
@property (nonatomic, strong) NSString *shareKey;

/**
 是否在APP内部验证支付结果
 
 为了方便测试,默认YES,即在APP内部向苹果服务器验证支付结果
 线上环境建议放在服务器验证支付结果,修改默认值为NO,并向服务端发送验证数据
 */
@property (nonatomic, assign, getter=isVerifyInApp) BOOL verifyInApp;

+ (instancetype)shareManager;

/**
 根据商品ID请求支付信息
 
 @param orderId   订单号 - 由服务器创建 <统计使用>
 @param productId 商品号 - 苹果后台设置 <充值标识>
 */
- (void)requestProductWithOrderId:(NSString *)orderId productId:(NSString *)productId;

@end

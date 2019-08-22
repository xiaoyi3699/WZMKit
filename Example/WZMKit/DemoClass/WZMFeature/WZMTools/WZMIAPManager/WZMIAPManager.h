//
//  WZMIAPManager.h
//  SQB_ScreenShot
//
//  Created by WangZhaomeng on 2019/3/1.
//  Copyright © 2019 AiZhe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZMIAPManager : NSObject

+ (instancetype)shareManager;

/**
 根据商品ID请求支付信息
 
 @param orderId   订单号 - 由服务器返回 <暂无用, 可传项目标识, 如:testApp>
 @param productId 商品号 - 苹果后台设置 <充值标识, 唯一>----------------
 */
- (void)requestProductWithOrderId:(NSString *)orderId productId:(NSString *)productId;

@end

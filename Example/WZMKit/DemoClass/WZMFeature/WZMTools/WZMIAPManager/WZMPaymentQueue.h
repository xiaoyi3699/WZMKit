//
//  WZMPaymentQueue.h
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2020/4/23.
//  Copyright © 2020 wangzhaomeng. All rights reserved.
//

#import <StoreKit/StoreKit.h>
@protocol WZMPaymentTransactionObserver;

NS_ASSUME_NONNULL_BEGIN

@interface WZMPaymentQueue : SKPaymentQueue

- (instancetype)initWithObserver:(id<WZMPaymentTransactionObserver>)observer;

@end

@protocol WZMPaymentTransactionObserver <NSObject>

@optional
- (void)wzm_paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions;
- (void)wzm_paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue;
- (void)wzm_paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END

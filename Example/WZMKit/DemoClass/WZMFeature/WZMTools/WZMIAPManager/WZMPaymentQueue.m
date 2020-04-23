//
//  WZMPaymentQueue.m
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2020/4/23.
//  Copyright © 2020 wangzhaomeng. All rights reserved.
//

#import "WZMPaymentQueue.h"

@interface WZMPaymentQueue ()<SKPaymentTransactionObserver>

@property (nonatomic, weak) id<WZMPaymentTransactionObserver> observer;

@end

@implementation WZMPaymentQueue

- (instancetype)initWithObserver:(id<WZMPaymentTransactionObserver>)observer {
    self = [super init];
    if (self) {
        self.observer = observer;
        [self addTransactionObserver:self];
    }
    return self;
}

#pragma mark -- 监听AppStore支付状态
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    if ([self.observer respondsToSelector:@selector(wzm_paymentQueue:updatedTransactions:)]) {
        [self.observer wzm_paymentQueue:queue updatedTransactions:transactions];
    }
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    if ([self.observer respondsToSelector:@selector(wzm_paymentQueueRestoreCompletedTransactionsFinished:)]) {
        [self.observer wzm_paymentQueueRestoreCompletedTransactionsFinished:queue];
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    if ([self.observer respondsToSelector:@selector(wzm_paymentQueue:restoreCompletedTransactionsFailedWithError:)]) {
        [self.observer wzm_paymentQueue:queue restoreCompletedTransactionsFailedWithError:error];
    }
}

- (void)dealloc {
    [self removeTransactionObserver:self];
    NSLog(@"%@释放了",NSStringFromClass([self class]));
}

@end

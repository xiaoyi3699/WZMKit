//
//  SecondViewController.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/17.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "SecondViewController.h"
#import <StoreKit/StoreKit.h>
//http://www.vasueyun.cn/resource/wzm_snow.mp3
//http://www.vasueyun.cn/resource/wzm_qnyh.mp4

@interface SecondViewController ()<SKProductsRequestDelegate,SKPaymentTransactionObserver>

@end

@implementation SecondViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"第二页";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSArray *product = [[NSArray alloc] initWithObjects:@"wzm.kit.xhxm",nil];
    NSSet *nsset = [NSSet setWithArray:product];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate = self;
    [request start];
}

#pragma mark -- SKProductsRequestDelegate
//收到产品返回信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    NSArray *product = response.products;
    if([product count] == 0){
        NSLog(@"获取商品信息失败，请检查网络后重试");
        return;
    }
    SKProduct *p = product.firstObject;
    SKMutablePayment *payment = [[SKMutablePayment alloc] init];
    payment.productIdentifier = p.productIdentifier;
    payment.quantity = 1;
    //payment.applicationUsername = self.orderId;
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    WZMLog(@"------------------错误-----------------:%@", error);
}

- (void)requestDidFinish:(SKRequest *)request {
    WZMLog(@"------------反馈信息结束-----------------%@",request);
}

#pragma mark -- 监听AppStore支付状态
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    WZMLog(@"监听AppStore支付状态");
    dispatch_async(dispatch_get_main_queue(), ^{
        for(SKPaymentTransaction *tran in transactions) {
            if (tran.transactionState == SKPaymentTransactionStatePurchased) {
                WZMLog(@"SKPaymentTransactionStatePurchased");
            }
            else if (tran.transactionState == SKPaymentTransactionStateRestored) {
                WZMLog(@"SKPaymentTransactionStateRestored");
            }
            else if (tran.transactionState == SKPaymentTransactionStateFailed) {
                WZMLog(@"SKPaymentTransactionStateFailed");
            }
        }
    });
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    //恢复购买完成
    WZMLog(@"监听恢复购买完成");
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    //恢复购买失败
    WZMLog(@"监听恢复购买失败");
}

@end

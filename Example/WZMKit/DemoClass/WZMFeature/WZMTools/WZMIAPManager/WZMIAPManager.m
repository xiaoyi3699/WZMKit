//
//  WZMIAPManager.m
//  SQB_ScreenShot
//
//  Created by WangZhaomeng on 2019/3/1.
//  Copyright © 2019 AiZhe. All rights reserved.
//

#import "WZMIAPManager.h"
#import <StoreKit/StoreKit.h>
#import "WZMDeviceUtil.h"
#import "WZMViewHandle.h"

@interface WZMIAPManager ()<SKProductsRequestDelegate,SKPaymentTransactionObserver,UIAlertViewDelegate>

//是否正在支付
@property (nonatomic, assign, getter=isPaying) BOOL paying;
//监听支付
@property (nonatomic, assign, getter=isAddObserver) BOOL addObserver;
//订单验证失败次数
@property (nonatomic, assign) NSInteger failedCount;
//订单号
@property (nonatomic, copy) NSString *orderId;

@end

static NSString *kSaveReceiptData = @"kSaveReceiptData";
@implementation WZMIAPManager

+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    static WZMIAPManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[WZMIAPManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.paying = NO;
        self.addObserver = NO;
        self.failedCount = 0;
    }
    return self;
}

- (void)checkAppleOrder:(NSString *)msg {
    NSDictionary *orderInfo = [self getReceiptData];
    if (orderInfo) {
        self.paying = YES;
        NSString *orderId = orderInfo[@"orderId"];
        NSString *receipt = orderInfo[@"receipt"];
        [self verifyPurchaseForServiceWithOrderId:orderId receipt:receipt];
        if (msg) {
            [self showLoadingMessage:msg];
        }
    }
}

//检查是否有未处理订单
- (BOOL)checkLocaltionOrder {
    return ([self getReceiptData] != nil);
}

/** 检测权限 添加支付监测 开始支付流程*/
- (void)requestProductWithOrderId:(NSString *)orderId productId:(NSString *)productId {
    if (self.isPaying) return;
    if ([self checkLocaltionOrder]) {
        //本地有未处理订单
        [self checkAppleOrder:@"上一笔订单未处理完成，正在重新验证..."];
        return;
    }
    if (orderId == nil || productId == nil) {
        [self showInfoMessage:@"订单号/商品号有误"];
        return;
    }
    if ([WZMDeviceUtil isPrisonBreakEquipment]) {
        [self showInfoMessage:@"越狱手机不支持内购"];
        return;
    }
    if([SKPaymentQueue canMakePayments]){
        [self removeAllUncompleteTransactionsBeforeNewPurchase];
        [self addObserver];
        self.orderId = orderId;
        [self requestProductData:productId];
    }
    else {
        [self showInfoMessage:@"请打开应用内支付功能"];
    }
}

/** 去Apple IAP Service 根据商品ID请求商品信息*/
- (void)requestProductData:(NSString *)type {
    self.paying = YES;
    NSArray *product = [[NSArray alloc] initWithObjects:type,nil];
    NSSet *nsset = [NSSet setWithArray:product];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate = self;
    [request start];
    [self showLoadingMessage:@"支付请求已发起，请耐心等待~"];
}

#pragma mark -- SKProductsRequestDelegate
//收到产品返回信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    NSArray *product = response.products;
    if([product count] == 0){
        self.paying = NO;
        [self showInfoMessage:@"无法获取商品信息，请重新尝试购买"];
        return;
    }
    SKProduct *p = product.firstObject;
    SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:p];
    payment.quantity = 1;
    //payment.applicationUsername = self.orderId;
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"------------------错误-----------------:%@", error);
    self.paying = NO;
    [self showInfoMessage:@"从Apple获取商品信息失败"];
}

- (void)requestDidFinish:(SKRequest *)request{
    NSLog(@"------------反馈信息结束-----------------%@",request);
}

#pragma mark -- 监听AppStore支付状态
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transaction {
    NSLog(@"监听AppStore支付状态");
    dispatch_async(dispatch_get_main_queue(), ^{
        for(SKPaymentTransaction *tran in transaction){
            switch (tran.transactionState) {
                case SKPaymentTransactionStatePurchased:{
                    // 订阅特殊处理
                    if (tran.originalTransaction) {
                        // 如果是自动续费的订单,originalTransaction会有内容
                        NSLog(@"自动续费的订单,originalTransaction = %@",tran.originalTransaction);
                    }
                    else {
                        // 普通购买，以及第一次购买自动订阅
                        NSLog(@"普通购买，以及第一次购买自动订阅");
                    }
                    //服务器验证凭证
                    [self verifyPurchaseWithPaymentTransaction];
                    [self finishTransaction:tran];
                }
                    break;
                case SKPaymentTransactionStateRestored:{
                    self.paying = NO;
                    [self showInfoMessage:@"已经购买过商品"];
                    [self finishTransaction:tran];
                }
                    break;
                case SKPaymentTransactionStateFailed:{
                    self.paying = NO;
                    [self showInfoMessage:@"交易失败"];
                    [self finishTransaction:tran];
                }
                    break;
                default:
                    break;
            }
        }
    });
}

//结束上次未完成的交易
- (void)removeAllUncompleteTransactionsBeforeNewPurchase{
    NSArray* transactions = [SKPaymentQueue defaultQueue].transactions;
    if (transactions.count >= 1) {
        for (SKPaymentTransaction* transaction in transactions) {
            if (transaction.transactionState == SKPaymentTransactionStatePurchased ||
                transaction.transactionState == SKPaymentTransactionStateRestored) {
                [self finishTransaction:transaction];
            }
        }
    }
    else {
        NSLog(@"没有历史未消耗订单");
    }
}

#pragma mark - 订单验证
/**验证购买，避免越狱软件模拟苹果请求达到非法购买问题*/
-(void)verifyPurchaseWithPaymentTransaction {
    //从沙盒中获取交易凭证并且拼接成请求体数据
    NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
    NSString *receiptString = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    [self saveReceiptData:@{@"receipt":[NSString stringWithFormat:@"%@",receiptString],
                            @"orderId":[NSString stringWithFormat:@"%@",self.orderId]}];
    [self verifyPurchaseForServiceWithOrderId:self.orderId
                                      receipt:receiptString];
}

- (void)verifyPurchaseForServiceWithOrderId:(NSString *)orderId
                                    receipt:(NSString *)receiptString {
    if (orderId == nil || receiptString == nil) {
        self.paying = NO;
        [self showInfoMessage:@"订单号/凭证无效"];
        return;
    }
    /*
    //向服务器验证支付结果
    //交易成功
    [WZMViewHandle wzm_dismiss];
    self.isPaying = NO;
    [self removeLocReceiptData];
    //交易失败
     self.isPaying = NO;
    [self verifyPurchaseFail];
     */
}

#pragma mark - private
- (void)finishTransaction:(SKPaymentTransaction *)tran {
    [[SKPaymentQueue defaultQueue] finishTransaction:tran];
    [self removeObserver];
}

- (void)verifyPurchaseFail {
    [self showVerifyPurchaseFail];
}

- (void)addObserver {
    if (self.isAddObserver == NO) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
}

- (void)removeObserver {
    if (self.isAddObserver) {
        [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    }
}

//本地保存支付凭证
- (void)saveReceiptData:(NSDictionary *)receiptData {
    [[NSUserDefaults standardUserDefaults] setValue:receiptData forKey:kSaveReceiptData];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (NSDictionary *)getReceiptData {
    return [[NSUserDefaults standardUserDefaults] valueForKey:kSaveReceiptData];
}

- (void)removeLocReceiptData {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSaveReceiptData];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 弹框相关
- (void)showLoadingMessage:(NSString *)msg {
    [WZMViewHandle wzm_showProgressMessage:msg];
}

- (void)showInfoMessage:(NSString *)msg {
    [WZMViewHandle wzm_dismiss];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:msg
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)showVerifyPurchaseFail {
    [WZMViewHandle wzm_dismiss];
    self.failedCount ++;
    if (self.failedCount < 3) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"服务器验证"
                                                            message:@"请检查网络环境后重试，取消后下次点击充值时将自动验证！"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"再次验证", nil];
        [alertView show];
    }
    else {
        NSString *msg = [NSString stringWithFormat:@"该订单已连续%ld次验证失败，是否放弃该订单？",(long)self.failedCount];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"警告"
                                                            message:msg
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"放弃", nil];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        if (self.failedCount < 3) {
            [self checkAppleOrder:@"订单验证中..."];
        }
        else {
            self.failedCount = 0;
            [self removeLocReceiptData];
        }
    }
}

@end

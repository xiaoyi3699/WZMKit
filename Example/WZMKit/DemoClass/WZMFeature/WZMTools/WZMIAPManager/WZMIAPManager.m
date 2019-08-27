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
#import "WZMLogPrinter.h"
#import "WZMNetWorking.h"
#import "WZMJSONParse.h"

#if DEBUG
#define WZM_IAP_VERIFY @"https://sandbox.itunes.apple.com/verifyReceipt"
#else
#define WZM_IAP_VERIFY @"https://buy.itunes.apple.com/verifyReceipt"
#endif
@interface WZMIAPManager ()<SKProductsRequestDelegate,SKPaymentTransactionObserver,UIAlertViewDelegate>

//是否正在支付
@property (nonatomic, assign, getter=isPaying) BOOL paying;
//监听支付
@property (nonatomic, assign, getter=isAddObserver) BOOL addObserver;
//订单验证失败次数
@property (nonatomic, assign) NSInteger failedCount;
//订单号
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *receipt;
//是否是用户手动验证的订单
@property (nonatomic, assign) BOOL manualVerify;

@end

static NSString *kSaveReceiptData = @"kSaveReceiptData";
@implementation WZMIAPManager

+ (instancetype)manager {
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
        self.verifyInApp = YES;
        self.manualVerify = NO;
        self.failedCount = 0;
        self.shareKey = @"123456789";
        self.type = WZMIAPTypeNormal;
    }
    return self;
}

- (void)checkAppleOrder:(NSString *)msg {
    NSDictionary *orderInfo = [self getReceiptData];
    if (orderInfo) {
        self.paying = YES;
        self.manualVerify = YES;
        self.orderId = orderInfo[@"orderId"];
        self.receipt = orderInfo[@"receipt"];
        [self verifyPurchaseForService];
        if (msg) {
            [self showLoadingMessage:msg];
        }
    }
}

//检查是否有未处理订单
- (BOOL)checkLocaltionOrder {
    NSDictionary *dic = [self getReceiptData];
    return (dic != nil && dic[@"orderId"] != nil && dic[@"receipt"] != nil);
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
- (void)requestProductData:(NSString *)productId {
    self.paying = YES;
    self.manualVerify = YES;
    NSArray *product = [[NSArray alloc] initWithObjects:productId,nil];
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
        [self finishTransaction:@"无法获取商品信息，请重新尝试购买"];
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
    WZMLog(@"------------------错误-----------------:%@", error);
    [self finishTransaction:@"从Apple获取商品信息失败"];
}

- (void)requestDidFinish:(SKRequest *)request{
    WZMLog(@"------------反馈信息结束-----------------%@",request);
}

#pragma mark -- 监听AppStore支付状态
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transaction {
    WZMLog(@"监听AppStore支付状态");
    dispatch_async(dispatch_get_main_queue(), ^{
        for(SKPaymentTransaction *tran in transaction){
            switch (tran.transactionState) {
                case SKPaymentTransactionStatePurchased:{
                    //订阅特殊处理
                    if (tran.originalTransaction) {
                        //如果是自动续费的订单,originalTransaction会有内容
                        WZMLog(@"自动续费的订单,originalTransaction = %@",tran.originalTransaction);
                    }
                    else {
                        //普通购买，以及第一次购买自动订阅
                        WZMLog(@"普通购买，以及第一次购买自动订阅");
                    }
                    [self loadAppStoreReceipt];
                }
                    break;
                case SKPaymentTransactionStateRestored:{
                    [self finishTransaction:@"已经购买过商品"];
                }
                    break;
                case SKPaymentTransactionStateFailed:{
                    [self finishTransaction:@"已经购买过商品"];
                }
                    break;
                default:
                    break;
            }
        }
    });
}

#pragma mark - 订单验证
/**从沙盒中获取交易凭证*/
-(void)loadAppStoreReceipt {
    NSURL *url = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data) {
        self.receipt = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        if (self.orderId == nil) {
            //该订单是上次验证失败的订单
            NSDictionary *orderInfo = [self getReceiptData];
            self.orderId = orderInfo[@"orderId"];
            
            if (self.orderId == nil) {
                //用户卸载重装了应用,订单号遗漏,使用默认值
                self.orderId = @"wzm.iap";
            }
        }
        [self saveReceiptData];
        [self verifyPurchaseForService];
    }
    else {
        [self finishTransaction:@"支付失败"];
    }
}

/**验证收据真实性*/
- (void)verifyPurchaseForService {
    if (self.orderId == nil || self.receipt == nil) {
        self.paying = NO;
        return;
    }
    if (self.isVerifyInApp) {
        //直接向苹果服务器验证支付结果
        NSString *params = [NSString stringWithFormat:@"{\"receipt-data\":\"%@\"",self.receipt];
        if (self.type == WZMIAPTypeSubscription) {
            params = [NSString stringWithFormat:@"%@,\"password\":\"%@\"}",params,self.shareKey];
        }
        else {
            params = [NSString stringWithFormat:@"}"];
        }
        [[WZMNetWorking netWorking] POST:WZM_IAP_VERIFY parameters:params callBack:^(id responseObject, NSError *error) {
            if (error || responseObject == nil) {
                //订单验证失败
                [self verifyPurchaseFail];
            }
            else {
                WZMIAPResultStatus status = [WZMJSONParse getIntValueInDict:responseObject withKey:@"status"];
                if (status == WZMIAPResultStatusSuccess) {
                    //交易成功
                    [self finishTransaction:@"支付成功"];
                }
                else {
                    //交易失败
                    NSString *statusStr = [NSString stringWithFormat:@"支付失败(%@)",@(status)];
                    [self finishTransaction:statusStr];
                }
            }
        }];
    }
    else {
        //将params传给服务器,让服务器去验证支付结果
        
    }
}

#pragma mark - private
//AppStore标记交易完成,关闭交易
//调用场景:1、支付成功 2、订单失效,交易凭证错误或者其他非法因素引起的交易失败
- (void)finishTransaction:(NSString *)message {
    [WZMViewHandle wzm_dismiss];
    self.paying = NO;
    [self removeAllUncompleteTransactionsBeforeNewPurchase];
    [self removeObserver];
    [self removeLocReceiptData];
    if (self.manualVerify == NO) return;
    self.manualVerify = NO;
    [self showInfoMessage:message];
}

//订单验证失败 - 由网络等原因引起的验证失败,不关闭交易
//当下次进入APP时调用[self addObserver],即可重新验证
- (void)verifyPurchaseFail {
    [WZMViewHandle wzm_dismiss];
    self.paying = NO;
    [self removeObserver];
    if (self.manualVerify == NO) return;
    self.manualVerify = NO;
    [self showVerifyPurchaseFail];
}

//结束未完成的交易
- (void)removeAllUncompleteTransactionsBeforeNewPurchase{
    NSArray *transactions = [SKPaymentQueue defaultQueue].transactions;
    if (transactions.count >= 1) {
        for (SKPaymentTransaction *transaction in transactions) {
            if (transaction.transactionState == SKPaymentTransactionStatePurchased ||
                transaction.transactionState == SKPaymentTransactionStateRestored) {
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            }
        }
    }
    else {
        WZMLog(@"没有历史未消耗订单");
    }
}

- (void)addObserver {
    if (self.isAddObserver == NO) {
        self.addObserver = YES;
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
}

- (void)removeObserver {
    if (self.isAddObserver) {
        self.addObserver = NO;
        [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    }
}

- (void)saveReceiptData {
    if (self.orderId == nil || self.receipt == nil) return;
    NSDictionary *dic = @{@"orderId":self.orderId,@"receipt":self.receipt};
    [[NSUserDefaults standardUserDefaults] setValue:dic forKey:kSaveReceiptData];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
    if (msg.length == 0) return;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:msg
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)showVerifyPurchaseFail {
    self.failedCount ++;
    if (self.failedCount < 3) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"订单验证失败"
                                                            message:@"请检查网络环境后重试，取消后下次点击充值时将自动验证！"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"再次验证", nil];
        [alertView show];
    }
    else {
        NSString *msg = [NSString stringWithFormat:@"该订单已连续%ld次验证失败，是否放弃该订单？",(long)self.failedCount];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
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
            self.manualVerify = YES;
            [self checkAppleOrder:@"订单验证中..."];
        }
        else {
            self.failedCount = 0;
            [self finishTransaction:@"支付失败"];
        }
    }
}

- (void)dealloc {
    [self removeObserver];
}

@end

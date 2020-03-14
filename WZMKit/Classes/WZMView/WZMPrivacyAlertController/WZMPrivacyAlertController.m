//
//  WZMPrivacyAlertController.m
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2020/1/14.
//  Copyright © 2020 wangzhaomeng. All rights reserved.
//

#import "WZMPrivacyAlertController.h"
#import <WebKit/WebKit.h>
#import "WZMMacro.h"
#import "UIImage+wzmcate.h"

#define WZM_WEB_ALERT_COLOR [UIColor redColor]
@interface WZMPrivacyAlertController ()

@property (nonatomic, strong) NSString *yinsiUrl;
@property (nonatomic, strong) NSString *yonghuUrl;
@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIView *bgColorView;
@property (nonatomic, strong) UIImageView *bgImageView;

@end

@implementation WZMPrivacyAlertController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.yinsiUrl = [WZMPublic filePathWithFolder:@"privacy" fileName:@"privacy.html"];
        self.yonghuUrl = [WZMPublic filePathWithFolder:@"privacy" fileName:@"agreement.html"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.bgImageView];
    [self.view addSubview:self.bgColorView];
    [self.view addSubview:self.alertView];
    [self.alertView addSubview:self.webView];
    [self loadUrl:self.yinsiUrl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.alertView.hidden = YES;
    self.bgImageView.image = self.image;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.alertView.hidden = NO;
}

- (void)loadUrl:(NSString *)url {
    NSURL *URL;
    if ([[NSFileManager defaultManager] fileExistsAtPath:url]) {
        URL = [NSURL fileURLWithPath:url];
    }
    else {
        URL = [NSURL URLWithString:url];
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [self.webView loadRequest:[self handlingRequest:request]];
}

- (NSURLRequest *)handlingRequest:(NSMutableURLRequest *)request {
    return [request copy];
}

- (void)btnClick:(UIButton *)btn {
    [WZMPrivacyAlertController saveYinSiKey];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)lookBtnClick:(UIButton *)btn {
    btn.selected = !btn.isSelected;
    if (btn.isSelected) {
        //用户协议
        [self loadUrl:self.yonghuUrl];
    }
    else {
        //隐私政策
        [self loadUrl:self.yinsiUrl];
    }
}

- (void)showFromController:(UIViewController *)viewController {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    self.image = [self wzm_getScreenImageByView:window];
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    [viewController presentViewController:self animated:NO completion:nil];
}

- (UIImage *)wzm_getScreenImageByView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - lazy load
- (WKWebView *)webView {
    if (_webView == nil) {
        CGRect frame = self.alertView.bounds;
        frame.origin.x = 10;
        frame.origin.y = 10;
        frame.size.width -= 20;
        frame.size.height -= 100;
        _webView = [[WKWebView alloc]initWithFrame:frame];
        if (@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _webView.clipsToBounds = YES;
    }
    return _webView;
}

- (UIView *)alertView {
    if (_alertView == nil) {
        CGFloat alertW = self.view.bounds.size.width*0.75;
        CGFloat alertH = self.view.bounds.size.height*0.6;
        CGRect frame = CGRectMake((self.view.bounds.size.width-alertW)/2, (self.view.bounds.size.height-alertH)/2, alertW, alertH);
        _alertView = [[UIView alloc]initWithFrame:frame];
        _alertView.backgroundColor = [UIColor whiteColor];
        _alertView.layer.cornerRadius = 10;
        _alertView.layer.masksToBounds = YES;
        
        NSMutableAttributedString *attstr1 = [[NSMutableAttributedString alloc] initWithString:@"您也可以查看《用户使用协议》"];
        [attstr1 addAttributes:@{NSForegroundColorAttributeName:[UIColor darkTextColor]} range:NSMakeRange(0, 6)];
        [attstr1 addAttributes:@{NSForegroundColorAttributeName:WZM_WEB_ALERT_COLOR} range:NSMakeRange(6, 8)];
        
        NSMutableAttributedString *attstr2 = [[NSMutableAttributedString alloc] initWithString:@"您也可以查看《隐私政策》"];
        [attstr2 addAttributes:@{NSForegroundColorAttributeName:[UIColor darkTextColor]} range:NSMakeRange(0, 6)];
        [attstr2 addAttributes:@{NSForegroundColorAttributeName:WZM_WEB_ALERT_COLOR} range:NSMakeRange(6, 6)];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(8, _alertView.bounds.size.height-80, _alertView.bounds.size.width, 20)];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [btn setAttributedTitle:attstr1 forState:UIControlStateNormal];
        [btn setAttributedTitle:attstr2 forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(lookBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_alertView addSubview:btn];
        
        CGFloat btnWidth = CGRectGetWidth(_alertView.frame);
        CGFloat btnY = _alertView.bounds.size.height-50;
        UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        okBtn.frame = CGRectMake(0, btnY, btnWidth, 50);
        okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [okBtn setTitle:@"我知道了" forState:UIControlStateNormal];
        [okBtn setBackgroundImage:[UIImage wzm_getImageByColor:[UIColor colorWithWhite:.8 alpha:.5]] forState:UIControlStateHighlighted];
        [okBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [okBtn setTitleColor:WZM_WEB_ALERT_COLOR forState:UIControlStateNormal];
        [_alertView addSubview:okBtn];
        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, btnY, _alertView.bounds.size.width, 0.5)];
        topLine.backgroundColor = [UIColor colorWithRed:222.0/255 green:222.0/255 blue:222.0/255 alpha:0.5];
        [_alertView addSubview:topLine];
    }
    return _alertView;
}

- (UIImageView *)bgImageView {
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    }
    return _bgImageView;
}

- (UIView *)bgColorView {
    if (_bgColorView == nil) {
        _bgColorView = [[UIView alloc] initWithFrame:self.view.bounds];
        _bgColorView.backgroundColor = [UIColor colorWithRed:50.0/255 green:50.0/255 blue:50.0/255 alpha:0.6];
    }
    return _bgColorView;
}

+ (void)showAlertFromController:(UIViewController *)viewController {
    if ([self checkShowYinSi]) {
        //隐私协议
        WZMPrivacyAlertController *alert = [[WZMPrivacyAlertController alloc] init];
        [alert showFromController:viewController];
    }
}

+ (BOOL)checkShowYinSi {
    return ![[NSUserDefaults standardUserDefaults] boolForKey:WZM_APP_VERSION];
}

+ (BOOL)saveYinSiKey {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:WZM_APP_VERSION];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

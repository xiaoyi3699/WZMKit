//
//  WZMProgressHUD.m
//  WZMKit
//
//  Created by WangZhaomeng on 2017/10/26.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "WZMProgressHUD.h"
#import "WZMMacro.h"

@interface WZMProgressView ()

@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@end

@implementation WZMProgressView

- (instancetype)init {
    self = [super init];
    if (self) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityView.hidesWhenStopped = YES;
        [self addSubview:_activityView];
        
        _messageLabel = [[UILabel alloc] init];
        [self addSubview:_messageLabel];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        if (self.messageLabel.hidden) {
            self.messageLabel.frame = CGRectZero;
            self.activityView.frame = self.bounds;
        }
        else {
            self.messageLabel.frame = CGRectMake(0, 65, self.bounds.size.width, 35);
            self.activityView.frame = CGRectMake(0, 0, self.bounds.size.width, 80);
        }
    }
    [super willMoveToSuperview:newSuperview];
}

- (void)startAnimation {
    [self.activityView startAnimating];
}

- (void)stopAnimation {
    [self.activityView stopAnimating];
}

@end

@implementation WZMProgressConfig

+ (instancetype)defaultConfig {
    static WZMProgressConfig *config;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[WZMProgressConfig alloc] init];
    });
    return config;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.blur = YES;
        if (self.isBlur == NO) {
            self.backgroundColor = WZM_R_G_B_A(40, 40, 40, .6);
        }
        self.textColor = WZM_R_G_B_A(250, 250, 250, 1);
        self.progressColor = WZM_R_G_B_A(250, 250, 250, 1);
        self.font = [UIFont systemFontOfSize:14];
    }
    return self;
}

@end

@interface WZMProgressHUD ()

@property (nonatomic, strong) WZMProgressConfig *config;
@property (nonatomic, strong) WZMProgressView *progressView;
@property (nonatomic, strong) UILabel *messageView;
@property (nonatomic, strong) UIVisualEffectView *effectView;

@end

@implementation WZMProgressHUD

+ (instancetype)defaultHUD {
    static WZMProgressHUD *hud;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hud = [[WZMProgressHUD alloc] init];
        hud.layer.cornerRadius = 3;
        hud.layer.masksToBounds = YES;
    });
    return hud;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.show = NO;
        self.userEnabled = YES;
        self.config = [WZMProgressConfig defaultConfig];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

+ (void)setProgressConfig:(WZMProgressConfig *)config {
    WZMProgressHUD *hud = [self defaultHUD];
    hud.config = config;
}

+ (void)showInfoMessage:(NSString *)message {
    [self dismiss];
    WZMProgressHUD *hud = [self defaultHUD];
    hud.show = YES;
    CGRect rect; CGFloat w = 30, h = 40;
    if (message.length > 0) {
        w = [message sizeWithAttributes:@{NSFontAttributeName:hud.config.font}].width+30;
    }
    if (hud.isUserEnabled) {
        hud.frame = CGRectMake((WZM_SCREEN_WIDTH-w)/2.0, (WZM_SCREEN_HEIGHT-h)/2, w, h);
        rect = hud.bounds;
    }
    else {
        hud.frame = WZM_SCREEN_BOUNDS;
        rect = CGRectMake((WZM_SCREEN_WIDTH-w)/2.0, (WZM_SCREEN_HEIGHT-h)/2, w, h);
    }
    hud.messageView.frame = rect;
    hud.messageView.text = message;
    hud.messageView.font = hud.config.font;
    hud.messageView.textColor = hud.config.textColor;
    hud.messageView.textAlignment = NSTextAlignmentCenter;
    if (hud.config.isBlur) {
        hud.effectView.frame = hud.bounds;
        if (hud.config.effect) {
            hud.effectView.effect = hud.config.effect;
        }
        hud.effectView.backgroundColor = hud.config.backgroundColor;
        [hud addSubview:hud.effectView];
    }
    else {
        hud.messageView.backgroundColor = hud.config.backgroundColor;
    }
    [hud addSubview:hud.messageView];
    [WZM_WINDOW addSubview:hud];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismiss) object:nil];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:2];
}

+ (void)showProgressMessage:(NSString *)message {
    [self dismiss];
    WZMProgressHUD *hud = [self defaultHUD];
    hud.show = YES;
    CGFloat w = 100, h = 100;
    if (message.length > 0) {
        CGFloat msgW = [message sizeWithAttributes:@{NSFontAttributeName:hud.config.font}].width+20;
        if (msgW > 100) {
            w = msgW;
        }
    }
    CGRect rect;
    if (hud.isUserEnabled) {
        hud.frame = CGRectMake((WZM_SCREEN_WIDTH-w)/2.0, (WZM_SCREEN_HEIGHT-h)/2.0, w, h);
        rect = hud.bounds;
    }
    else {
        hud.frame = WZM_SCREEN_BOUNDS;
        rect = CGRectMake((WZM_SCREEN_WIDTH-w)/2.0, (WZM_SCREEN_HEIGHT-h)/2.0, w, h);
    }
    hud.progressView.frame = rect;
    hud.progressView.activityView.color = hud.config.progressColor;
    hud.progressView.messageLabel.hidden = (message.length == 0);
    hud.progressView.messageLabel.text = message;
    hud.progressView.messageLabel.font = hud.config.font;
    hud.progressView.messageLabel.textColor = hud.config.textColor;
    hud.progressView.messageLabel.textAlignment = NSTextAlignmentCenter;
    if (hud.config.isBlur) {
        hud.effectView.frame = hud.bounds;
        if (hud.config.effect) {
            hud.effectView.effect = hud.config.effect;
        }
        hud.effectView.backgroundColor = hud.config.backgroundColor;
        [hud addSubview:hud.effectView];
    }
    else {
        hud.progressView.backgroundColor = hud.config.backgroundColor;
    }
    [hud addSubview:hud.progressView];
    [WZM_WINDOW addSubview:hud];
    [hud.progressView startAnimation];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismiss) object:nil];
}

+ (void)dismiss {
    WZMProgressHUD *hud = [self defaultHUD];
    if (hud.isShow) {
        hud.show = NO;
        for (UIView *view in hud.subviews) {
            if ([view isKindOfClass:[WZMProgressView class]]) {
                [(WZMProgressView *)view stopAnimation];
            }
            [view removeFromSuperview];
        }
        [hud removeFromSuperview];
    }
}

#define mark - 懒加载
- (WZMProgressView *)progressView {
    if (_progressView == nil) {
        _progressView = [[WZMProgressView alloc] init];
    }
    return _progressView;
}

- (UILabel *)messageView {
    if (_messageView == nil) {
        _messageView = [[UILabel alloc] init];
    }
    return _messageView;
}

- (UIVisualEffectView *)effectView {
    if (_effectView == nil) {
        _effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    }
    return _effectView;
}

@end

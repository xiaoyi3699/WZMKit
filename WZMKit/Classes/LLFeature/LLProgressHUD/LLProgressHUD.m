//
//  LLProgressHUD.m
//  LLFeature
//
//  Created by WangZhaomeng on 2017/10/26.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "LLProgressHUD.h"
#import "LLMacro.h"

@interface LLProgressView ()

@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation LLProgressView

- (instancetype)init {
    self = [super init];
    if (self) {
        _messageLabel = [[UILabel alloc] init];
        [self addSubview:_messageLabel];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview) {
        [self creatGradientLayer];
        
        if (_messageLabel.hidden == NO) {
            _messageLabel.frame = CGRectMake(0, 65, self.bounds.size.width, 35);
        }
    }
}

- (void)startAnimation {
    for (CALayer *layer in self.layer.sublayers) {
        if ([layer isKindOfClass:[CAGradientLayer class]]) {
            [layer addAnimation:[self animation] forKey:@"Rotation"];
            break;
        }
    }
}

- (void)stopAnimation {
    [self.layer removeAllAnimations];
}

- (void)creatGradientLayer{
    for (CALayer *layer in self.layer.sublayers) {
        if ([layer isKindOfClass:[CAGradientLayer class]]) {
            [layer removeFromSuperlayer];
        }
    }
    CGRect rect = self.bounds;
    CGFloat y;
    if (self.messageLabel.text.length) {
        y = 5;
    }
    else {
        y = (rect.size.height-60)/2.0;
    }
    rect.origin.x = (rect.size.width-60)/2.0;
    rect.origin.y = y;
    rect.size.width = 60;
    rect.size.height = 60;
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = rect;
    [self.layer addSublayer:gradientLayer];
    
    gradientLayer.colors = @[(id)[UIColor whiteColor].CGColor,(id)self.progressColor.CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    UIBezierPath *bezierP = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(10, 10, 40, 40)];
    CAShapeLayer* shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.path = bezierP.CGPath;
    shapeLayer.lineWidth = 3;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor blueColor].CGColor;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.strokeStart = 0.0;
    shapeLayer.strokeEnd = 1.0;
    gradientLayer.mask = shapeLayer;
}

- (CABasicAnimation *)animation {
    static CABasicAnimation* rotationAnimation;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *transformName = [NSString stringWithFormat:@"transform.rotation.z"];
        rotationAnimation = [CABasicAnimation animationWithKeyPath:transformName];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI*2.0 ];
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        rotationAnimation.duration = .5;
        rotationAnimation.repeatCount = LONG_MAX;
        rotationAnimation.cumulative = NO;
        rotationAnimation.removedOnCompletion = NO;
        rotationAnimation.fillMode = kCAFillModeForwards;
    });
    return rotationAnimation;
}

@end

@implementation LLProgressConfig

+ (instancetype)defaultConfig {
    static LLProgressConfig *config;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[LLProgressConfig alloc] init];
    });
    return config;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = R_G_B_A(50, 50, 50, .5);
        self.textColor = R_G_B_A(250, 250, 250, 1);
        self.progressColor = R_G_B_A(180, 180, 180, 1);
        self.font = [UIFont systemFontOfSize:14];
    }
    return self;
}

@end

@interface LLProgressHUD ()

@property (nonatomic, strong) LLProgressConfig *config;
@property (nonatomic, strong) LLProgressView *progressView;
@property (nonatomic, strong) UILabel *messageView;

@end

@implementation LLProgressHUD

+ (instancetype)defaultHUD {
    static LLProgressHUD *hud;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hud = [[LLProgressHUD alloc] init];
    });
    return hud;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.show = NO;
        self.userEnabled = YES;
        self.config = [LLProgressConfig defaultConfig];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

+ (void)setProgressConfig:(LLProgressConfig *)config {
    LLProgressHUD *hud = [self defaultHUD];
    hud.config = config;
}

+ (void)showInfoMessage:(NSString *)message {
    [self dismiss];
    LLProgressHUD *hud = [self defaultHUD];
    hud.show = YES;
    CGRect rect; CGFloat w = 30, h = 30;
    if (message.length > 0) {
        w = [message sizeWithAttributes:@{NSFontAttributeName:hud.config.font}].width+30;
    }
    if (hud.isUserEnabled) {
        hud.frame = CGRectMake((LL_SCREEN_WIDTH-w)/2.0, (LL_SCREEN_HEIGHT-150), w, h);
        rect = hud.bounds;
    }
    else {
        hud.frame = LL_SCREEN_BOUNDS;
        rect = CGRectMake((LL_SCREEN_WIDTH-w)/2.0, (LL_SCREEN_HEIGHT-150), w, h);
    }
    hud.messageView.frame = rect;
    hud.messageView.text = message;
    hud.messageView.font = hud.config.font;
    hud.messageView.textColor = hud.config.textColor;
    hud.messageView.textAlignment = NSTextAlignmentCenter;
    hud.messageView.backgroundColor = hud.config.backgroundColor;
    [hud addSubview:hud.messageView];
    [LL_WINDOW addSubview:hud];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismiss) object:nil];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:2];
}

+ (void)showProgressMessage:(NSString *)message {
    [self dismiss];
    LLProgressHUD *hud = [self defaultHUD];
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
        hud.frame = CGRectMake((LL_SCREEN_WIDTH-w)/2.0, (LL_SCREEN_HEIGHT-h)/2.0, w, h);
        rect = hud.bounds;
    }
    else {
        hud.frame = LL_SCREEN_BOUNDS;
        rect = CGRectMake((LL_SCREEN_WIDTH-w)/2.0, (LL_SCREEN_HEIGHT-h)/2.0, w, h);
    }
    hud.progressView.frame = rect;
    hud.progressView.backgroundColor = hud.config.backgroundColor;
    hud.progressView.progressColor = hud.config.progressColor;
    hud.progressView.messageLabel.hidden = (message.length == 0);
    hud.progressView.messageLabel.text = message;
    hud.progressView.messageLabel.font = hud.config.font;
    hud.progressView.messageLabel.textColor = hud.config.textColor;
    hud.progressView.messageLabel.textAlignment = NSTextAlignmentCenter;
    [hud addSubview:hud.progressView];
    [LL_WINDOW addSubview:hud];
    [hud.progressView startAnimation];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismiss) object:nil];
}

+ (void)dismiss {
    LLProgressHUD *hud = [self defaultHUD];
    if (hud.isShow) {
        hud.show = NO;
        for (UIView *view in hud.subviews) {
            if ([view isKindOfClass:[LLProgressView class]]) {
                [(LLProgressView *)view stopAnimation];
            }
            [view removeFromSuperview];
        }
        [hud removeFromSuperview];
    }
}

#define mark - 懒加载
- (LLProgressView *)progressView {
    if (_progressView == nil) {
        _progressView = [[LLProgressView alloc] init];
        _progressView.layer.masksToBounds = YES;
        _progressView.layer.cornerRadius = 5;
    }
    return _progressView;
}

- (UILabel *)messageView {
    if (_messageView == nil) {
        _messageView = [[UILabel alloc] init];
        _messageView.layer.masksToBounds = YES;
        _messageView.layer.cornerRadius = 3;
    }
    return _messageView;
}

@end

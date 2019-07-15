//
//  LLPublic.m
//  LLFeatureStatic
//
//  Created by WangZhaomeng on 2019/5/20.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import "LLPublic.h"

@implementation LLPublic {
    NSInteger _iPad;
    NSInteger _iPhone;
    NSInteger _iPhoneX;
    
    CGFloat _statusH;
    CGFloat _navBarH;
    CGFloat _tabBarH;
    
    CGFloat _screenH;
    CGFloat _screenW;
    CGFloat _screenScale;
    CGRect _screenBounds;
    
    CGFloat _iPhoneXBottomH;
    
    CGFloat _systemV;
    NSString *_buildV;
    NSString *_shortV;
    NSString *_appName;
    NSString *_temp;
    NSString *_cache;
    NSString *_document;
}

+ (instancetype)Public {
    static LLPublic *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LLPublic alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _iPad = -1;
        _iPhone  = -1;
        _iPhoneX = -1;
        _systemV = -1;
        _buildV = nil;
        _shortV = nil;
        _appName = nil;
        _temp = nil;
        _cache = nil;
        _document = nil;
        [self reset];
    }
    return self;
}

- (void)reset {
    _statusH = -1;
    _navBarH = -1;
    _tabBarH = -1;
    _screenW = -1;
    _screenH = -1;
    _screenScale = -1;
    _screenBounds = CGRectNull;
    _iPhoneXBottomH = -1;
}

///是否是iPad
- (BOOL)iPad {
    if (_iPad == -1) {
        _iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    }
    return (_iPad == 1);
}

///是否是iPhone
- (BOOL)iPhone {
    if (_iPhone == -1) {
        _iPhone = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
    }
    return (_iPhone == 1);
}

///是否是iPhoneX
- (BOOL)iPhoneX {
    if (_iPhoneX == -1) {
        _iPhoneX = ([self iPhone] && [UIScreen mainScreen].bounds.size.height>=812);
    }
    return (_iPhoneX == 1);
}

///状态栏高
- (CGFloat)statusH {
    if (_statusH == -1) {
        _statusH = ([self iPhoneX] ? 44:20);
    }
    return _statusH;
}

///导航高
- (CGFloat)navBarH {
    if (_navBarH == -1) {
        _navBarH = ([self iPhoneX] ? 88:64);
    }
    return _navBarH;
}

///taBar高
- (CGFloat)tabBarH {
    if (_tabBarH == -1) {
        _tabBarH = ([self iPhoneX] ? 83:49);
    }
    return _tabBarH;
}

///屏幕宽
- (CGFloat)screenW {
    if (_screenW == -1) {
        _screenW = [UIScreen mainScreen].bounds.size.width;
    }
    return _screenW;
}

///屏幕高
- (CGFloat)screenH {
    if (_screenH == -1) {
        _screenH = [UIScreen mainScreen].bounds.size.height;
    }
    return _screenH;
}

///屏幕scale
- (CGFloat)screenScale {
    if (_screenScale == -1) {
        _screenScale = [UIScreen mainScreen].scale;
    }
    return _screenScale;
}

///屏幕bounds
- (CGRect)screenBounds {
    if (CGRectIsNull(_screenBounds)) {
        _screenBounds = [UIScreen mainScreen].bounds;
    }
    return _screenBounds;
}

///iPhoneX底部高度
- (CGFloat)iPhoneXBottomH {
    if (_iPhoneXBottomH == -1) {
        _iPhoneXBottomH = ([self iPhoneX] ? 34:0);
    }
    return _iPhoneXBottomH;
}

///系统版本
- (CGFloat)systemV {
    if (_systemV == -1) {
        _systemV = [[UIDevice currentDevice].systemVersion doubleValue];
    }
    return _systemV;
}

///build版本
- (NSString *)buildV {
    if (_buildV == nil || _buildV.length == 0) {
        _buildV = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    }
    return _buildV;
}

///short版本
- (NSString *)shortV {
    if (_shortV == nil || _shortV.length == 0) {
        _shortV = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    }
    return _shortV;
}

///应用名称
- (NSString *)appName {
    if (_appName == nil || _appName.length == 0) {
        _appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    }
    return _appName;
}

///temp
- (NSString *)temp {
    if (_temp == nil || _temp.length == 0) {
        _temp = NSTemporaryDirectory();
    }
    return _temp;
}

///cache
- (NSString *)cache {
    if (_cache == nil || _cache.length == 0) {
        _cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    }
    return _cache;
}

///document
- (NSString *)document {
    if (_document == nil || _document.length == 0) {
        _document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    }
    return _document;
}

@end

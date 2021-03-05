//
//  WZMPublic.m
//  WZMKit
//
//  Created by WangZhaomeng on 2019/5/20.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import "WZMPublic.h"

@implementation WZMPublic {
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
    NSBundle *_resourceBundle;
}

+ (instancetype)sharePublic {
    static WZMPublic *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WZMPublic alloc] init];
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
        _statusH = -1;
        _navBarH = -1;
        _tabBarH = -1;
        _iPhoneXBottomH = -1;
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
    _screenW = -1;
    _screenH = -1;
    _screenScale = -1;
    _screenBounds = CGRectNull;
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
        if (@available(iOS 11.0, *)) {
            UIWindow *window = [UIApplication sharedApplication].delegate.window;
            _iPhoneX = ([self iPhone] && (window.safeAreaInsets.bottom > 0.0));
        }
        else {
            _iPhoneX = 0;
        }
    }
    return (_iPhoneX == 1);
}

///状态栏高
- (CGFloat)statusH {
    if (_statusH == -1) {
        if (@available(iOS 11.0, *)) {
            UIWindow *window = [UIApplication sharedApplication].delegate.window;
            _statusH = window.safeAreaInsets.top;
        }
        else {
            _statusH = 20.0;
        }
    }
    return _statusH;
}

///导航高
- (CGFloat)navBarH {
    if (_navBarH == -1) {
        _navBarH = [self statusH] + 44.0;
    }
    return _navBarH;
}

///taBar高
- (CGFloat)tabBarH {
    if (_tabBarH == -1) {
        if (@available(iOS 11.0, *)) {
            UIWindow *window = [UIApplication sharedApplication].delegate.window;
            _tabBarH = window.safeAreaInsets.bottom + 49.0;
        }
        else {
            _tabBarH = 49.0;
        }
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
        if (@available(iOS 11.0, *)) {
            UIWindow *window = [UIApplication sharedApplication].delegate.window;
            _iPhoneXBottomH = window.safeAreaInsets.bottom;
        }
        else {
            _iPhoneXBottomH = 0.0;
        }
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

- (NSBundle *)resourceBundle {
    if (_resourceBundle == nil) {
        NSBundle *kitBundle = [NSBundle bundleForClass:[WZMPublic class]];
        NSString *path = [kitBundle pathForResource:@"WZMResources" ofType:@"bundle"];
        NSBundle *bundle = [NSBundle bundleWithPath:path];
        if (bundle == nil) {
            path = [kitBundle.bundlePath stringByAppendingPathComponent:@"WZMKit.bundle/WZMResources.bundle"];
            bundle = [NSBundle bundleWithPath:path];
        }
        _resourceBundle = bundle;
    }
    return _resourceBundle;
}

+ (NSString *)filePathWithFolder:(NSString *)folder fileName:(NSString *)fileName {
    NSBundle *bundle = [[WZMPublic sharePublic] resourceBundle];
    NSString *resource = [NSString stringWithFormat:@"%@/%@",folder,fileName];
    return [NSString stringWithFormat:@"%@/%@",bundle.bundlePath,resource];
}

+ (UIImage *)imageWithFolder:(NSString *)folder imageName:(NSString *)imageName {
    NSString *filePath = [self filePathWithFolder:folder fileName:imageName];
    return [UIImage imageWithContentsOfFile:filePath];
}

//上传单张图片
+ (void)uploadImage:(UIImage *)image completion:(void(^)(NSString *url))completion {
    
}

//上传多张图片
+ (void)uploadImages:(NSArray *)images completion:(void(^)(NSArray *urls))completion {
    //这里面放要完成之后的url
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [self uploadImages:images index:0 array:array completion:^{
        if (completion) completion(array);
    }];
}

+ (void)uploadImages:(NSArray *)images index:(NSInteger)index array:(NSMutableArray *)array completion:(void(^)(void))completion {
    if (index < images.count) {
        UIImage *image = [images objectAtIndex:index];
        [self uploadImage:image completion:^(NSString *url) {
            [array addObject:url];
            [self uploadImages:images index:(index+1) array:array completion:^ {
                if (completion) completion();
            }];
        }];
    }
    else {
        if (completion) completion();
    }
}

@end

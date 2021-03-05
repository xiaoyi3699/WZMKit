//
//  WZMTransGifViewController.m
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2020/11/24.
//  Copyright © 2020 wangzhaomeng. All rights reserved.
//

#import "WZMTransGifViewController.h"
#import "WZMGifListView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "WZMGifHelper.h"

@interface WZMTransGifViewController ()<WZMGifListViewDelegate>
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, assign) CGFloat gifScale;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) WZMGifListView *gifListView;
@end

@implementation WZMTransGifViewController

- (instancetype)initWithImages:(NSArray *)images {
    self = [super init];
    if (self) {
        self.gifScale = 1.0;
        self.images = images;
        self.title = @"制作GIF";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.image = [WZMGifHelper getImage:self.images.firstObject];
    self.imageView.clipsToBounds = YES;
    [self.view addSubview:self.imageView];
    [self layoutPreview];
    
    self.gifListView = [[WZMGifListView alloc] init];
    self.gifListView.frame = CGRectMake(0.0, self.view.wzm_height-WZM_BOTTOM_HEIGHT-[self bottomToolHeight], WZM_SCREEN_WIDTH, [self bottomToolHeight]);
    self.gifListView.fromController = self;
    self.gifListView.delegate = self;
    [self.view addSubview:self.gifListView];
    [self.gifListView reloadWithImages:self.images];
    
    //保存按钮
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 60.0, 28.0)];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    rightBtn.backgroundColor = [UIColor colorWithRed:36.0/255.0 green:189.0/255.0 blue:72.0/255.0 alpha:1.0];
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.wzm_cornerRadius = 14.0;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self gifListViewDidChange:self.gifListView];
}

- (void)rightItemClick {
    [WZMViewHandle wzm_showProgressMessage:@"制作中..."];
    WZMDispatch_execute_global_queue(^{
        CGFloat duration = (self.gifListView.dataList.count*self.gifListView.delayTime*self.gifScale);
        NSString *path = [self creatGifWithImages:self.gifListView.dataList duration:duration];
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        if (data) {
            ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
            [assetsLibrary writeImageDataToSavedPhotosAlbum:data metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
                WZMDispatch_execute_main_queue(^{
                    if (error) {
                        [WZMViewHandle wzm_showInfoMessage:@"保存失败"];
                    }
                    else {
                        [WZMViewHandle wzm_showInfoMessage:@"保存成功"];
                    }
                });
            }];
        }
        else {
            WZMDispatch_execute_main_queue(^{
                [WZMViewHandle wzm_showInfoMessage:@"保存失败"];
            });
        }
    });
}

//制作gif
- (NSString *)creatGifWithImages:(NSArray *)aImages duration:(CGFloat)duration {
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (id img in aImages) {
        UIImage *image = [WZMGifHelper getImage:img];
        if (image) {
            [images addObject:image];
        }
    }
    NSString *gifDic = [WZM_TEMP_PATH stringByAppendingString:@"/gif"];
    [WZMFileManager createDirectoryAtPath:gifDic];
    NSString *path = [gifDic stringByAppendingString:@"wzm.gif"];
    [WZMFileManager deleteFileAtPath:path error:nil];
    
    //配置gif属性
    CGImageDestinationRef destion;
    //    路径url，图片类型，图片数，
    CFStringRef GIFType = (CFStringRef)@"com.compuserve.gif";
    CFURLRef url = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)path, kCFURLPOSIXPathStyle, false);
    destion = CGImageDestinationCreateWithURL(url, GIFType, images.count, NULL);
    
    //帧 时间间隔
    CGFloat time = duration/images.count;
    NSDictionary *timeDic = @{(NSString*)kCGImagePropertyGIFDelayTime:@(time)};
    NSDictionary *frameDic = @{(NSString *)kCGImagePropertyGIFDictionary:timeDic};
    
    //git参数：颜色空间，颜色模式，深度，循环次数
    NSMutableDictionary *gifParmdict = [[NSMutableDictionary alloc] init];
    [gifParmdict setObject:[NSNumber numberWithBool:YES] forKey:(NSString*)kCGImagePropertyGIFHasGlobalColorMap];
    [gifParmdict setObject:(NSString*)kCGImagePropertyColorModelRGB forKey:(NSString*)kCGImagePropertyColorModel];
    [gifParmdict setObject:[NSNumber numberWithInt:8] forKey:(NSString*)kCGImagePropertyDepth];
    [gifParmdict setObject:[NSNumber numberWithInt:0] forKey:(NSString*)kCGImagePropertyGIFLoopCount];
    NSDictionary *gifProperty = [NSDictionary dictionaryWithObject:gifParmdict forKey:(NSString*)kCGImagePropertyGIFDictionary];
    
    UIImage *fImage = images.firstObject;
    CGFloat fScale = fImage.size.width/fImage.size.height;
    for (UIImage *dimage in images) {
        //适配填充
        CGSize oSize = dimage.size;
        CGFloat x = 0.0, y = 0.0, w = 0.0, h = 0.0;
        if (oSize.width/oSize.height > fScale) {
            h = oSize.height;
            w = oSize.height*fScale;
            x = (oSize.width - w)/2.0;
        }
        else {
            h = oSize.width/fScale;
            w = oSize.width;
            y = (oSize.height - h)/2.0;
        }
        CGRect rect = CGRectZero;
        rect.origin = CGPointMake(x, y);
        rect.size = CGSizeMake(w, h);
        //剪裁填充
        CGImageRef refImage = CGImageCreateWithImageInRect(dimage.CGImage, rect);
        UIImage *image = [UIImage imageWithCGImage:refImage];
        image = [image wzm_getImageWithScale:(fImage.size.width/image.size.width)];
        CGImageDestinationAddImage(destion, image.CGImage, (__bridge CFDictionaryRef)frameDic);
    }
    // 添加GIF属性
    CGImageDestinationSetProperties(destion,(__bridge CFDictionaryRef)gifProperty);
    CGImageDestinationFinalize(destion);   // 最终确定 生成
    CFRelease(destion);  // 释放资源
    return path;
}

- (void)layoutPreview {
    UIImage *preImage = self.imageView.image;
    if (preImage) {
        CGFloat dh = [self bottomToolHeight]+20.0+WZM_NAVBAR_HEIGHT;
        CGSize contentSize = self.view.bounds.size;
        contentSize.width -= 20.0;
        contentSize.height -= (WZM_BOTTOM_HEIGHT+dh);
        CGSize size = WZMSizeRatioToMaxSize(preImage.size, contentSize);
        CGRect rect = self.view.bounds;
        rect.origin.x = 10.0+(rect.size.width-20.0-size.width)/2.0;
        rect.origin.y = WZM_NAVBAR_HEIGHT+10.0+(rect.size.height-(WZM_BOTTOM_HEIGHT+dh)-size.height)/2.0;
        rect.size = size;
        self.imageView.frame = rect;
    }
}

- (void)animationWithImages:(NSArray *)images duration:(CGFloat)duration {
    [self.imageView stopAnimating];
    self.imageView.image = images.firstObject;
    WZMDispatch_after(0.1, ^{
        [self.imageView setAnimationImages:images];
        [self.imageView setAnimationDuration:duration];
        [self.imageView setAnimationRepeatCount:LONG_MAX];
        [self.imageView startAnimating];
    });
}

- (void)gifListViewDidChange:(WZMGifListView *)gifListView {
    CGFloat duration = (gifListView.dataList.count*gifListView.delayTime*self.gifScale);
    [self animationWithImages:gifListView.dataList duration:duration];
}

- (CGFloat)bottomToolHeight {
    return 160.0;
}

- (void)dealloc {
    WZMLog(@"%@释放了",self.wzm_className);
}

@end

//
//  LLPhoto.m
//  LLPhotoBrowser
//
//  Created by zhaomengWang on 17/2/6.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "LLPhoto.h"
#import <ImageIO/ImageIO.h>
#import "NSString+LLAddPart.h"
#import "LLGifImageView.h"
#import "LLImageCache.h"
#import "UIView+LLAddPart.h"
#import "NSData+LLAddData.h"
#import "UIImage+LLAddPart.h"

#define LLPhotoMaxSCale 3.0  //最大缩放比例
#define LLPhotoMinScale 1.0  //最小缩放比例
@interface LLPhoto ()<UIScrollViewDelegate>{
    LLGifImageView *_imageView;
    NSData         *_imageData;
    UIImage        *_currentImage;
    BOOL           _isGif;
}
@end

@implementation LLPhoto

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.minimumZoomScale = LLPhotoMinScale;
        self.maximumZoomScale = LLPhotoMaxSCale;
        self.backgroundColor  = [UIColor clearColor];
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        
        UITapGestureRecognizer *singleClick = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(singleClick:)];
        [self addGestureRecognizer:singleClick];
        
        UITapGestureRecognizer *doubleClick = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(doubleClick:)];
        doubleClick.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleClick];
        
        [singleClick requireGestureRecognizerToFail:doubleClick];
        
        UILongPressGestureRecognizer *longClick = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                action:@selector(longClick:)];
        [self addGestureRecognizer:longClick];
        
        _imageView = [[LLGifImageView alloc] init];
        [self addSubview:_imageView];
        [self showPlaceholderImage];
    }
    return self;
}

- (void)startGif {
    if (_isGif && _currentImage) {
        [_imageView startGif];
    }
}

- (void)stopGif {
    if (_isGif && _currentImage) {
        [_imageView stopGif];
    }
}

#pragma mark - private method
//根据路径/网址加载图片
- (void)setPath:(NSString *)path {
    if (path.length == 0) return;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        _imageData = [NSData dataWithContentsOfFile:path];
        [self setupImageData];
    }
    else {
        NSURL *URL = [NSURL URLWithString:path];
        if (URL == nil) {
            URL = [NSURL URLWithString:[path ll_getURLEncoded]];
        }
        BOOL isNetImage = [[UIApplication sharedApplication] canOpenURL:URL];
        if (isNetImage) {
            _imageData = [[LLImageCache imageCache] dataForKey:path];
            if (_imageData == nil) {
                [self showPlaceholderImage];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    _imageData = [[LLImageCache imageCache] getDataWithUrl:path isUseCatch:YES];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self setupImageData];
                    });
                });
            }
            else {
                [self setupImageData];
            }
        }
        else {
            [self showPlaceholderImage];
        }
    }
}

//更新image
- (void)setupImageData {
    if (_imageData) {
        BOOL isGif = ([_imageData ll_contentType] == LLImageTypeGIF);
        _currentImage = [UIImage imageWithData:_imageData];
        if (_currentImage) {
            [self layoutImageViewIsGif:isGif];
            return;
        }
    }
    [self showPlaceholderImage];
}

//自适应图片的宽高比
- (void)layoutImageViewIsGif:(BOOL)isGif {
    _isGif = isGif;
    _imageView.frame = [self imageFrame];
    if (_isGif) {
        _imageView.gifData = _imageData;
        [_imageView startGif];
    }
    else {
        _imageView.gifData = nil;
        _imageView.image = _currentImage;
    }
}

//计算imageView的frame
- (CGRect)imageFrame {
    CGRect imageFrame;
    if (_currentImage.size.width > self.bounds.size.width || _currentImage.size.height > self.bounds.size.height) {
        CGFloat imageRatio = _currentImage.size.width/_currentImage.size.height;
        CGFloat photoRatio = self.bounds.size.width/self.bounds.size.height;
        
        if (imageRatio > photoRatio) {
            imageFrame.size = CGSizeMake(self.bounds.size.width, self.bounds.size.width/_currentImage.size.width*_currentImage.size.height);
            imageFrame.origin.x = 0;
            imageFrame.origin.y = (self.bounds.size.height-imageFrame.size.height)/2.0;
        }
        else {
            imageFrame.size = CGSizeMake(self.bounds.size.height/_currentImage.size.height*_currentImage.size.width, self.bounds.size.height);
            imageFrame.origin.x = (self.bounds.size.width-imageFrame.size.width)/2.0;
            imageFrame.origin.y = 0;
        }
    }
    else {
        imageFrame.size = _currentImage.size;
        imageFrame.origin.x = (self.bounds.size.width-_currentImage.size.width)/2.0;
        imageFrame.origin.y = (self.bounds.size.height-_currentImage.size.height)/2.0;
    }
    return imageFrame;
}

//显示占位图
- (void)showPlaceholderImage {
    _imageView.gifData = nil;
    _currentImage = self.placeholderImage;
    [self layoutImageViewIsGif:NO];
}

#pragma mark - setter getter
- (void)setLl_image:(id)ll_image {
    if (_ll_image == ll_image) return;
    if ([ll_image isKindOfClass:[UIImage class]]) {
        _currentImage = (UIImage *)ll_image;
        [self layoutImageViewIsGif:NO];
    }
    else if ([ll_image isKindOfClass:[NSString class]]) {
        [self setPath:(NSString *)ll_image];
    }
    else if ([ll_image isKindOfClass:[NSData class]]) {
        _imageData = (NSData *)ll_image;
        [self setupImageData];
    }
    else {
        [self showPlaceholderImage];
    }
}

- (UIImage *)placeholderImage {
    if (_placeholderImage == nil) {
        _placeholderImage = [UIImage ll_getRectImageByColor:[UIColor whiteColor] size:CGSizeMake(self.LLWidth, self.LLWidth)];
    }
    return _placeholderImage;
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGFloat offsetX = (self.bounds.size.width>self.contentSize.width)?(self.bounds.size.width-self.contentSize.width)*0.5:0.0;
    CGFloat offsetY = (self.bounds.size.height>self.contentSize.height)?(self.bounds.size.height-self.contentSize.height)*0.5:0.0;
    _imageView.center = CGPointMake(scrollView.contentSize.width*0.5+offsetX, scrollView.contentSize.height*0.5+offsetY);
}

#pragma mark - 手势交互
//单击
- (void)singleClick:(UITapGestureRecognizer *)gestureRecognizer {
    [self setDelegeteType:LLGestureRecognizerTypeSingle];
}

//长按
- (void)longClick:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self setDelegeteType:LLGestureRecognizerTypeLong];
    }
}

//双击
- (void)doubleClick:(UITapGestureRecognizer *)gestureRecognizer {
    [self setDelegeteType:LLGestureRecognizerTypeDouble];
    if (self.zoomScale > LLPhotoMinScale) {
        [self setZoomScale:LLPhotoMinScale animated:YES];
    } else {
        CGPoint touchPoint = [gestureRecognizer locationInView:_imageView];
        CGFloat newZoomScale = self.maximumZoomScale;
        CGFloat xsize = self.frame.size.width/newZoomScale;
        CGFloat ysize = self.frame.size.height/newZoomScale;
        [self zoomToRect:CGRectMake(touchPoint.x-xsize/2, touchPoint.y-ysize/2, xsize, ysize) animated:YES];
    }
}

- (void)setDelegeteType:(LLGestureRecognizerType)type {
    if ([self.ll_delegate respondsToSelector:@selector(clickAtPhoto:content:isGif:type:)]) {
        id content = (_isGif ? _imageData : _currentImage);
        [self.ll_delegate clickAtPhoto:self content:content isGif:_isGif type:type];
    }
}

@end

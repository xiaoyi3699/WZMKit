//
//  WZMPasterView.m
//  WZMPasterView
//
//  Created by apple on 15/7/8.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "WZMPasterView.h"
#import "UIImage+WZMPasterView.h"

#define APPFRAME    [UIScreen mainScreen].bounds

@interface WZMPasterView ()<WZMPasterItemViewDelegate> {
    CGPoint         startPoint;
    CGPoint         touchPoint;
}

@property (nonatomic,assign) int newPasterID;
@property (nonatomic,strong) UIButton *bgButton;
@property (nonatomic, strong) NSMutableArray *pasters;
@property (nonatomic,strong) WZMPasterItemView *pasterCurrent;
@property (nonatomic,strong) WZMPasterItemView *filterPaster;

@end

@implementation WZMPasterView

@synthesize filterPaster;

- (int)newPasterID
{
    _newPasterID++;
    return _newPasterID;
}

- (void)setPasterCurrent:(WZMPasterItemView *)pasterCurrent {
    _pasterCurrent = pasterCurrent;
    [self bringSubviewToFront:_pasterCurrent];
    filterPaster = _pasterCurrent;
    if ([self.delegate respondsToSelector:@selector(filterPaster)]) {
        [self.delegate m_filterPaster:_pasterCurrent];
    }
}

- (UIButton *)bgButton
{
    if (!_bgButton) {
        _bgButton = [[UIButton alloc] initWithFrame:self.frame];
        _bgButton.tintColor = nil;
        _bgButton.backgroundColor = nil;
        [_bgButton addTarget:self action:@selector(backgroundClicked:) forControlEvents:UIControlEventTouchUpInside];
        if (![_bgButton superview]) {
            [self addSubview:_bgButton];
        }
    }
    return _bgButton;
}

#pragma mark - initial
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.pasters = [[NSMutableArray alloc] initWithCapacity:1];
        [self bgButton];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    _bgButton.frame = self.bounds;
}

#pragma mark - public
- (void)addPasterWithImg:(UIImage *)imgP
{
    [self clearAllOnFirst];
    self.pasterCurrent = [[WZMPasterItemView alloc] initWithBgView:self pasterID:self.newPasterID img:imgP];
    _pasterCurrent.delegate = self;
    [self.pasters addObject:_pasterCurrent];
}

- (void)backgroundClicked:(UIButton *)btBg
{
    [self clearAllOnFirst];
}

- (void)clearAllOnFirst
{
    _pasterCurrent.isOnFirst = NO;
    [self.pasters enumerateObjectsUsingBlock:^(WZMPasterItemView *pasterV, NSUInteger idx, BOOL * _Nonnull stop) {
         pasterV.isOnFirst = NO;
    }];
}

#pragma mark - PasterViewDelegate
- (void)makePasterBecomeFirstRespond:(int)pasterID
{
    [self.pasters enumerateObjectsUsingBlock:^(WZMPasterItemView *pasterV, NSUInteger idx, BOOL * _Nonnull stop) {
        pasterV.isOnFirst = NO;
        if (pasterV.pasterID == pasterID) {
            self.pasterCurrent = pasterV;
            pasterV.isOnFirst = YES;
        }
    }];
}

- (void)removePaster:(int)pasterID
{
    [self.pasters enumerateObjectsUsingBlock:^(WZMPasterItemView *pasterV, NSUInteger idx, BOOL * _Nonnull stop) {
        if (pasterV.pasterID == pasterID) {
            [self.pasters removeObjectAtIndex:idx];
            *stop = YES;
        }
    }];
}

- (void)stickerTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(stickerTouchesBegan:withEvent:)]) {
        [self.delegate stickerTouchesBegan:touches withEvent:event];
    }
}
- (void)stickerTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(stickerTouchesMoved:withEvent:)]) {
        [self.delegate stickerTouchesMoved:touches withEvent:event];
    }
}
- (void)stickerTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(stickerTouchesEnded:withEvent:)]) {
        [self.delegate stickerTouchesEnded:touches withEvent:event];
    }
}
- (void)stickerTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(stickerTouchesCancelled:withEvent:)]) {
        [self.delegate stickerTouchesCancelled:touches withEvent:event];
    }
}

@end


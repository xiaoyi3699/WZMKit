//
//  WZMPasterView.h
//  WZMPasterView
//
//  Created by apple on 15/7/8.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMPasterItemView.h"
@class WZMPasterItemView;

@protocol WZMPasterViewDelegate <NSObject>

- (void)stickerTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)stickerTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)stickerTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)stickerTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)m_filterPaster:(WZMPasterItemView *)m_filterPaster;

@end
@interface WZMPasterView : UIView

@property (nonatomic,strong) WZMPasterItemView *m_filterPaster;
@property (nonatomic,weak) id<WZMPasterViewDelegate> delegate;

- (void)addPasterWithImg:(UIImage *)imgP;

@end

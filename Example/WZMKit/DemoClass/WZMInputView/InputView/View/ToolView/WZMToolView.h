//
//  WZMToolView.h
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/22.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WZMToolViewDelegate;

typedef enum : NSInteger {
    WZMChatRecordTypeBegin = 0,
    WZMChatRecordTypeCancel,
    WZMChatRecordTypeFinish,
} WZMChatRecordType;

@interface WZMToolView : UIView

@property (nonatomic, weak) id<WZMToolViewDelegate> delegate;

@end

@protocol WZMToolViewDelegate <NSObject>

@optional
- (void)toolView:(WZMToolView *)toolView didSelectAtIndex:(NSInteger)index;
- (void)toolView:(WZMToolView *)toolView didChangeRecordType:(WZMChatRecordType)type;

@end

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
    WZMRecordTypeBegin = 0,
    WZMRecordTypeCancel,
    WZMRecordTypeFinish,
} WZMRecordType;

typedef enum : NSInteger {
    WZMKeyboardTypeNone = 0,
    WZMKeyboardTypeSystem,
    WZMKeyboardTypeEmoticon,
    WZMKeyboardTypeMore,
} WZMKeyboardType;

@interface WZMToolView : UIView

@property (nonatomic, weak) id<WZMToolViewDelegate> delegate;

///还原btn状态
- (void)resetStatus;

@end

@protocol WZMToolViewDelegate <NSObject>

@optional
- (void)toolView:(WZMToolView *)toolView didSelectAtIndex:(NSInteger)index;
- (void)toolView:(WZMToolView *)toolView showKeyboardType:(WZMKeyboardType)type;
- (void)toolView:(WZMToolView *)toolView didChangeRecordType:(WZMRecordType)type;

@end

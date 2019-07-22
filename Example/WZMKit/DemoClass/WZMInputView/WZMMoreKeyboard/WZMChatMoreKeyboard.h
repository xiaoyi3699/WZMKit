//
//  WZMChatMoreKeyboard.h
//  WZMChat
//
//  Created by WangZhaomeng on 2018/9/5.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMInputBtn.h"

@protocol WZMChatMoreKeyboardDelegate;

typedef enum : NSInteger {
    WZMChatMoreTypeImage = 0,
    WZMChatMoreTypeVideo,
    WZMChatMoreTypeLocation,
    WZMChatMoreTypeTransfer,
}WZMChatMoreType;

@interface WZMChatMoreKeyboard : UIView

@property (nonatomic, weak) id<WZMChatMoreKeyboardDelegate> delegate;

@end

@protocol WZMChatMoreKeyboardDelegate <NSObject>

@optional
- (void)moreKeyboard:(WZMChatMoreKeyboard *)moreKeyboard didSelectedWithType:(WZMChatMoreType)type;

@end

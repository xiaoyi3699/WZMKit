//
//  WZMMoreKeyboard.h
//  WZMChat
//
//  Created by WangZhaomeng on 2018/9/5.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WZMMoreKeyboardDelegate;

typedef enum : NSInteger {
    WZMChatMoreTypeImage = 0,
    WZMChatMoreTypeVideo,
    WZMChatMoreTypeLocation,
    WZMChatMoreTypeTransfer,
}WZMChatMoreType;

@interface WZMMoreKeyboard : UIView

@property (nonatomic, weak) id<WZMMoreKeyboardDelegate> delegate;

@end

@protocol WZMMoreKeyboardDelegate <NSObject>

@optional
- (void)moreKeyboard:(WZMMoreKeyboard *)moreKeyboard didSelectedWithType:(WZMChatMoreType)type;

@end

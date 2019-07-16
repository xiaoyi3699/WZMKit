//
//  UIButton+LLReaction.m
//  LLCommonStatic
//
//  Created by WangZhaomeng on 2019/6/24.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import "UIButton+LLReaction.h"
#import "NSObject+LLReaction.h"

@implementation UIButton (LLReaction)

//btn只添加一种点击事件
- (void)ll_executeEvent:(UIControlEvents)event action:(nextAction)action {
    if (self.reaction == nil) {
        self.reaction = [[LLReactionManager alloc] init];
    }
    self.reaction.next = action;
    [self addTarget:self.reaction action:@selector(btnClick:) forControlEvents:event];
}

//btn添加多个点击事件, 在回调中判断事件类型
- (void)ll_executeEvent:(eventAction)action {
    if (self.reaction == nil) {
        self.reaction = [[LLReactionManager alloc] init];
    }
    self.reaction.event = action;
    [self addTarget:self.reaction action:@selector(btnDown:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self.reaction action:@selector(btnDownRepeat:) forControlEvents:UIControlEventTouchDownRepeat];
    [self addTarget:self.reaction action:@selector(btnDragInside:) forControlEvents:UIControlEventTouchDragInside];
    [self addTarget:self.reaction action:@selector(btnDragOutside:) forControlEvents:UIControlEventTouchDragOutside];
    [self addTarget:self.reaction action:@selector(btnDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
    [self addTarget:self.reaction action:@selector(btnDragExit:) forControlEvents:UIControlEventTouchDragExit];
    [self addTarget:self.reaction action:@selector(btnUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self.reaction action:@selector(btnUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self addTarget:self.reaction action:@selector(btnCancel:) forControlEvents:UIControlEventTouchCancel];
}

@end

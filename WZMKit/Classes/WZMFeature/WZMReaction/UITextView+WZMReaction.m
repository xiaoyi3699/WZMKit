//
//  UITextView+WZMReaction.m
//  LLCommonStatic
//
//  Created by WangZhaomeng on 2019/6/25.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import "UITextView+WZMReaction.h"
#import "NSObject+WZMReaction.h"

@implementation UITextView (WZMReaction)

//开始、结束、编辑
- (void)wzm_executeInput:(textViewInputAction)action {
    if (self.reaction == nil) {
        self.reaction = [[WZMReactionManager alloc] init];
        self.delegate = self.reaction;
    }
    self.reaction.textViewInput = action;
}

//是否允许begin、end、return
- (void)wzm_executeShould:(textViewShouldAction)action {
    if (self.reaction == nil) {
        self.reaction = [[WZMReactionManager alloc] init];
        self.delegate = self.reaction;
    }
    self.reaction.textViewShould = action;
}

//是否允许改变文字
- (void)wzm_executeShouldChange:(textViewShouldChangeAction)action {
    if (self.reaction == nil) {
        self.reaction = [[WZMReactionManager alloc] init];
        self.delegate = self.reaction;
    }
    self.reaction.textViewShouldChange = action;
}

@end

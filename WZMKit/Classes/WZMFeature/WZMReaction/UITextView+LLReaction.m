//
//  UITextView+LLReaction.m
//  LLCommonStatic
//
//  Created by WangZhaomeng on 2019/6/25.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import "UITextView+LLReaction.h"
#import "NSObject+LLReaction.h"

@implementation UITextView (LLReaction)

//开始、结束、编辑
- (void)ll_executeInput:(textViewInputAction)action {
    if (self.reaction == nil) {
        self.reaction = [[LLReactionManager alloc] init];
        self.delegate = self.reaction;
    }
    self.reaction.textViewInput = action;
}

//是否允许begin、end、return
- (void)ll_executeShould:(textViewShouldAction)action {
    if (self.reaction == nil) {
        self.reaction = [[LLReactionManager alloc] init];
        self.delegate = self.reaction;
    }
    self.reaction.textViewShould = action;
}

//是否允许改变文字
- (void)ll_executeShouldChange:(textViewShouldChangeAction)action {
    if (self.reaction == nil) {
        self.reaction = [[LLReactionManager alloc] init];
        self.delegate = self.reaction;
    }
    self.reaction.textViewShouldChange = action;
}

@end

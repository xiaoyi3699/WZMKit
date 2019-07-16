//
//  UITextField+LLReaction.m
//  LLCommonStatic
//
//  Created by WangZhaomeng on 2019/6/25.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import "UITextField+LLReaction.h"
#import "NSObject+LLReaction.h"

@implementation UITextField (LLReaction)

//开始、结束、编辑
- (void)ll_executeInput:(textFieldInputAction)action {
    if (self.reaction == nil) {
        self.reaction = [[LLReactionManager alloc] init];
        self.delegate = self.reaction;
    }
    self.reaction.textFieldInput = action;
    [self.reaction addObserverWithName:UITextFieldTextDidChangeNotification sel:@selector(textFieldDidChange:) obj:self];
}

//是否允许begin、end、clear、return
- (void)ll_executeShould:(textFieldShouldAction)action {
    if (self.reaction == nil) {
        self.reaction = [[LLReactionManager alloc] init];
        self.delegate = self.reaction;
    }
    self.reaction.textFieldShould = action;
}

//是否允许改变文字
- (void)ll_executeShouldChange:(textFieldShouldChangeAction)action {
    if (self.reaction == nil) {
        self.reaction = [[LLReactionManager alloc] init];
        self.delegate = self.reaction;
    }
    self.reaction.textFieldShouldChange = action;
}

@end

//
//  UITextField+WZMReaction.m
//  WZMCommonStatic
//
//  Created by WangZhaomeng on 2019/6/25.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import "UITextField+WZMReaction.h"
#import "NSObject+WZMReaction.h"

@implementation UITextField (WZMReaction)

//开始、结束、编辑
- (void)wzm_executeInput:(textFieldInputAction)action {
    if (self.reaction == nil) {
        self.reaction = [[WZMReactionManager alloc] init];
        self.delegate = self.reaction;
    }
    self.reaction.textFieldInput = action;
    [self.reaction addObserverWithName:UITextFieldTextDidChangeNotification sel:@selector(textFieldDidChange:) obj:self];
}

//是否允许begin、end、clear、return
- (void)wzm_executeShould:(textFieldShouldAction)action {
    if (self.reaction == nil) {
        self.reaction = [[WZMReactionManager alloc] init];
        self.delegate = self.reaction;
    }
    self.reaction.textFieldShould = action;
}

//是否允许改变文字
- (void)wzm_executeShouldChange:(textFieldShouldChangeAction)action {
    if (self.reaction == nil) {
        self.reaction = [[WZMReactionManager alloc] init];
        self.delegate = self.reaction;
    }
    self.reaction.textFieldShouldChange = action;
}

@end

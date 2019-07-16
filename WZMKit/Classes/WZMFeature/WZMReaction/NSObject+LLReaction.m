//
//  NSObject+LLReaction.m
//  LLCommonStatic
//
//  Created by WangZhaomeng on 2019/6/24.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import "NSObject+LLReaction.h"
#import <objc/runtime.h>

@implementation NSObject (LLReaction)
static NSString *_reactionKey = @"reaction";

- (void)setReaction:(LLReactionManager *)reaction {
    objc_setAssociatedObject(self, &_reactionKey, reaction, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (LLReactionManager *)reaction {
    return objc_getAssociatedObject(self, &_reactionKey);
}

- (void)setNextAction:(nextAction)nextAction {
    if (self.reaction == nil) {
        self.reaction = [[LLReactionManager alloc] init];
    }
    self.reaction.next = nextAction;
}

- (nextAction)nextAction {
    if (self.reaction == nil) return nil;
    return self.reaction.next;
}

- (void)ll_executeReaction:(id)param {
    if (self.reaction.next) {
        self.reaction.next(param);
    }
}

@end

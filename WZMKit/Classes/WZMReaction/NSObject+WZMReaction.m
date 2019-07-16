//
//  NSObject+WZMReaction.m
//  WZMCommonStatic
//
//  Created by WangZhaomeng on 2019/6/24.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import "NSObject+WZMReaction.h"
#import <objc/runtime.h>

@implementation NSObject (WZMReaction)
static NSString *_reactionKey = @"reaction";

- (void)setReaction:(WZMReactionManager *)reaction {
    objc_setAssociatedObject(self, &_reactionKey, reaction, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (WZMReactionManager *)reaction {
    return objc_getAssociatedObject(self, &_reactionKey);
}

- (void)setNextAction:(nextAction)nextAction {
    if (self.reaction == nil) {
        self.reaction = [[WZMReactionManager alloc] init];
    }
    self.reaction.next = nextAction;
}

- (nextAction)nextAction {
    if (self.reaction == nil) return nil;
    return self.reaction.next;
}

- (void)wzm_executeReaction:(id)param {
    if (self.reaction.next) {
        self.reaction.next(param);
    }
}

@end

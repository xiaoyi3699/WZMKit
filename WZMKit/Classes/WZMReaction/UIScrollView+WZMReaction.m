//
//  UIScrollView+WZMReaction.m
//  Pods-WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/30.
//

#import "UIScrollView+WZMReaction.h"
#import "NSObject+WZMReaction.h"

@implementation UIScrollView (WZMReaction)

//滑动事件
- (void)wzm_executeScroll:(scrollAction)action {
    if (self.reaction == nil) {
        self.reaction = [[WZMReactionManager alloc] init];
        self.delegate = self.reaction;
    }
    self.reaction.scroll = action;
}

@end

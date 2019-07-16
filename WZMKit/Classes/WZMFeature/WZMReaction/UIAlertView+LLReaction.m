//
//  UIAlertView+LLReaction.m
//  LLCommonStatic
//
//  Created by WangZhaomeng on 2019/6/25.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import "UIAlertView+LLReaction.h"
#import "NSObject+LLReaction.h"

@implementation UIAlertView (LLReaction)

//alert事件
- (void)ll_executeAlert:(alertAction)action {
    if (self.reaction == nil) {
        self.reaction = [[LLReactionManager alloc] init];
        self.delegate = self.reaction;
    }
    self.reaction.alert = action;
}

@end

//
//  UIAlertView+WZMReaction.m
//  WZMCommonStatic
//
//  Created by WangZhaomeng on 2019/6/25.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import "UIAlertView+WZMReaction.h"
#import "NSObject+WZMReaction.h"

@implementation UIAlertView (WZMReaction)

//alert事件
- (void)wzm_executeAlert:(alertAction)action {
    if (self.reaction == nil) {
        self.reaction = [[WZMReactionManager alloc] init];
        self.delegate = self.reaction;
    }
    self.reaction.alert = action;
}

@end

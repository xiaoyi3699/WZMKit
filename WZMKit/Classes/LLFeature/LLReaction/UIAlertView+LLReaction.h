//
//  UIAlertView+LLReaction.h
//  LLCommonStatic
//
//  Created by WangZhaomeng on 2019/6/25.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLReactionManager.h"

@interface UIAlertView (LLReaction)

///alert事件
- (void)ll_executeAlert:(alertAction)action;

@end

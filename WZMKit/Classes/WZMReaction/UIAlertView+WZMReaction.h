//
//  UIAlertView+WZMReaction.h
//  WZMCommonStatic
//
//  Created by WangZhaomeng on 2019/6/25.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMDefined.h"
#if WZM_APP
#import "WZMReactionManager.h"

@interface UIAlertView (WZMReaction)

///alert事件
- (void)wzm_executeAlert:(alertAction)action;

@end
#endif

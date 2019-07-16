//
//  UITextView+WZMReaction.h
//  LLCommonStatic
//
//  Created by WangZhaomeng on 2019/6/25.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMReactionManager.h"

@interface UITextView (WZMReaction)

///开始、结束、编辑
- (void)wzm_executeInput:(textViewInputAction)action;

//是否允许begin、end、return
- (void)wzm_executeShould:(textViewShouldAction)action;

//是否允许改变文字
- (void)wzm_executeShouldChange:(textViewShouldChangeAction)action;

@end

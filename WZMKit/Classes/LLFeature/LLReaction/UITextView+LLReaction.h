//
//  UITextView+LLReaction.h
//  LLCommonStatic
//
//  Created by WangZhaomeng on 2019/6/25.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLReactionManager.h"

@interface UITextView (LLReaction)

///开始、结束、编辑
- (void)ll_executeInput:(textViewInputAction)action;

//是否允许begin、end、return
- (void)ll_executeShould:(textViewShouldAction)action;

//是否允许改变文字
- (void)ll_executeShouldChange:(textViewShouldChangeAction)action;

@end

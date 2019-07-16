//
//  UITextField+WZMReaction.h
//  WZMCommonStatic
//
//  Created by WangZhaomeng on 2019/6/25.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMReactionManager.h"

@interface UITextField (WZMReaction)

///开始、结束、编辑
- (void)wzm_executeInput:(textFieldInputAction)action;

///是否允许begin、end、clear、return
- (void)wzm_executeShould:(textFieldShouldAction)action;

///是否允许改变文字
- (void)wzm_executeShouldChange:(textFieldShouldChangeAction)action;

@end

//
//  NSObject+LLReaction.h
//  LLCommonStatic
//
//  Created by WangZhaomeng on 2019/6/24.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLReactionManager.h"

@interface NSObject (LLReaction)

- (void)setReaction:(LLReactionManager *)reaction;
- (LLReactionManager *)reaction;

- (void)setNextAction:(nextAction)nextAction;
- (nextAction)nextAction;

- (void)ll_executeReaction:(id)param;

@end

//
//  UIView+LLReaction.m
//  LLCommonStatic
//
//  Created by WangZhaomeng on 2019/6/24.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import "UIView+LLReaction.h"
#import "NSObject+LLReaction.h"

@implementation UIView (LLReaction)

//view只添加一种手势
- (void)ll_executeGesture:(LLGestureRecognizerType)type action:(nextAction)action {
    if (self.reaction == nil) {
        self.reaction = [[LLReactionManager alloc] init];
    }
    self.reaction.next = action;
    if (type == LLGestureRecognizerTypeSingle) {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self.reaction action:@selector(gestureRecognizer:)];
        gesture.numberOfTapsRequired = 1;
        [self addGestureRecognizer:gesture];
    }
    else if (type == LLGestureRecognizerTypeDouble) {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self.reaction action:@selector(gestureRecognizer:)];
        gesture.numberOfTapsRequired = 2;
        [self addGestureRecognizer:gesture];
    }
    else if (type == LLGestureRecognizerTypeLong) {
        UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self.reaction action:@selector(gestureRecognizer:)];
        [self addGestureRecognizer:gesture];
    }
}

//view添加多种手势, 在回调中判断手势类型
- (void)ll_executeGesture:(gestureAction)action {
    if (self.reaction == nil) {
        self.reaction = [[LLReactionManager alloc] init];
    }
    self.reaction.gesture = action;
    UITapGestureRecognizer *singleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.reaction action:@selector(singleGestureRecognizer:)];
    singleGesture.numberOfTapsRequired = 1;
    [self addGestureRecognizer:singleGesture];
    
    UITapGestureRecognizer *doubleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.reaction action:@selector(doubleGestureRecognizer:)];
    doubleGesture.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleGesture];
    
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self.reaction action:@selector(longGestureRecognizer:)];
    [self addGestureRecognizer:longGesture];
    
    [singleGesture requireGestureRecognizerToFail:doubleGesture];
    [singleGesture requireGestureRecognizerToFail:longGesture];
}

@end

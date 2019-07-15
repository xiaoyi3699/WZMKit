//
//  UIScrollView+LLAddPart.m
//  LLFeatureStatic
//
//  Created by WangZhaomeng on 2018/3/15.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import "UIScrollView+LLAddPart.h"

@implementation UIScrollView (LLAddPart)

- (void)ll_scrollsToTopAnimated:(BOOL)animated {
    [self setContentOffset:CGPointMake(0, 0) animated:animated];
}

- (void)ll_scrollsToBottomAnimated:(BOOL)animated {
    CGFloat offset = self.contentSize.height - self.bounds.size.height;
    if (offset > 0) {
        [self setContentOffset:CGPointMake(0, offset) animated:animated];
    }
}

@end

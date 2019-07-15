//
//  UITableView+LLAddPart.m
//  LLFoundation
//
//  Created by wangzhaomeng on 16/8/18.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "UITableView+LLAddPart.h"

@implementation UITableView (LLAddPart)

- (void)ll_cleraExtraLine{
    self.tableFooterView = [UIView new];
}

- (BOOL)ll_isCompletelyAppearWithIndexPath:(NSIndexPath *)indexPath {
    CGRect cellRect = [self rectForRowAtIndexPath:indexPath];
    return CGRectContainsRect(self.bounds, cellRect);
}

- (BOOL)ll_isAppearWithIndexPath:(NSIndexPath *)indexPath {
    CGRect cellRect = [self rectForRowAtIndexPath:indexPath];
    return CGRectIntersectsRect(self.bounds, cellRect);
}

@end

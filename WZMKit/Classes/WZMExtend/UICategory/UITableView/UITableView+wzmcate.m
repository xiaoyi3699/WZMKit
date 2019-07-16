//
//  UITableView+wzmcate.m
//  WZMFoundation
//
//  Created by wangzhaomeng on 16/8/18.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "UITableView+wzmcate.h"

@implementation UITableView (wzmcate)

- (void)wzm_cleraExtraLine{
    self.tableFooterView = [UIView new];
}

- (BOOL)wzm_isCompletelyAppearWithIndexPath:(NSIndexPath *)indexPath {
    CGRect cellRect = [self rectForRowAtIndexPath:indexPath];
    return CGRectContainsRect(self.bounds, cellRect);
}

- (BOOL)wzm_isAppearWithIndexPath:(NSIndexPath *)indexPath {
    CGRect cellRect = [self rectForRowAtIndexPath:indexPath];
    return CGRectIntersectsRect(self.bounds, cellRect);
}

@end

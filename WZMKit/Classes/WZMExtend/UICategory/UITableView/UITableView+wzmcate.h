//
//  UITableView+wzmcate.h
//  LLFoundation
//
//  Created by wangzhaomeng on 16/8/18.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (wzmcate)

/**
 清除tableView上多余的分割线
 */
- (void)wzm_cleraExtraLine;

///完全出现
- (BOOL)wzm_isCompletelyAppearWithIndexPath:(NSIndexPath *)indexPath;

///出现
- (BOOL)wzm_isAppearWithIndexPath:(NSIndexPath *)indexPath;

@end

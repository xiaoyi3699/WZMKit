//
//  WZMSubViewController.h
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2020/5/28.
//  Copyright © 2020 wangzhaomeng. All rights reserved.
//

#import "WZMPullListViewController.h"
@class WZMSegmentedViewController;

@interface WZMSubViewController : WZMPullListViewController

@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) NSInteger fixedHeight;
@property (nonatomic, weak) WZMSegmentedViewController *superViewController;

///视图将要出现
- (void)didDisplay;

@end

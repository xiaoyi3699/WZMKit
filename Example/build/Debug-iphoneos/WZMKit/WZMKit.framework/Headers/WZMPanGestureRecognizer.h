//
//  WZMPanGestureRecognizer.h
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/21.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMEnum.h"

@interface WZMPanGestureRecognizer : UIPanGestureRecognizer 

///横向纵向
@property (nonatomic, assign) WZMPanGestureRecognizerDirection direction;
///上下
@property (nonatomic, assign) WZMPanGestureRecognizerVerticalDirection verticalDirection;
///左右
@property (nonatomic, assign) WZMPanGestureRecognizerHorizontalDirection horizontalDirection;

@end

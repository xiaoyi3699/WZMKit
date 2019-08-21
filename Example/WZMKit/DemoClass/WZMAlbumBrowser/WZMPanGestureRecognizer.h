//
//  WZMPanGestureRecognizer.h
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/21.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSInteger {
    WZMPanGestureRecognizerDirectionVertical,
    WZMPanGestureRecognizerDirectionHorizontal
} WZMPanGestureRecognizerDirection;

@interface WZMPanGestureRecognizer : UIPanGestureRecognizer 

@property (nonatomic, assign) WZMPanGestureRecognizerDirection direction;

@end

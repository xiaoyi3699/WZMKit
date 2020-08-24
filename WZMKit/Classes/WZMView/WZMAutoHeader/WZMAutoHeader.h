//
//  WZMAutoHeader.h
//  WZMKit
//
//  Created by WangZhaomeng on 2017/10/17.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMEnum.h"

@interface WZMAutoHeader : UIView

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGRect imageFrame;
@property (nonatomic, assign) WZMAutoHeaderAnimation animation;

@end


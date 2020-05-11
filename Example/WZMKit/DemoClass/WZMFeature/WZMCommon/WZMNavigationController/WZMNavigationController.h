//
//  WZMNavigationController.h
//  LLFeature
//
//  Created by WangZhaomeng on 2017/9/21.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMScreenShotView.h"
#import "UINavigationController+wzmnav.h"
#import "WZMNavigationPopProtocol.h"

@interface UIViewController (WZMNavigationPop) <WZMNavigationPopProtocol>

@end

@interface WZMNavigationController : UINavigationController

@end

//
//  UINavigationController+LLAddPart.h
//  LLFoundation
//
//  Created by wangzhaomeng on 16/10/13.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLNavigationPopProtocol.h"

@interface UIViewController (LLNavigationPop) <LLNavigationPopProtocol>

@end

@interface UINavigationController (LLAddPart)

//是否隐藏导航栏线条
- (void)setNavLineHidden:(BOOL)navLineHidden;
- (BOOL)navLineHidden;

@end

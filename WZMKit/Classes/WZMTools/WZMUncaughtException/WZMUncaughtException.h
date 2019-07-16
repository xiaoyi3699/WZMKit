//
//  WZMUncaughtException.h
//  WZMKit
//
//  Created by WangZhaomeng on 2018/2/11.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZMUncaughtException : NSObject

void WZMInstallUncaughtExceptionHandler(void);

void WZMUninstall(void);

@end

//
//  WZMAppScore.h
//  WZMCommonStatic
//
//  Created by WangZhaomeng on 2018/5/22.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMEnum.h"

@interface WZMAppScore : NSObject

+ (instancetype)shareScore;
- (void)showScoreView:(WZMAppScoreType)type isOnce:(BOOL)isOnce;

@end

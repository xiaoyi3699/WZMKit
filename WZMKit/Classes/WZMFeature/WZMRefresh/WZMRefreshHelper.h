//
//  WZMRefreshHelper.h
//  LLFeature
//
//  Created by WangZhaomeng on 2017/10/25.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZMMacro.h"

#define WZMRefreshHeaderHeight 60
#define WZMRefreshFooterHeight 60
#define LL_REFRESH_COLOR      R_G_B(50, 50, 50)
#define LL_TIME_COLOR         R_G_B(50, 50, 50)
#define LL_REFRESH_FONT       [UIFont boldSystemFontOfSize:13]
#define LL_TIME_FONT          [UIFont boldSystemFontOfSize:13]
#define LL_TRANS_FORM CATransform3DConcat(CATransform3DIdentity, CATransform3DMakeRotation(M_PI+0.000001, 0, 0, 1))

extern NSString *const WZMRefreshMoreData;
extern NSString *const WZMRefreshHeaderTime;
extern NSString *const WZMRefreshKeyPathPanState;
extern NSString *const WZMRefreshKeyPathContentSize;
extern NSString *const WZMRefreshKeyPathContentOffset;

/** 刷新控件的状态 */
typedef NS_ENUM(NSInteger, WZMRefreshState) {
    
    WZMRefreshStateNormal          = 0, //普通状态
    WZMRefreshStateWiWZMRefresh,         //松开就刷新的状态
    WZMRefreshStateRefreshing,          //正在刷新中的状态
    WZMRefreshStateNoMoreData           //没有更多的数据
};

@interface WZMRefreshHelper : NSObject

/** 获取上次更新时间 */
+ (NSString *)LL_getRefreshTime:(NSString *)key;

/** 重置更新时间 */
+ (void)LL_setRefreshTime:(NSString *)key;

/** 箭头 */
+ (UIImage *)LL_ArrowImage;

@end

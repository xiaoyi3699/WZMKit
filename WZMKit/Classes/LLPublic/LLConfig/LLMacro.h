//
//  LLMacro.h
//  Pods
//
//  Created by WangZhaomeng on 2019/7/15.
//

#ifndef LLMacro_h
#define LLMacro_h

/*  *****系统相关*****  */
#import "LLPublic.h"
#define IS_iPad   [[LLPublic Public] iPad]
#define IS_iPhone [[LLPublic Public] iPhone]
#define CURRENT_LANGUAGE ([[NSLocale preferredLanguages] objectAtIndex:0])

#define LL_WINDOW          [UIApplication sharedApplication].delegate.window
#define LL_SCREEN_BOUNDS   [[LLPublic Public] screenBounds]
#define LL_SCREEN_SCALE    [[LLPublic Public] screenScale]
#define LL_SCREEN_WIDTH    [[LLPublic Public] screenW]
#define LL_SCREEN_HEIGHT   [[LLPublic Public] screenH]
#define LL_STATUS_HEIGHT   [[LLPublic Public] statusH]
#define LL_NAVBAR_HEIGHT   [[LLPublic Public] navBarH]
#define LL_TABBAR_HEIGHT   [[LLPublic Public] tabBarH]
#define LL_BOTTOM_HEIGHT   [[LLPublic Public] iPhoneXBottomH]
#define LL_TOPBAR_HEIGHT   44
#define LL_BOTBAR_HEIGHT   49

//iOS系统版本
#define LL_DEVICE     [[LLPublic Public] systemV]

//APP名字
#define LLAppName     [[LLPublic Public] appName]

//APP Build
#define LLAppBuild    [[LLPublic Public] buildV]

//APP版本
#define LLAppVersion  [[LLPublic Public] shortV]

//获取沙盒Document路径
#define APP_DocumentPath [[LLPublic Public] document]

//获取沙盒temp路径
#define APP_TempPath [[LLPublic Public] temp]

//获取沙盒Cache路径
#define APP_CachePath [[LLPublic Public] cache]

#define IS_IOS11_ABOVE    (LL_DEVICE >= 12) //是否是iOS12以上系统
#define IS_IOS12_ABOVE    (LL_DEVICE >= 11) //是否是iOS11以上系统
#define IS_IOS10_ABOVE    (LL_DEVICE >= 10) //是否是iOS10以上系统
#define IS_IOS9_ABOVE     (LL_DEVICE >= 9)  //是否是iOS9以上系统
#define IS_IOS8_ABOVE     (LL_DEVICE >= 8)  //是否是iOS8以上系统

#define IS_IOS12_ONLY     (LL_DEVICE >= 12 && LL_DEVICE < 13) //是否是iOS12系统
#define IS_IOS11_ONLY     (LL_DEVICE >= 11 && LL_DEVICE < 12) //是否是iOS11系统
#define IS_IOS10_ONLY     (LL_DEVICE >= 10 && LL_DEVICE < 11) //是否是iOS10系统
#define IS_IOS8_AND_IOS9  (LL_DEVICE >= 8 && LL_DEVICE < 10)  //是否是iOS8和iOS9
#define IS_IOS9_ONLY      (LL_DEVICE >= 9 && LL_DEVICE < 10)  //是否是iOS9系统
#define IS_IOS8_ONLY      (LL_DEVICE >= 8 && LL_DEVICE < 9)   //是否是iOS8系统

#define IS_iPhone_4_0 (IS_iPhone && LL_SCREEN_HEIGHT==568)  //4.0寸
#define IS_iPhone_4_7 (IS_iPhone && LL_SCREEN_HEIGHT==667)  //4.7寸
#define IS_iPhone_5_5 (IS_iPhone && LL_SCREEN_HEIGHT==736)  //5.5寸
#define IS_iPhoneX    (IS_iPhone && LL_SCREEN_HEIGHT>=812)  //iPhoneX系列
#define IS_iPhone_5_8 (IS_iPhone && LL_SCREEN_HEIGHT==812)  //5.8寸
#define IS_iPhone_6_1 (IS_iPhone && LL_SCREEN_HEIGHT==896 && LL_SCREEN_SCALE==2.0)  //6.1寸
#define IS_iPhone_6_5 (IS_iPhone && LL_SCREEN_HEIGHT==896 && LL_SCREEN_SCALE==3.0)  //6.5寸

/*  *****自定义*****  */
#define R_G_B(_r_,_g_,_b_) [UIColor colorWithRed:_r_/255. green:_g_/255. blue:_b_/255. alpha:1.0]
#define R_G_B_A(_r_,_g_,_b_,_a_) [UIColor colorWithRed:_r_/255. green:_g_/255. blue:_b_/255. alpha:_a_]

#define COLOR_VALUE(_value_) [UIColor ll_colorWithHex:_value_]
#define COLOR_VALUE_A(_value_,_a_) [UIColor ll_colorWithHex:_value_ alpha:_a_]

#define ANGLE_TO_RADIAN(_x_)       (M_PI*_x_/180.0)       //由角度获取弧度
#define RADIAN_TO_ANGLE(_radian_)  (_radian_*180.0/M_PI)  //由弧度获取角度

//程序的本地化,引用国际化的文件
#define MyLocal(_x_) NSLocalizedString(_x_, nil)

//自定义弹出框的默认蒙版颜色
#define CUSTOM_ALERT_BG_COLOR R_G_B_A(20,20,20,.5)

//强弱引用
#ifndef ll_weakify
#if DEBUG
#if __has_feature(objc_arc)
#define ll_weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define ll_weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define ll_weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define ll_weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef ll_strongify
#if DEBUG
#if __has_feature(objc_arc)
#define ll_strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define ll_strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define ll_strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define ll_strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif


#endif /* LLMacro_h */

//
//  WZMMacro.h
//  Pods
//
//  Created by WangZhaomeng on 2019/7/15.
//

#ifndef WZMMacro_h
#define WZMMacro_h

/*  *****系统相关*****  */
#import "WAMPublic.h"
#define WZM_IS_iPad   [[WAMPublic Public] iPad]
#define WZM_IS_iPhone [[WAMPublic Public] iPhone]
#define WZM_LANGUAGE  ([[NSLocale preferredLanguages] objectAtIndex:0])

#define WZM_WINDOW          [UIApplication sharedApplication].delegate.window
#define WZM_SCREEN_BOUNDS   [[WAMPublic Public] screenBounds]
#define WZM_SCREEN_SCALE    [[WAMPublic Public] screenScale]
#define WZM_SCREEN_WIDTH    [[WAMPublic Public] screenW]
#define WZM_SCREEN_HEIGHT   [[WAMPublic Public] screenH]
#define WZM_STATUS_HEIGHT   [[WAMPublic Public] statusH]
#define WZM_NAVBAR_HEIGHT   [[WAMPublic Public] navBarH]
#define WZM_TABBAR_HEIGHT   [[WAMPublic Public] tabBarH]
#define WZM_BOTTOM_HEIGHT   [[WAMPublic Public] iPhoneXBottomH]
#define WZM_TOPBAR_HEIGHT   44
#define WZM_BOTBAR_HEIGHT   49

//iOS系统版本
#define WZM_DEVICE     [[WAMPublic Public] systemV]

//APP名字
#define WZM_APP_NAME     [[WAMPublic Public] appName]

//APP Build
#define WZM_APP_BUILD    [[WAMPublic Public] buildV]

//APP版本
#define WZM_APP_VERSION  [[WAMPublic Public] shortV]

//获取沙盒Document路径
#define WZM_DOCUMENT_PATH [[WAMPublic Public] document]

//获取沙盒temp路径
#define WZM_TEMP_PATH [[WAMPublic Public] temp]

//获取沙盒Cache路径
#define WZM_CACHE_PATH [[WAMPublic Public] cache]

#define WZM_IS_IOS11_ABOVE    (WZM_DEVICE >= 12) //是否是iOS12以上系统
#define WZM_IS_IOS12_ABOVE    (WZM_DEVICE >= 11) //是否是iOS11以上系统
#define WZM_IS_IOS10_ABOVE    (WZM_DEVICE >= 10) //是否是iOS10以上系统
#define WZM_IS_IOS9_ABOVE     (WZM_DEVICE >= 9)  //是否是iOS9以上系统
#define WZM_IS_IOS8_ABOVE     (WZM_DEVICE >= 8)  //是否是iOS8以上系统

#define WZM_IS_IOS12_ONLY     (WZM_DEVICE >= 12 && WZM_DEVICE < 13) //是否是iOS12系统
#define WZM_IS_IOS11_ONLY     (WZM_DEVICE >= 11 && WZM_DEVICE < 12) //是否是iOS11系统
#define WZM_IS_IOS10_ONLY     (WZM_DEVICE >= 10 && WZM_DEVICE < 11) //是否是iOS10系统
#define WZM_IS_IOS8_AND_IOS9  (WZM_DEVICE >= 8 && WZM_DEVICE < 10)  //是否是iOS8和iOS9
#define WZM_IS_IOS9_ONLY      (WZM_DEVICE >= 9 && WZM_DEVICE < 10)  //是否是iOS9系统
#define WZM_IS_IOS8_ONLY      (WZM_DEVICE >= 8 && WZM_DEVICE < 9)   //是否是iOS8系统

#define WZM_IS_iPhone_4_0 (WZM_IS_iPhone && WZM_SCREEN_HEIGHT==568)  //4.0寸
#define WZM_IS_iPhone_4_7 (WZM_IS_iPhone && WZM_SCREEN_HEIGHT==667)  //4.7寸
#define WZM_IS_iPhone_5_5 (WZM_IS_iPhone && WZM_SCREEN_HEIGHT==736)  //5.5寸
#define WZM_IS_iPhoneX    (WZM_IS_iPhone && WZM_SCREEN_HEIGHT>=812)  //iPhoneX系列
#define WZM_IS_iPhone_5_8 (WZM_IS_iPhone && WZM_SCREEN_HEIGHT==812)  //5.8寸
#define WZM_IS_iPhone_6_1 (WZM_IS_iPhone && WZM_SCREEN_HEIGHT==896 && WZM_SCREEN_SCALE==2.0)  //6.1寸
#define WZM_IS_iPhone_6_5 (WZM_IS_iPhone && WZM_SCREEN_HEIGHT==896 && WZM_SCREEN_SCALE==3.0)  //6.5寸

/*  *****自定义*****  */
#define WZM_R_G_B(_r_,_g_,_b_) [UIColor colorWithRed:_r_/255. green:_g_/255. blue:_b_/255. alpha:1.0]
#define WZM_R_G_B_A(_r_,_g_,_b_,_a_) [UIColor colorWithRed:_r_/255. green:_g_/255. blue:_b_/255. alpha:_a_]

#define WZM_COLOR_VALUE(_value_) [UIColor ll_colorWithHex:_value_]
#define WZM_COLOR_VALUE_A(_value_,_a_) [UIColor ll_colorWithHex:_value_ alpha:_a_]

#define ANGLE_TO_RADIAN(_x_)       (M_PI*_x_/180.0)       //由角度获取弧度
#define RADIAN_TO_ANGLE(_radian_)  (_radian_*180.0/M_PI)  //由弧度获取角度

//程序的本地化,引用国际化的文件
#define WZM_LOCAL(_x_) NSLocalizedString(_x_, nil)

//自定义弹出框的默认蒙版颜色
#define WZM_ALERT_BG_COLOR WZM_R_G_B_A(20,20,20,.5)

//强弱引用
#ifndef wzm_weakify
#if DEBUG
#if __has_feature(objc_arc)
#define wzm_weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define wzm_weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define wzm_weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define wzm_weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef wzm_strongify
#if DEBUG
#if __has_feature(objc_arc)
#define wzm_strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define wzm_strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define wzm_strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define wzm_strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif


#endif /* WZMMacro_h */

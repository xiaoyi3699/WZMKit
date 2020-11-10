//
//  WZMMacro.h
//  Pods
//
//  Created by WangZhaomeng on 2019/7/15.
//

#ifndef WZMMacro_h
#define WZMMacro_h

/*  *****系统相关*****  */
#import "WZMPublic.h"
#define WZM_IS_iPad   [[WZMPublic sharePublic] iPad]
#define WZM_IS_iPhone [[WZMPublic sharePublic] iPhone]
#define WZM_LANGUAGE  ([[NSLocale preferredLanguages] objectAtIndex:0])

#define WZM_SCREEN_BOUNDS   [[WZMPublic sharePublic] screenBounds]
#define WZM_SCREEN_SCALE    [[WZMPublic sharePublic] screenScale]
#define WZM_SCREEN_WIDTH    [[WZMPublic sharePublic] screenW]
#define WZM_SCREEN_HEIGHT   [[WZMPublic sharePublic] screenH]
#define WZM_STATUS_HEIGHT   [[WZMPublic sharePublic] statusH]
#define WZM_NAVBAR_HEIGHT   [[WZMPublic sharePublic] navBarH]
#define WZM_TABBAR_HEIGHT   [[WZMPublic sharePublic] tabBarH]
#define WZM_BOTTOM_HEIGHT   [[WZMPublic sharePublic] iPhoneXBottomH]
#define WZM_TOPBAR_HEIGHT   44
#define WZM_BOTBAR_HEIGHT   49

//iOS系统版本
#define WZM_DEVICE     [[WZMPublic sharePublic] systemV]

//是否是暗黑模式
#define APP_IS_DARK (WZM_DEVICE >= 13.0 && [UIScreen mainScreen].traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark)

//APP名字
#define WZM_APP_NAME     [[WZMPublic sharePublic] appName]

//APP Build
#define WZM_APP_BUILD    [[WZMPublic sharePublic] buildV]

//APP版本
#define WZM_APP_VERSION  [[WZMPublic sharePublic] shortV]

//获取沙盒Document路径
#define WZM_DOCUMENT_PATH [[WZMPublic sharePublic] document]

//获取沙盒temp路径
#define WZM_TEMP_PATH [[WZMPublic sharePublic] temp]

//获取沙盒Cache路径
#define WZM_CACHE_PATH [[WZMPublic sharePublic] cache]

#define WZM_IS_IOS13_ABOVE    (WZM_DEVICE >= 13) //是否是iOS13以上系统
#define WZM_IS_IOS12_ABOVE    (WZM_DEVICE >= 12) //是否是iOS12以上系统
#define WZM_IS_IOS11_ABOVE    (WZM_DEVICE >= 11) //是否是iOS11以上系统
#define WZM_IS_IOS10_ABOVE    (WZM_DEVICE >= 10) //是否是iOS10以上系统
#define WZM_IS_IOS9_ABOVE     (WZM_DEVICE >= 9)  //是否是iOS9以上系统
#define WZM_IS_IOS8_ABOVE     (WZM_DEVICE >= 8)  //是否是iOS8以上系统

#define WZM_IS_IOS12_ONLY     (WZM_DEVICE >= 12 && WZM_DEVICE < 13) //是否是iOS12系统
#define WZM_IS_IOS11_ONLY     (WZM_DEVICE >= 11 && WZM_DEVICE < 12) //是否是iOS11系统
#define WZM_IS_IOS10_ONLY     (WZM_DEVICE >= 10 && WZM_DEVICE < 11) //是否是iOS10系统
#define WZM_IS_IOS8_AND_IOS9  (WZM_DEVICE >= 8 && WZM_DEVICE < 10)  //是否是iOS8和iOS9
#define WZM_IS_IOS9_ONLY      (WZM_DEVICE >= 9 && WZM_DEVICE < 10)  //是否是iOS9系统
#define WZM_IS_IOS8_ONLY      (WZM_DEVICE >= 8 && WZM_DEVICE < 9)   //是否是iOS8系统

//4.7寸 2X 6/6s 7 8 SE2代 375x667pt 1334x750px
#define WZM_IS_iPhone_4_7 (WZM_IS_iPhone && WZM_SCREEN_HEIGHT==667)
//5.5寸 3x 6P/6sP 7P 8P 414x736pt 1242x2208px
#define WZM_IS_iPhone_5_5 (WZM_IS_iPhone && WZM_SCREEN_HEIGHT==736)
//iPhoneX系列
#define WZM_IS_iPhoneX    (WZM_IS_iPhone && WZM_SCREEN_HEIGHT>=812)
//5.4寸 3x 12mini 375x812pt 1125x2436px
#define WZM_IS_iPhone_5_4 (WZM_IS_iPhone && WZM_SCREEN_HEIGHT==812)
//5.8寸 3x X/XS/11Pro 375x812pt 1125x2436px
#define WZM_IS_iPhone_5_8 (WZM_IS_iPhone && WZM_SCREEN_HEIGHT==812)
//6.1寸 2x XR/11 414x896pt 828x1792px
#define WZM_IS_iPhone_6_1_2 (WZM_IS_iPhone && WZM_SCREEN_HEIGHT==896 && WZM_SCREEN_SCALE==2.0)
//6.1寸 3x 12 390x842pt 2532x1170px
#define WZM_IS_iPhone_6_1_3 (WZM_IS_iPhone && WZM_SCREEN_HEIGHT==896 && WZM_SCREEN_SCALE==2.0)
//6.5寸 3x XS MAX/11ProMAX 414x896pt 1242x2688px
#define WZM_IS_iPhone_6_5 (WZM_IS_iPhone && WZM_SCREEN_HEIGHT==896 && WZM_SCREEN_SCALE==3.0)
//6.7寸 3x 12ProMax 428x926pt 1284x2778px
#define WZM_IS_iPhone_6_7 (WZM_IS_iPhone && WZM_SCREEN_HEIGHT==896 && WZM_SCREEN_SCALE==3.0)

/*  *****自定义*****  */
#define WZM_R_G_B(_r_,_g_,_b_) [UIColor colorWithRed:_r_/255. green:_g_/255. blue:_b_/255. alpha:1.0]
#define WZM_R_G_B_A(_r_,_g_,_b_,_a_) [UIColor colorWithRed:_r_/255. green:_g_/255. blue:_b_/255. alpha:_a_]

#define WZM_COLOR_VALUE(_value_) [UIColor wzm_getColorByHex:_value_]
#define WZM_COLOR_VALUE_A(_value_,_a_) [UIColor wzm_getColorByHex:_value_ alpha:_a_]

#define ANGLE_TO_RADIAN(_x_)       (M_PI*_x_/180.0)       //由角度获取弧度
#define RADIAN_TO_ANGLE(_radian_)  (_radian_*180.0/M_PI)  //由弧度获取角度

//程序的本地化,引用国际化的文件
#define WZM_LOCAL(_x_) NSLocalizedString(_x_, nil)

//自定义弹出框的默认蒙版颜色
#define WZM_ALERT_BG_COLOR WZM_R_G_B_A(20,20,20,.5)

//项目相关
#define WZM_APP_ID  @"123456789"
#define WZM_DARK_COLOR [UIColor colorWithRed:25.5/255.0 green:25.5/255.0 blue:25.5/255.0 alpha:1.0]
#define WZM_THEME_COLOR [UIColor colorWithRed:66.0/255.0 green:152.0/255.0 blue:233.0/255.0 alpha:1.0]

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

//
//  LLDeviceUtil.h
//  LLFoundation
//
//  Created by wangzhaomeng on 16/8/17.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLBlock.h"

@interface LLDeviceUtil : NSObject

/**
 是否为越狱设备
 */
+ (BOOL)isPrisonBreakEquipment;

/**
 获取当前iOS版本
 */
+ (float)getDeviceSystemMajorVersion;

/**
 判断系统是否允许应用接收推送消息
 */
+ (BOOL)checkRemoteNotificationIsAllowed;

/**
 判断当前设备是否获取麦克风授权
 */
+ (void)checkMicrophoneEnableBlock:(doBlock)enable disableBlock:(doBlock)disable;

/**
 判断当前设备是否获取相册权限
 */
+ (BOOL)checkPhotosEnable;

/**
 判断当前设备是否获取相机权限
 */
+ (BOOL)checkCameraEnable;

/**
 判断当前设备是否获取定位权限
 */
+ (BOOL)checkLocationEnable;

/**
 判断是否有网络
 */
+ (BOOL)isConnectedToNetwork;

/**
 是否禁止锁屏
 */
+ (void)isLockScreenDisabled:(BOOL)disabled;

///CPU使用量
+ (CGFloat)ll_cpuUsage;

/**
 手机机型
 */
+ (NSString *)ll_deviceString;

/**
 获取mac地址
 */
+ (NSString *)ll_macAddress;

/**
 获取手机IP,如:192.168.1.133,需连网
 */
+ (NSString *)ll_IPAddress;

/**
 获取当前连接的WIFI名称
 */
+ (NSString *)ll_wifiSSID;

/**
 获取当前网络状态
 */
+ (NSString *)ll_netStatus;

@end

//
//  LLDeviceUtil.m
//  LLFoundation
//
//  Created by wangzhaomeng on 16/8/17.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "LLDeviceUtil.h"
#import "LLLog.h"
#import "LLAlertView.h"
#import <objc/runtime.h>
//麦克风
#import <AVFoundation/AVFoundation.h>
//相册
#import <AssetsLibrary/AssetsLibrary.h>
//定位需
#import <CoreLocation/CoreLocation.h>
//CPU使用量
#include <sys/sysctl.h>
#include <mach/mach.h>
//判断网络和获取ssid
#import <SystemConfiguration/CaptiveNetwork.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netdb.h>
//以下两个类是获取设备IP需要用
#import <ifaddrs.h>
#import <arpa/inet.h>
//以下一个类是获取iPhone型号需要用
#import "sys/utsname.h"


@implementation LLDeviceUtil

//是否为越狱
char* printEnv(void){
    char *env = getenv("DYLD_INSERT_LIBRARIES");
    ll_log(@"%s", env);
    return env;
}

+ (BOOL)isPrisonBreakEquipment{
    if (printEnv()) {
        ll_log(@"The device is jail broken!");
        return YES;
    }
    ll_log(@"The device is NOT jail broken!");
    return NO;
}

/**
 获取当前iOS版本
 */
+ (float)getDeviceSystemMajorVersion{
    return [[UIDevice currentDevice].systemVersion floatValue];
}

/**
 判断系统是否允许应用接收推送消息
 */
+ (BOOL)checkRemoteNotificationIsAllowed {
    if ([self getDeviceSystemMajorVersion] >= 8.0) {//iOS8
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone != setting.types) {
            return YES;
        }
    }
    else {//iOS7
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(UIRemoteNotificationTypeNone != type)
            return YES;
#pragma clang diagnostic pop
    }
    return NO;
}

/**
 判断当前设备是否获取麦克风授权
 */
+ (void)checkMicrophoneEnableBlock:(doBlock)enable disableBlock:(doBlock)disable{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (granted) {
                        if (enable) {
                            enable();
                        };
                    }
                    else {
                        [self showAlertViewWithAuthorization:@"麦克风"];
                        if (disable) {
                            disable();
                        }
                    }
                });
            }];
        }
    }
}

/**
 判断当前设备是否获取相册权限
 */
+ (BOOL)checkPhotosEnable{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){
        //无权限
        [self showAlertViewWithAuthorization:@"相册"];
        return NO;
    }
    return YES;
}

/**
 判断当前设备是否获取相机权限
 */
+ (BOOL)checkCameraEnable{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
        //无权限
        [self showAlertViewWithAuthorization:@"相机"];
        return NO;
    }
    return YES;
}

/**
 判断当前设备是否获取定位权限
 */
+ (BOOL)checkLocationEnable{
    //定位服务是否可用
    BOOL enable = [CLLocationManager locationServicesEnabled];
    //是否具有定位权限
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if(!enable || status == kCLAuthorizationStatusDenied){
        //无权限
        [self showAlertViewWithAuthorization:@"定位"];
        return NO;
    }
    return YES;
}

/**
 判断是否有网络
 */
+ (BOOL)isConnectedToNetwork {
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET6;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags){
        printf("Error. Could not recover network reachability flags\n");
        return NO;
    }
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}

+ (void)isLockScreenDisabled:(BOOL)disabled {
    [[UIApplication sharedApplication] setIdleTimerDisabled:disabled];
}

///CPU使用量
+ (CGFloat)ll_cpuUsage {
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    task_basic_info_t      basic_info;
    thread_array_t        thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t    thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0;
    
    basic_info = (task_basic_info_t)tinfo;
    
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    if (thread_count > 0)
        stat_thread += thread_count;
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;
    
    for (j = 0; j < (int)thread_count; j++)
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->user_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
    }
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    return tot_cpu;
}

/**
 机型
 */
+ (NSString *)ll_deviceString{
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

/**
 获取mac地址
 */
+ (NSString *)ll_macAddress {
    NSString *macAddress = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    macAddress = [[macAddress componentsSeparatedByString:@"-"] componentsJoinedByString:@""];
    return macAddress;
}

/**
 获取手机IP,如:192.168.1.133,需连网
 */
+ (NSString *)ll_IPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = nil;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == 2) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

/**
 获取当前连接的WIFI名称
 */
+ (NSString *)ll_wifiSSID {
    CFArrayRef arrayRef = CNCopySupportedInterfaces();
    NSArray *ifs = (__bridge id)arrayRef;
    if (arrayRef) {
        CFRelease(arrayRef);
    }
    for (NSString *ifnam in ifs){
        CFDictionaryRef dicRef = CNCopyCurrentNetworkInfo((__bridge  CFStringRef)ifnam);
        if (dicRef){
            NSDictionary *info = [(__bridge id)dicRef copy];
            CFRelease(dicRef);
            if ([info count]) {
                NSString *ssid  = [info objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
                NSString *bssid = [info objectForKey:(__bridge NSString *)kCNNetworkInfoKeyBSSID];
                ll_log(@"interfaceName:%@ ssid:%@ bssid:%@",ifnam,ssid,bssid);
                return ssid;
            }
        }
    }
    return nil;
}

/**
 获取当前网络状态
 */
+ (NSString *)ll_netStatus {
    
    NSArray *subviews = [[self ll_value:[UIApplication sharedApplication]] subviews];
    
    int type = 0;
    for (id view in subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            type = [[view valueForKeyPath:@"dataNetworkType"] intValue];
        }
    }
    switch (type) {
        case 1: return @"2G";
        case 2: return @"3G";
        case 3: return @"4G";
        case 5: return @"WIFI";
        default: return @"unknown";
    }
}

+ (id)ll_value:(id)value {
    unsigned int count = 0;
    Ivar *ivarLists = class_copyIvarList([value class], &count);
    for (int i = 0; i < count; i ++) {
        const char* name = ivar_getName(ivarLists[i]);
        NSString* strName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        
        if ([strName isEqualToString:@"_statusBar"]) {
            id statusBar = [value valueForKey:strName];
            return [self ll_value:statusBar];
        }
        if ([strName isEqualToString:@"_foregroundView"]) {
            return [value valueForKey:strName];
        }
    }
    free(ivarLists);
    return nil;
}

+ (void)showAlertViewWithAuthorization:(NSString *)text{
    NSString *message = [NSString stringWithFormat:@"请允许应用获取%@权限",text];
    LLAlertView *alertView = [[LLAlertView alloc] initWithTitle:@"提示"
                                                        message:message
                                                  OKButtonTitle:@"去设置"
                                              cancelButtonTitle:@"取消"
                                                           type:LLAlertViewTypeNormal];
    [alertView setOKBlock:^{
        [self openAPPSetting];
    }];
    [alertView showAnimated:YES];
}

+ (void)showAlertViewWithMessage:(NSString *)text{
    LLAlertView *alertView = [[LLAlertView alloc] initWithTitle:@"提示"
                                                        message:text
                                                  OKButtonTitle:@"确定"
                                              cancelButtonTitle:nil
                                                           type:LLAlertViewTypeNormal];
    [alertView showAnimated:YES];
}

+ (void)openAPPSetting{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end

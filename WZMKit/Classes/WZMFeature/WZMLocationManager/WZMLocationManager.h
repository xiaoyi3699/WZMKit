//
//  LLLocation.h
//  dingwei
//
//  Created by wangzhaomeng on 16/8/4.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@protocol WZMLocationManagerDelegate;

@interface WZMLocationManager : NSObject<CLLocationManagerDelegate>

@property (nonatomic, weak) id<WZMLocationManagerDelegate> delegate;

- (void)starLocation;
- (void)stopLocation;

@end

@protocol WZMLocationManagerDelegate <NSObject>
@optional
- (void)locationManager:(WZMLocationManager *)locationManager didUpdatePlace:(NSArray<NSDictionary *> *)places;
- (void)locationManager:(WZMLocationManager *)locationManager didFailWithError:(NSError *)error;

@end

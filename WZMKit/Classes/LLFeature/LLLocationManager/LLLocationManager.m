//
//  LLLocation.m
//  dingwei
//
//  Created by wangzhaomeng on 16/8/4.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "LLLocationManager.h"
#import "LLDeviceUtil.h"

@interface LLLocationManager ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSError *error;

@end

@implementation LLLocationManager

- (CLLocationManager *)locationManager {
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 10.0f;
    }
    return _locationManager;
}

- (NSError *)error {
    if (_error == nil) {
        NSString *domain = @"请开启定位权限";
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey:domain};
        _error = [NSError errorWithDomain:domain code:-101 userInfo:userInfo];
    }
    return _error;
}

#pragma mark - 定位
- (void)starLocation {
    if ([LLDeviceUtil checkLocationEnable]) {
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        [self.locationManager startUpdatingLocation];
    }
    else {
        if ([self.delegate respondsToSelector:@selector(locationManager:didFailWithError:)]) {
            [self.delegate locationManager:self didFailWithError:self.error];
        }
    }
}

- (void)stopLocation {
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate
//定位成功
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    [manager stopUpdatingLocation];
    CLLocation *newLocation = [locations lastObject];
    /**
     CLLocationCoordinate2D coordinate = newLocation.coordinate;
     float longitude = coordinate.longitude;//经度
     float latitude = coordinate.latitude;//纬度
     **/
    [self getCityFromLocation:newLocation];
}

//定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [manager stopUpdatingLocation];
    if ([self.delegate respondsToSelector:@selector(locationManager:didFailWithError:)]) {
        [self.delegate locationManager:self didFailWithError:error];
    }
}

#pragma mark - 根据location解析所在城市
- (void)getCityFromLocation:(CLLocation *)location{
    NSMutableArray *places = [[NSMutableArray alloc] initWithCapacity:0];
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        for (CLPlacemark *place in placemarks) {
            NSMutableDictionary *placeDic = [[NSMutableDictionary alloc] initWithCapacity:6];
            [placeDic setValue:place.name            forKey:@"name"];             //位置名
            [placeDic setValue:place.country         forKey:@"country"];          //国家
            [placeDic setValue:place.locality        forKey:@"locality"];         //市
            [placeDic setValue:place.subLocality     forKey:@"subLocality"];      //区
            [placeDic setValue:place.thoroughfare    forKey:@"thoroughfare"];     //街道
            [placeDic setValue:place.subThoroughfare forKey:@"subThoroughfare"];  //子街道
            [places addObject:placeDic];
        }
        if ([self.delegate respondsToSelector:@selector(locationManager:didUpdatePlace:)]) {
            [self.delegate locationManager:self didUpdatePlace:[places copy]];
        }
    }];
}

@end

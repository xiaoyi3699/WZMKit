//
//  MKMapView+WZMLocation.h
//  Pods-WZMKit_Example
//
//  Created by Zhaomeng Wang on 2020/5/25.
//

#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKMapView (WZMLocation)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate zoomLevel:(NSUInteger)zoomLevel animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END

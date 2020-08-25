//
//  MKMapView+WZMLocation.h
//  Pods-WZMKit_Example
//
//  Created by Zhaomeng Wang on 2020/5/25.
//

#import <MapKit/MapKit.h>

@interface MKMapView (WZMLocation)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate zoomLevel:(NSUInteger)zoomLevel animated:(BOOL)animated;

@end

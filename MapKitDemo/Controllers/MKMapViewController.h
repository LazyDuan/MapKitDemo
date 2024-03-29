//
//  MKMapViewController.h
//  MapKitDemo
//
//  Created by duan on 2024/3/28.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <Masonry/Masonry.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKMapViewController : UIViewController<CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic, strong) MKMapView *mapView;

@property (nonatomic, strong) UIButton *userLocationButton;

@property (nonatomic, strong) CLLocationManager *locationManager;

@property(nonatomic, assign) BOOL followUserLocation;

@property (nonatomic, assign) CLLocationCoordinate2D userCoordinate;

- (void)focusMapViewToLocation:(CLLocationCoordinate2D)coordinate;

@end

NS_ASSUME_NONNULL_END

//
//  MKOverlayViewController.h
//  MapKitDemo
//
//  Created by duan on 2024/3/28.
//

#import "MKMapViewController.h"
typedef NS_ENUM(NSInteger, MKOverlayType) {
    MKOverlayTypePolygon,
    MKOverlayTypeCircle,
    MKOverlayTypePolyline
};
NS_ASSUME_NONNULL_BEGIN

@interface MKOverlayViewController : MKMapViewController
@property(nonatomic, assign) MKOverlayType type;
@end

NS_ASSUME_NONNULL_END

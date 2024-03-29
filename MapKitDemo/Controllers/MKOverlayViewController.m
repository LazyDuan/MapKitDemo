//
//  MKOverlayViewController.m
//  MapKitDemo
//
//  Created by duan on 2024/3/28.
//

#import "MKOverlayViewController.h"


@interface MKOverlayViewController ()<CLLocationManagerDelegate, MKMapViewDelegate>

@end

@implementation MKOverlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)focusMapViewToLocation:(CLLocationCoordinate2D)coordinate {
    if (self.type == MKOverlayTypePolyline) {
        [self addPolylineOverlay:self.userCoordinate];
    }else if (self.type == MKOverlayTypeCircle) {
        [self addCircleOverlay:self.userCoordinate];
    }else if (self.type == MKOverlayTypePolygon) {
        [self addPolygonOverlay:self.userCoordinate];
    }
}

- (void)addPolylineOverlay:(CLLocationCoordinate2D)coordinate {
    CLLocationCoordinate2D *coor = malloc(sizeof(CLLocationCoordinate2D)*5);
    NSArray <NSNumber *>*latArray = @[@(0.0),@(0.03),@(0.0),@(0.03),@(0.0)];
    NSArray <NSNumber *>*lonArray = @[@(0.0),@(0.03),@(0.06),@(0.09),@(0.12)];
    for (int i=0; i<5; i++) {
        
        CLLocationCoordinate2D po = CLLocationCoordinate2DMake(coordinate.latitude + latArray[i].floatValue, coordinate.longitude + lonArray[i].floatValue);
        coor[i]=po;
    }
    //创建一个折线对象
    MKPolyline * line = [MKPolyline polylineWithCoordinates:coor count:5];
    [self.mapView addOverlay:line];
}

- (void)addCircleOverlay:(CLLocationCoordinate2D)coordinate {
    MKCircle * cirle = [MKCircle circleWithCenterCoordinate:coordinate radius:500];
    [self.mapView addOverlay:cirle];
}

- (void)addPolygonOverlay:(CLLocationCoordinate2D)coordinate {
    CLLocationCoordinate2D *coor = malloc(sizeof(CLLocationCoordinate2D)*6);
    NSArray <NSNumber *>*latArray = @[@(0.0),@(0.01),@(0.02),@(0.03),@(0.02),@(0.01)];
    NSArray <NSNumber *>*lonArray = @[@(0.0),@(0.03),@(0.03),@(0.0),@(-0.03),@(-0.03)];
    for (int i=0; i<=5; i++) {
        CLLocationCoordinate2D po = CLLocationCoordinate2DMake(coordinate.latitude + latArray[i].floatValue, coordinate.longitude + lonArray[i].floatValue);
        coor[i] = po;
    }

    MKPolygon * gon = [MKPolygon polygonWithCoordinates:coor count:6];
    [self.mapView addOverlay:gon];

}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    if ([overlay isKindOfClass:[MKCircle class]]) {
        MKCircleRenderer * render=[[MKCircleRenderer alloc] initWithCircle:overlay];
        //设置线宽
        render.lineWidth = 2;
        //填充颜色
        render.fillColor =  [UIColor colorWithRed:22/255.0 green:190/255.0 blue:180/255.0 alpha:0.1];
        //线条颜色
        render.strokeColor = [UIColor colorWithRed:71/255.0 green:223/255.0 blue:214/255.0 alpha:1];
        return render;
    }else if ([overlay isKindOfClass:[MKPolygon class]]) {
        MKPolygonRenderer * render = [[MKPolygonRenderer alloc] initWithPolygon:(MKPolygon *)overlay];
        //设置线宽
        render.lineWidth = 2;
        render.fillColor = [[UIColor blueColor] colorWithAlphaComponent:0.3];
        //设置颜色
        render.strokeColor = [UIColor blueColor];
        return render;
     }else if ([overlay isKindOfClass:[MKPolyline class]]) {
         //折线覆盖物提供类
         MKPolylineRenderer * render = [[MKPolylineRenderer alloc] initWithPolyline:(MKPolyline *)overlay];
         //设置线宽
         render.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
         render.lineWidth = 2;
         //设置颜色
         render.strokeColor = [UIColor redColor];
         return render;
    }
    return nil;
  
}


@end

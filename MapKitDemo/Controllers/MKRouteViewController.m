//
//  MKRouteViewController.m
//  MapKitDemo
//
//  Created by duan on 2024/3/22.
//

#import "MKRouteViewController.h"

@interface MKRouteViewController ()

@property (nonatomic, strong) NSMutableArray *polyLineArray;
@end

@implementation MKRouteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addLongPressGesture];
}

- (void)addLongPressGesture {
    // 添加长按手势 切换聚焦
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    longpress.minimumPressDuration = 0.5;
    [self.mapView addGestureRecognizer:longpress];
}

#pragma mark - 长按手势
- (void)longPressAction:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        if (self.polyLineArray.count > 0) {
            [self.mapView removeOverlays:self.polyLineArray];
            [self.polyLineArray removeAllObjects];
        }
        CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
        CLLocationCoordinate2D coordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
        // 使用自定义地图进行导航  将起点和终点发送给服务器,由服务器返回导航结果
        // 1、创建导航请求对象
        MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
        request.transportType = MKDirectionsTransportTypeWalking;
        // 2、设置起点和终点
        MKPlacemark *from = [[MKPlacemark alloc] initWithCoordinate:self.userCoordinate];
        request.source = [[MKMapItem alloc] initWithPlacemark:from];
        MKPlacemark *to = [[MKPlacemark alloc] initWithCoordinate:coordinate];
        request.destination = [[MKMapItem alloc] initWithPlacemark:to];
        //3.创建导航对象
        MKDirections *direction = [[MKDirections alloc] initWithRequest:request];
        //4.计算导航路线 传递数据给服务器
        [direction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
            //取出结果中的路线对象
            for (MKRoute *route in response.routes) {
//                for (MKRouteStep *step in route.steps) {
//                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//                    [dict setValue:step.instructions forKey:@"details"];
//                    [dict setValue:@(step.distance) forKey:@"distance"];
//                    [_routeDetails addObject:dict];
//                }
                [self.mapView addOverlay:route.polyline];
                [self.polyLineArray addObject:route.polyline];
            }
        }];
 
    }
}
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
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
#pragma mark - Getters
- (NSMutableArray *)polyLineArray {
    if (!_polyLineArray) {
        _polyLineArray = [NSMutableArray array];
    }
    return _polyLineArray;
}
@end

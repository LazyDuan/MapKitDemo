//
//  MKMapViewController.m
//  MapKitDemo
//
//  Created by duan on 2024/3/28.
//

#import "MKMapViewController.h"

@interface MKMapViewController ()

@end

@implementation MKMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.followUserLocation = YES;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];
    [self initSubViews];
    [self initLayout];
}

- (void)initSubViews {
    [self.view addSubview:self.mapView];
    [self.mapView addSubview:self.userLocationButton];
}
- (void)initLayout {
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.userLocationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.bottom.equalTo(self.mapView).offset(-10);
        make.width.height.mas_equalTo(44);
    }];
}
#pragma mark - CLLocationManagerDelegate
// 代理方法，定位权限检查
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
   switch (status) {
        case kCLAuthorizationStatusNotDetermined:{
            NSLog(@"用户还未决定授权");
            // 主动获得授权
            [self.locationManager requestWhenInUseAuthorization];
            break;
        }
        case kCLAuthorizationStatusRestricted:{
            NSLog(@"访问受限");
            // 主动获得授权
            [self.locationManager requestWhenInUseAuthorization];
            break;
        }
        case kCLAuthorizationStatusDenied:{
            // 此时使用主动获取方法也不能申请定位权限
            // 类方法，判断是否开启定位服务
            if ([CLLocationManager locationServicesEnabled]) {
                
                NSLog(@"定位服务开启，被拒绝");
            } else {
   
                NSLog(@"定位服务关闭，不可用");
            }
            break;
        }
        case kCLAuthorizationStatusAuthorizedAlways:{
            NSLog(@"获得前后台授权");
            // 开始定位
            [self.locationManager startUpdatingLocation];
            break;
        }
        case kCLAuthorizationStatusAuthorizedWhenInUse:{
            NSLog(@"获得前台授权");
            break;
        }
        default:
            break;
    }
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *newLocation = locations.lastObject;
    self.userCoordinate = newLocation.coordinate;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01); //地图显示比例尺
    MKCoordinateRegion region = MKCoordinateRegionMake(newLocation.coordinate, span); //地图显示区域
    [self.mapView setRegion:region];
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES]; // follow
    [self.locationManager stopUpdatingLocation];

//    [self reverseGeocodeWith:manager.location];  // 反地理编码
}

#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    self.userCoordinate = userLocation.coordinate;
    if (self.followUserLocation) {
        [self focusMapViewToLocation:userLocation.coordinate];
        self.followUserLocation = NO;
    }
}

#pragma mark - Action
- (void)userLocationAction:(UIButton *)button {
    self.followUserLocation = YES;
    [self focusMapViewToLocation:self.userCoordinate];
}

#pragma mark - 切换聚焦位置
- (void)focusMapViewToLocation:(CLLocationCoordinate2D)coordinate {
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01); //地图显示比例尺
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span); //地图显示区域
    NSLog(@"focusMapTo %f %f", coordinate.latitude, coordinate.longitude);
    NSArray *anns = self.mapView.annotations;
    [self.mapView removeAnnotations:anns];
    NSArray *overlays = self.mapView.overlays;
    [self.mapView removeOverlays:overlays];
    for (id ann in self.mapView.annotations) {
        if (![ann isKindOfClass:[MKUserLocation class]]) {
            [self.mapView removeAnnotation:ann];
        }
    }
    
    
  
    MKPointAnnotation *ann = [[MKPointAnnotation alloc] init];
    ann.coordinate = coordinate;
    [self.mapView addAnnotation:ann];
    [self.mapView setRegion:region];
    [self.mapView setUserTrackingMode:MKUserTrackingModeNone animated:YES];
  
//    CLLocation *loc = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
//    [self reverseGeocodeWith:loc];  // 反地理编码
}

#pragma mark - Getters
- (MKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MKMapView alloc] init];
        _mapView.delegate = self;
        _mapView.mapType = MKMapTypeStandard; //地图的类型 标准
        _mapView.showsCompass = YES;  //显示指南针
        _mapView.showsScale = YES;  //显示比例尺
        _mapView.showsTraffic = NO;  //显示交通状况
        _mapView.showsBuildings = YES;  //显示建筑物
        _mapView.showsUserLocation = NO; //显示用户所在的位置
        _mapView.showsPointsOfInterest = YES; //显示感兴趣的东西
    }
    return _mapView;
}
- (UIButton *)userLocationButton {
    if (!_userLocationButton) {
        _userLocationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_userLocationButton setImage:[UIImage imageNamed:@"img_user_location"] forState:UIControlStateNormal];
        [_userLocationButton addTarget:self action:@selector(userLocationAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _userLocationButton;
}



- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        // 移动最大更新距离 (及移动距离超过此值, 就会受到回调)
        // 默认: kCLDistanceFilterNone 回调任何移动
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        // 最佳精准度 : kCLLocationAccuracyBest
        // 导航 : kCLLocationAccuracyBestForNavigation
        // 值越低精准度越高, 越耗电; 负值无效
        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    }
    return _locationManager;
}
@end

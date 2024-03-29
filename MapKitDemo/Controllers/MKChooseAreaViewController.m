//
//  MKChooseAreaViewController.m
//  MapKitDemo
//
//  Created by duan on 2024/3/28.
//

#import "MKChooseAreaViewController.h"
#import "MKAnnotationCircleDragView.h"
#import "MKAnnotationRectangleDragView.h"

@interface MKChooseAreaViewController ()<MKAnnotationCircleDragViewDelegate, MKAnnotationRectangleDragViewDelegate>
@property (nonatomic, strong) MKAnnotationCircleDragView *circleAnnotationView;
@property (nonatomic, strong) MKAnnotationRectangleDragView *rectangleAnnotationView;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIImageView *distanceImageView;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UIImageView *addressImageView;
@property (nonatomic, strong) UILabel *addressLabel;
@end

@implementation MKChooseAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        if (self.type == MKAreaTypeCircle) {
            MKAnnotationCircleDragView *annotationView = (MKAnnotationCircleDragView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"MKAnnotationCircleDragView"];
            if (!annotationView) {
                annotationView = [[MKAnnotationCircleDragView alloc] initWithAnnotation:annotation reuseIdentifier:@"MKAnnotationCircleDragView"];
                annotationView.delegate = self;
            }
            self.circleAnnotationView = annotationView;
            return annotationView;
        }else if (self.type == MKAreaTypeRectangle) {
            MKAnnotationRectangleDragView *annotationView = (MKAnnotationRectangleDragView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"MKAnnotationRectangleDragView"];
            if (!annotationView) {
                annotationView = [[MKAnnotationRectangleDragView alloc] initWithAnnotation:annotation reuseIdentifier:@"MKAnnotationRectangleDragView"];
                annotationView.delegate = self;
                annotationView.maxHeight = self.mapView.frame.size.height - 40;
            }
            self.rectangleAnnotationView = annotationView;
            return annotationView;
        }
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    if (self.circleAnnotationView && [self.circleAnnotationView isKindOfClass:[MKAnnotationCircleDragView class]]) {
        [self dragView:nil didChangeRadius:self.circleAnnotationView.dragButton];
    }
    if (self.rectangleAnnotationView && [self.rectangleAnnotationView isKindOfClass:[MKAnnotationCircleDragView class]]) {
        [self dragView:nil didChangeRadius:self.rectangleAnnotationView.pointArray];
    }
}
#pragma mark - MKAnnotationCircleDragViewDelegate
- (void)dragView:(MKAnnotationCircleDragView *)dragView didChangeRadius:(UIButton *)button {
    CGPoint point = [button convertPoint:button.center toView:self.mapView];
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    CLLocation *currentloc = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:self.circleAnnotationView.annotation.coordinate.latitude longitude:self.circleAnnotationView.annotation.coordinate.longitude];
    CGFloat mi = [currentloc distanceFromLocation:loc];
    self.distanceLabel.text = [NSString stringWithFormat:@"当前安全半径：%.1f米", mi];
}
#pragma mark - MKAnnotationRectangleDragViewDelegate
- (void)dragView:(MKAnnotationRectangleDragView *)dragView didChangeArea:(NSArray<UIButton *> *)buttonArray {
    NSMutableArray *coordinateArray = [NSMutableArray array];
    for (UIButton *button in buttonArray) {
        CGPoint point = [button convertPoint:button.center toView:self.mapView];
        CLLocationCoordinate2D coordinate = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
        [coordinateArray addObject:[NSString stringWithFormat:@"%f,%f",coordinate.latitude,coordinate.longitude]];
    }
    self.distanceLabel.text = [NSString stringWithFormat:@"当前安全半径：%@", coordinateArray];
//    CLLocation *currentloc = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
//    CLLocation *loc = [[CLLocation alloc] initWithLatitude:self.circleAnnotationView.annotation.coordinate.latitude longitude:self.circleAnnotationView.annotation.coordinate.longitude];
//    CGFloat mi = [currentloc distanceFromLocation:loc];
    
}


//- (void)setupView {
//    self.navigationItem.title = @"安全区域";
//    
//  
//  
//    [self.view addSubview:self.bottomView];
//    [self.bottomView addSubview:self.distanceImageView];
//    [self.bottomView addSubview:self.distanceLabel];
//    [self.bottomView addSubview:self.addressImageView];
//    [self.bottomView addSubview:self.addressLabel];
//
//}
//- (void)initLayout {
//    
//    
//    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.trailing.equalTo(self.view);
//        make.bottom.equalTo(self.mas_bottomLayoutGuide);
//        make.height.mas_equalTo(80);
//    }];
//    [self.distanceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.top.equalTo(self.bottomView).offset(16);
//        make.height.width.mas_equalTo(15);
//    }];
//    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.distanceImageView.mas_trailing).offset(9);
//        make.centerY.equalTo(self.distanceImageView);
//        make.trailing.equalTo(self.bottomView).offset(-10);
//    }];
//    [self.addressImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.distanceImageView);
//        make.top.equalTo(self.distanceImageView.mas_bottom).offset(11);
//        make.height.width.mas_equalTo(15);
//    }];
//    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.addressImageView.mas_trailing).offset(9);
//        make.centerY.equalTo(self.addressImageView);
//        make.trailing.equalTo(self.bottomView).offset(-10);
//    }];
//}














#pragma mark - 反地理编码 (更新label text)
- (void)reverseGeocodeWith:(CLLocation *)location {
    CLGeocoder *gecoder = [[CLGeocoder alloc] init];
    __weak typeof(self) weakSelf = self;
    [gecoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error != nil || placemarks.count == 0) {
            NSLog(@"%@", error);
            return;
        }
        for (CLPlacemark *placemark in placemarks) {
            NSDictionary *addressDic = placemark.addressDictionary;
            NSString *addressStr = [NSString stringWithFormat:@"%@%@%@", addressDic[@"City"], addressDic[@"SubLocality"], addressDic[@"Street"]];
            weakSelf.addressLabel.text = addressStr;
        }
    }];
}



#pragma mark - Getters




- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}
- (UIImageView *)distanceImageView {
    if (!_distanceImageView) {
        _distanceImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_distance"]];
    }
    return _distanceImageView;
}
- (UILabel *)distanceLabel {
    if (!_distanceLabel) {
        _distanceLabel = [[UILabel alloc] init];
        _distanceLabel.text = @"当前安全半径：--米";
        _distanceLabel.textColor = [UIColor blackColor];
        _distanceLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    }
    return _distanceLabel;
}
- (UIImageView *)addressImageView {
    if (!_addressImageView) {
        _addressImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_distance"]];
    }
    return _addressImageView;
}
- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.text = @"--";
        _addressLabel.textColor = [UIColor blackColor];
        _addressLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    }
    return _addressLabel;
}
@end

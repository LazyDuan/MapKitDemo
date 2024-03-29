//
//  MKSearchViewController.m
//  MapKitDemo
//
//  Created by duan on 2024/3/28.
//

#import "MKSearchViewController.h"

@interface MKSearchViewController ()<UISearchBarDelegate>
@property (nonatomic, strong) UISearchBar *searchBar;
@end

@implementation MKSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.mapView addSubview:self.searchBar];
}
#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    NSString *addressStr = searchBar.text;  //位置信息
    // 地理编码
    [geocoder geocodeAddressString:addressStr completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error!=nil || placemarks.count==0) {
            return ;
        }
        //创建placemark对象
        CLPlacemark *placemark = [placemarks firstObject];
//        [self focusMapTo:placemark.location.coordinate];
    }];
    [searchBar endEditing:YES];
}
#pragma mark - Getters
- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.delegate = self;
    }
    return _searchBar;
}
@end

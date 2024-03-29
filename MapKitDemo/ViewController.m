//
//  ViewController.m
//  MapKitDemo
//
//  Created by duan on 2024/3/18.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>
#import "MKChooseAreaViewController.h"
#import "MKOverlayViewController.h"
#import "MKRouteViewController.h"
#import "MKSearchViewController.h""

// 状态栏高度
#define kStatusHeight ([UIApplication sharedApplication].statusBarFrame.origin.y + [UIApplication sharedApplication].statusBarFrame.size.height)
#define kDefault (100)

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation ViewController {
  BOOL _followUserLocation;  // 是否跟踪用户定位
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _followUserLocation = YES;
    [self initSet];
    [self initLayout];
}
- (void)initSet {
    self.navigationItem.title = @"MapKitDemo";
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.dataSource = @[@[@"选取圆形范围",@"选取矩形范围"],@[@"线条遮盖物",@"圆形遮盖物",@"多边形遮盖物"],@[@"路线规划"]];
    [self.view addSubview:self.tableView];
}
- (void)initLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.dataSource[section];
    return array.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath { 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = self.dataSource[indexPath.section][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = self.dataSource[indexPath.section][indexPath.row];
    if ([text isEqualToString:@"选取圆形范围"]) {
        MKChooseAreaViewController *chooseAreaVC = [[MKChooseAreaViewController alloc] init];
        chooseAreaVC.type = MKAreaTypeCircle;
        [self.navigationController pushViewController:chooseAreaVC animated:YES];
    }else if ([text isEqualToString:@"选取矩形范围"]) {
        MKChooseAreaViewController *chooseAreaVC = [[MKChooseAreaViewController alloc] init];
        chooseAreaVC.type = MKAreaTypeRectangle;
        [self.navigationController pushViewController:chooseAreaVC animated:YES];
    }else if ([text isEqualToString:@"线条遮盖物"]) {
        MKOverlayViewController *overlayVC = [[MKOverlayViewController alloc] init];
        overlayVC.type = MKOverlayTypePolyline;
        [self.navigationController pushViewController:overlayVC animated:YES];
    }else if ([text isEqualToString:@"圆形遮盖物"]) {
        MKOverlayViewController *overlayVC = [[MKOverlayViewController alloc] init];
        overlayVC.type = MKOverlayTypeCircle;
        [self.navigationController pushViewController:overlayVC animated:YES];
    }else if ([text isEqualToString:@"多边形遮盖物"]) {
        MKOverlayViewController *overlayVC = [[MKOverlayViewController alloc] init];
        overlayVC.type = MKOverlayTypePolygon;
        [self.navigationController pushViewController:overlayVC animated:YES];
    }else if ([text isEqualToString:@"路线规划"]) {
        MKRouteViewController *routeVC = [[MKRouteViewController alloc] init];
        [self.navigationController pushViewController:routeVC animated:YES];
    }
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
    }
    return _tableView;
}

@end

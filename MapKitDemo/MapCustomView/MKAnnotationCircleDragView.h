//
//  MKAnnotationCircleDragView.h
//  MapKitDemo
//
//  Created by duan on 2024/3/18.
//

#import <MapKit/MapKit.h>

@class MKAnnotationCircleDragView;
@protocol MKAnnotationCircleDragViewDelegate <NSObject>

- (void)dragView:(MKAnnotationCircleDragView *)dragView didChangeRadius:(UIButton *)button;

@end

@interface MKAnnotationCircleDragView : MKAnnotationView
@property (nonatomic, weak) id<MKAnnotationCircleDragViewDelegate> delegate;
@property (nonatomic, strong) UIButton *dragButton;
@property (nonatomic, assign) NSInteger minDiam;
@property (nonatomic, assign) NSInteger maxDiam;

@end

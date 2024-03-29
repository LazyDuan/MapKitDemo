//
//  MKAnnotationRectangleDragView.h
//  MapKitDemo
//
//  Created by duan on 2024/3/21.
//

#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MKAnnotationRectangleDragView;
@protocol MKAnnotationRectangleDragViewDelegate <NSObject>

- (void)dragView:(MKAnnotationRectangleDragView *)dragView didChangeArea:(NSArray<UIButton *>*)button;

@end

@interface MKAnnotationRectangleDragView : MKAnnotationView
@property (nonatomic, weak) id<MKAnnotationRectangleDragViewDelegate> delegate;
@property (nonatomic, strong) NSArray<UIButton *>* pointArray;
@property (nonatomic, assign) NSInteger minWidth;
@property (nonatomic, assign) NSInteger maxWidth;
@property (nonatomic, assign) NSInteger minHeight;
@property (nonatomic, assign) NSInteger maxHeight;
@end

NS_ASSUME_NONNULL_END

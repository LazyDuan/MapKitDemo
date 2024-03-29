//
//  MKChooseAreaViewController.h
//  MapKitDemo
//
//  Created by duan on 2024/3/28.
//

#import "MKMapViewController.h"

typedef NS_ENUM(NSInteger, MKAreaType) {
    MKAreaTypeCircle,
    MKAreaTypeRectangle
};
NS_ASSUME_NONNULL_BEGIN

@interface MKChooseAreaViewController : MKMapViewController
@property(nonatomic, assign) MKAreaType type;
@end

NS_ASSUME_NONNULL_END

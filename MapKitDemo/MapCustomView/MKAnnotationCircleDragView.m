//
//  MKAnnotationCircleDragView.m
//  MapKitDemo
//
//  Created by duan on 2024/3/18.
//

#import "MKAnnotationCircleDragView.h"
#import <Masonry/Masonry.h>

#define kMaxWidth ([UIScreen mainScreen].bounds.size.width-20)

@interface MKAnnotationCircleDragView()
@property (nonatomic, strong) UIView *dragView;
@property (nonatomic, strong) UIView *shadowView;

@end
@implementation MKAnnotationCircleDragView 

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
  if (self) {
      [self initAction];
      [self initLayout];
  }
  return self;
}
- (void)initAction {
    self.image = [UIImage imageNamed:@"img_center_location"];
    
    self.minDiam = 80;
    self.maxDiam = [UIScreen mainScreen].bounds.size.width - 44;
    
    [self addSubview:self.dragView];
    [self.dragView addSubview:self.shadowView];
    [self.dragView addSubview:self.dragButton];
}
- (void)initLayout {
    [self.dragView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.center.equalTo(self);
      make.width.height.mas_equalTo(kMaxWidth);
    }];
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.mas_equalTo(80);
    }];
    [self.dragButton mas_makeConstraints:^(MASConstraintMaker *make) {
      make.width.height.mas_equalTo(24);
      make.leading.equalTo(self.shadowView.mas_trailing).offset(-12);
      make.centerY.equalTo(self.shadowView);
    }];
}
#pragma mark - 拖拽手势
- (void)panAction:(UIPanGestureRecognizer *)pan {
  CGPoint p = [pan translationInView:pan.view];
  CGFloat x = p.x;
  if (x > 5) x = 5;
  if (x < -5) x = -5;
  
  CGFloat orginWidth = self.shadowView.frame.size.width;
  CGFloat resultWidth = orginWidth + x;
  
  CGFloat width;
  if (resultWidth < self.minDiam) {
    width = self.minDiam;
  } else if (resultWidth > self.maxDiam) {
    width = self.maxDiam;
  } else {
    width = resultWidth;
  }
  
  [self.shadowView mas_updateConstraints:^(MASConstraintMaker *make) {
    make.width.height.mas_equalTo(width);
  }];
  self.shadowView.layer.cornerRadius = (width) * 0.5;
  if (self.delegate) {
    [self.delegate dragView:self didChangeRadius:pan.view];
  }
}
#pragma mark - 扩大点击范围
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
  [self layoutIfNeeded];
  if (CGRectContainsPoint(self.dragView.frame, point) || CGRectContainsPoint(self.frame, point)) {
    return YES;
  }
  return NO;
}
#pragma mark - Setters
//- (void)setMinWidth:(NSInteger)minWidth {
//    _minWidth = minWidth;
//}
//- (void)setMaxWidth:(NSInteger)maxWidth {
//    _maxWidth = maxWidth;
//}
#pragma mark - Getters
- (UIView *)dragView{
    if (!_dragView) {
        _dragView = [[UIView alloc] init];
        _dragView.userInteractionEnabled = YES;
    }
    return _dragView;
}
- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = [[UIView alloc] init];
        _shadowView.layer.borderColor = [UIColor colorWithRed:255/255.0 green:98/255.0 blue:98/255.0 alpha:1].CGColor;
        _shadowView.layer.borderWidth = 2;
        _shadowView.backgroundColor = [UIColor colorWithRed:255/255.0 green:98/255.0 blue:98/255.0 alpha:0.1];
        _shadowView.layer.cornerRadius = 40;
    }
    return _shadowView;
}
- (UIButton *)dragButton {
    if (!_dragButton) {
        _dragButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dragButton setImage:[UIImage imageNamed:@"btn_drag"] forState:UIControlStateNormal];
        _dragButton.adjustsImageWhenHighlighted = NO;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        [_dragButton addGestureRecognizer:pan];
    }
    return _dragButton;
}
@end

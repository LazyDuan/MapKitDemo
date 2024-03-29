//
//  MKAnnotationRectangleDragView.m
//  MapKitDemo
//
//  Created by duan on 2024/3/21.
//

#import "MKAnnotationRectangleDragView.h"
#import <Masonry/Masonry.h>

@interface MKAnnotationRectangleDragView()
@property (nonatomic, strong) UIButton *topLeftButton;
@property (nonatomic, strong) UIButton *topRightButton;
@property (nonatomic, strong) UIButton *bottomLeftButton;
@property (nonatomic, strong) UIButton *bottomRightButton;
@property (nonatomic, strong) UIView *dragView;
@property (nonatomic, strong) UIView *shadowView;
@end

@implementation MKAnnotationRectangleDragView

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
    
    self.minWidth = 80;
    self.maxWidth = [UIScreen mainScreen].bounds.size.width - 44;
    self.minHeight = 80;
    self.maxHeight = [UIScreen mainScreen].bounds.size.height - 150;
    
    [self addSubview:self.dragView];
    [self.dragView addSubview:self.shadowView];
    [self.dragView addSubview:self.topLeftButton];
    [self.dragView addSubview:self.topRightButton];
    [self.dragView addSubview:self.bottomLeftButton];
    [self.dragView addSubview:self.bottomRightButton];
    self.pointArray = @[self.topLeftButton,self.topRightButton,self.bottomRightButton,self.bottomLeftButton];
   
}
- (void)initLayout {
    [self.dragView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(self.maxWidth + 44);
        make.height.mas_equalTo(self.maxHeight + 44);
    }];
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.dragView);
        make.width.height.mas_equalTo(80);
    }];
    [self.topLeftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(24);
        make.top.equalTo(self.shadowView).offset(-12);
        make.leading.equalTo(self.shadowView).offset(-12);
    }];
    [self.topRightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(24);
        make.top.equalTo(self.shadowView).offset(-12);
        make.trailing.equalTo(self.shadowView).offset(12);
    }];
    [self.bottomLeftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(24);
        make.bottom.equalTo(self.shadowView).offset(12);
        make.leading.equalTo(self.shadowView).offset(-12);
    }];
    [self.bottomRightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(24);
        make.bottom.equalTo(self.shadowView).offset(12);
        make.trailing.equalTo(self.shadowView).offset(12);
    }];
}

#pragma mark - 拖拽手势
- (void)panAction:(UIPanGestureRecognizer *)pan {
    CGPoint p = [pan translationInView:pan.view];
    CGFloat x = p.x;
    CGFloat y = p.y;
    if([pan.view isEqual:self.topLeftButton] || [pan.view isEqual:self.bottomLeftButton]) {
        x = -p.x;
    }
    if([pan.view isEqual:self.topLeftButton] || [pan.view isEqual:self.topRightButton]) {
        y = -p.y;
    }
    
    if (x > 5) x = 5;
    if (x < -5) x = -5;
    if (y > 5) y = 5;
    if (y < -5) y = -5;
  
    CGFloat orginWidth = self.shadowView.frame.size.width;
    CGFloat resultWidth = orginWidth + x;

    CGFloat width;
    if (resultWidth < self.minWidth) {
        width = self.minWidth;
    } else if (resultWidth > self.maxWidth) {
        width = self.maxWidth;
    } else {
        width = resultWidth;
    }

    CGFloat orginHeight = self.shadowView.frame.size.height;
    CGFloat resultHeight = orginHeight + y;
    
    CGFloat height;
    if (resultHeight < self.minHeight ) {
        height = self.minHeight;
    } else if (resultHeight > self.maxHeight) {
        height = self.maxHeight;
    } else {
        height = resultHeight;
    }
    
    [self.shadowView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(dragView:didChangeArea:)]) {
        [self.delegate dragView:self didChangeArea:self.pointArray];
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
    }
    return _shadowView;
}
- (UIButton *)topLeftButton {
    if (!_topLeftButton) {
        _topLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_topLeftButton setImage:[UIImage imageNamed:@"btn_drag"] forState:UIControlStateNormal];
        _topLeftButton.adjustsImageWhenHighlighted = NO;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        [_topLeftButton addGestureRecognizer:pan];
    }
    return _topLeftButton;
}

- (UIButton *)topRightButton {
    if (!_topRightButton) {
        _topRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_topRightButton setImage:[UIImage imageNamed:@"btn_drag"] forState:UIControlStateNormal];
        _topRightButton.adjustsImageWhenHighlighted = NO;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        [_topRightButton addGestureRecognizer:pan];
    }
    return _topRightButton;
}
- (UIButton *)bottomLeftButton {
    if (!_bottomLeftButton) {
        _bottomLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomLeftButton setImage:[UIImage imageNamed:@"btn_drag"] forState:UIControlStateNormal];
        _bottomLeftButton.adjustsImageWhenHighlighted = NO;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        [_bottomLeftButton addGestureRecognizer:pan];
    }
    return _bottomLeftButton;
}
- (UIButton *)bottomRightButton {
    if (!_bottomRightButton) {
        _bottomRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomRightButton setImage:[UIImage imageNamed:@"btn_drag"] forState:UIControlStateNormal];
        _bottomRightButton.adjustsImageWhenHighlighted = NO;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        [_bottomRightButton addGestureRecognizer:pan];
    }
    return _bottomRightButton;
}
@end

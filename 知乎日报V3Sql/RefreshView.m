//
//  RefreshView.m
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/21.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "RefreshView.h"
#import "UIView+Extension.h"

@interface RefreshView ()
@property(nonatomic, strong) UIActivityIndicatorView *loading;
@property(nonatomic, strong) CAShapeLayer *whiteLayer;
@property(nonatomic, strong) CAShapeLayer *grayLayer;
@end

@implementation RefreshView
-(UIView *)basiclayerView{
    if (!_basiclayerView) {
        _basiclayerView = [[UIView alloc] initWithFrame:self.bounds];
    }
    return _basiclayerView;
}
-(UIActivityIndicatorView *)loading{
    if (!_loading) {
        _loading = [[UIActivityIndicatorView alloc] initWithFrame:self.bounds];
    }
    return _loading;
}
-(CAShapeLayer *)whiteLayer{
    if (!_whiteLayer) {
        _whiteLayer = [CAShapeLayer layer];
        _whiteLayer.lineWidth = 2.f;
        _whiteLayer.strokeColor = [UIColor whiteColor].CGColor;
        _whiteLayer.fillColor = [UIColor clearColor].CGColor;
        _whiteLayer.opacity = 0;
        _whiteLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width *0.5, self.width *0.5) radius:self.width *0.25 startAngle:M_PI_2 endAngle:M_PI * 5 *0.5 clockwise:YES].CGPath;
        _whiteLayer.strokeEnd = 0;
    }
    return _whiteLayer;
}
-(CAShapeLayer *)grayLayer{
    if (!_grayLayer) {
        _grayLayer = [CAShapeLayer layer];
        _grayLayer.lineWidth = 2.f;
        _grayLayer.strokeColor = [UIColor grayColor].CGColor;
        _grayLayer.fillColor = [UIColor clearColor].CGColor;
        _grayLayer.opacity = 0;
        _grayLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.center.x -self.width*0.25 , self.center.y -self.width*0.25, self.width*0.5, self.width*0.5)].CGPath;
    }
    return _grayLayer;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self animationInit];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self animationInit];
    }
    return self;
}
-(void)updateProgress:(CGFloat)progress{
    if (progress <= 0) {
        self.grayLayer.opacity = self.whiteLayer.opacity = 0;
    }else{
         self.grayLayer.opacity = self.whiteLayer.opacity = 1;
    }
    if (progress > 1) {
        progress = 1;
    }
    self.whiteLayer.strokeEnd = progress;
}

-(void)startAnimation{
    self.basiclayerView.hidden = YES;
    [self.loading startAnimating];
}

-(void)stopAnimation{
    
    [self.loading stopAnimating];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.basiclayerView.hidden = NO;
    });
    
}

-(void)animationInit{
    [self addSubview:self.loading];
    [self addSubview:self.basiclayerView];
    [self.basiclayerView.layer addSublayer:self.grayLayer];
    [self.basiclayerView.layer addSublayer:self.whiteLayer];

}

@end

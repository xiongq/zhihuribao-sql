//
//  XQloading-CAShaplayer.m
//  知乎日报--加载动画实验
//
//  Created by xiong on 16/3/6.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "XQloading-CAShaplayer.h"
@interface XQloading_CAShaplayer()
@property (strong, nonatomic) CAShapeLayer  *layers;
@property (strong, nonatomic) UIButton      *rolad;
@end
@implementation XQloading_CAShaplayer
{
    BOOL isAnimation;
    BOOL errorHidden;
    CGRect tempRect;
    UIColor *temp;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    _layers = [CAShapeLayer layer];
//    NSLog(@"%@",NSStringFromCGRect( frame));
    return self;
}

-(void)SetlayersLineWidth:(CGFloat )lineWidth strokeColor:(UIColor *)strokeColor layerFrameAndPath:(CGRect )rect{
    _layers.lineWidth   = lineWidth; //线宽
    _layers.lineCap     = kCALineCapRound; //线条圆度
    _layers.strokeColor = strokeColor.CGColor; //线条颜色
    _layers.fillColor   = [UIColor clearColor].CGColor; //填充色
    _layers.frame       = rect;
//    _layers.position    = self.center;
    _layers.position = CGPointMake(self.frame.size.width*0.5, self.frame.size.height *0.5);
//    NSLog(@"%@",NSStringFromCGPoint( self.center));
    _layers.path        = [UIBezierPath bezierPathWithOvalInRect:rect].CGPath;
    _layers.strokeEnd   = 0;  //开始位置
    tempRect            = rect;
    [self.layer addSublayer:_layers];
    temp = strokeColor;
}

-(void)StartAnimation{
    self.alpha                             = 1;
    _rolad.hidden                          = YES;
    _layers.strokeColor                    = temp.CGColor;
    CABasicAnimation *stroleStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    stroleStartAnimation.fromValue         = [NSNumber numberWithFloat:-1];
    stroleStartAnimation.toValue           = [NSNumber numberWithFloat:1];

    CABasicAnimation *stroleEndtAnimation  = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    stroleEndtAnimation.fromValue          = [NSNumber numberWithFloat:0];
    stroleEndtAnimation.toValue            = [NSNumber numberWithFloat:1];

    CAAnimationGroup *group                = [[CAAnimationGroup alloc] init];
    group.duration                         = 3.0f;
    group.repeatCount                      = CGFLOAT_MAX;
    group.animations                       = @[stroleStartAnimation, stroleEndtAnimation];
    [self.layers addAnimation:group forKey:@"group"];

    CABasicAnimation *rotate               = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotate.fromValue                       = [NSNumber numberWithFloat:0];
    rotate.toValue                         = [NSNumber numberWithFloat:M_PI *2];
    rotate.repeatCount                     = CGFLOAT_MAX;
    rotate.duration                        = 3.0f;
    [self.layers addAnimation:rotate forKey:@"rotate"];

}
-(void)StopAnimation{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0 ;
        [self.layers removeAllAnimations];
    }];
    

}
-(void)SetErrorText:(NSString *)errorText{
    _rolad                          = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    _rolad.center                   = self.center;
    _rolad.backgroundColor          = [UIColor clearColor];
    _rolad.titleLabel.font          = [UIFont systemFontOfSize:12];
    _rolad.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_rolad setTitle:errorText forState:UIControlStateNormal];
    [_rolad setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self addSubview:_rolad];
    [_rolad addTarget:self action:@selector(delegateBtn) forControlEvents:UIControlEventTouchUpInside];
    _rolad.hidden                   = YES;
    

}

-(void)delegateBtn{
    if ([self.delegate respondsToSelector:@selector(reload)]) {
        [self.delegate reload];
        _rolad.hidden = YES;
    }
}

/** 显示错误信息，且动画颜色clear*/
-(void)waitReload{
    self.alpha              = 1;
    _rolad.hidden           = NO;
    self.layers.strokeColor = [UIColor clearColor].CGColor;

}
@end

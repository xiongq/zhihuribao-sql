//
//  oneTopStoryImageAndTittle.m
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/18.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "oneTopStoryImageAndTittle.h"

@interface oneTopStoryImageAndTittle()
@property (strong, nonatomic) CAGradientLayer *coverLayer;
@property (strong, nonatomic) CALayer *shadwlayer;
@end
@implementation oneTopStoryImageAndTittle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"oneTopStoryImageAndTittle" owner:self options:nil] firstObject];
        view.frame = self.bounds;
        self.TopStoryImageView.contentMode = UIViewContentModeCenter;
        self.TopStoryImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.TopStoryImageView.clipsToBounds = YES;
        self.TopStoryImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(test)];
        [self.TopStoryImageView addGestureRecognizer:tap];
        [self addSubview:view];
        self.shadwlayer = [CALayer layer];
        self.shadwlayer.frame = self.TopStoryImageView.bounds;
        self.shadwlayer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4].CGColor;
        [self.TopStoryImageView.layer addSublayer:self.shadwlayer];
//        _coverLayer = [CAGradientLayer layer];
//        
//        _coverLayer.frame = self.TopStoryImageView.bounds;
//
//        _coverLayer.colors = @[
//                               (id)[UIColor colorWithWhite:0.2 alpha:0.6].CGColor,
//                               (id)[UIColor clearColor].CGColor,
//                               (id)[UIColor clearColor].CGColor,
//                               (id)[UIColor colorWithWhite:0.2 alpha:0.6].CGColor
//                               ];
//        _coverLayer.locations = @[ @0.0, @0.4, @0.7, @1.0 ];
//        [self.TopStoryImageView.layer addSublayer:_coverLayer];
    }
    return self;
}
-(void)test{
    NSLog(@"fuck%@",self.TopStroyTitle.text);
    if ([self.delegate respondsToSelector:@selector(touchImage:)]) {
        [self.delegate touchImage:self.TopStroyTitle.text];
    }

}
//-(void)layoutSubviews{
//    [super layoutSubviews];
//    [CATransaction begin];
//    [CATransaction setDisableActions:YES];
//    self.coverLayer.frame = self.TopStoryImageView.bounds;
//    [CATransaction commit];
//
//}
-(void)layoutSubviews{
    [super layoutSubviews];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];//关闭layer动画
    self.shadwlayer.frame = self.TopStoryImageView.bounds;
    [CATransaction commit];

}
@end

//
//  ImageWithLabelBtn.m
//  上图下文字btn
//
//  Created by xiong on 16/3/17.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "ImageWithLabelBtn.h"

@implementation ImageWithLabelBtn

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
//        CGSize titleSize = self.titleLabel.frame.size;
        CGSize imageSize = self.imageView.frame.size;
        self. contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
        self.titleLabel.font = [UIFont systemFontOfSize:9];
        self.imageEdgeInsets = UIEdgeInsetsMake(-imageSize.height *0.5, 10, 0, 0);
        self.titleEdgeInsets = UIEdgeInsetsMake(imageSize.height +5, -imageSize.width +11, 0, 0);
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

@end

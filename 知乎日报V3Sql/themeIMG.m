//
//  themeIMG.m
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/27.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "themeIMG.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import <SDImageCache.h>

@implementation themeIMG


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}
#warning fix - topimage 提前设置图片
-(void)imageHTTP:(NSString *)url{
    UIImageView *topImageView = [UIImageView new];
    UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:url];
    if (cacheImage) {
        NSLog(@"存在");
        topImageView.image = cacheImage;
    }else{
        [topImageView sd_setImageWithURL:[NSURL URLWithString:url]];
    }

    topImageView.contentMode = UIViewContentModeCenter;
    topImageView.contentMode = UIViewContentModeScaleAspectFill;
    topImageView.clipsToBounds = YES;

    [self addSubview:topImageView];
    [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(self.mas_height);
    }];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];

    UIVisualEffectView *effctView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [self addSubview:effctView];
    [effctView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(self.mas_height);
    }];
    self.efffectView = effctView;

}
@end

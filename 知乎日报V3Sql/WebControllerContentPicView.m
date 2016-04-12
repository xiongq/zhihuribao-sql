//
//  WebControllerContentPicView.m
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/22.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "WebControllerContentPicView.h"
#import "oneTopStoryImageAndTittle.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>

@implementation WebControllerContentPicView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {

    }
    return self;
}
-(void)setImageWithTitle:(ZHNewsModel *)model{

    oneTopStoryImageAndTittle *contentView = [oneTopStoryImageAndTittle new];
    
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.mas_height);
        make.width.equalTo(self.mas_width);
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
    }];
    if (!model) {
        contentView.TopStroyTitle.text = nil;
        contentView.TopStroyImageSourceTitle.text = nil;
        contentView.TopStoryImageView.image = [UIImage imageNamed:@"Home_Image"];
        return;
    }

    [contentView.TopStoryImageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"Home_Image"]];
    contentView.TopStroyTitle.text = model.title;
    contentView.TopStroyImageSourceTitle.text    = [NSString stringWithFormat:@"图片:%@",model.image_source];

}
@end

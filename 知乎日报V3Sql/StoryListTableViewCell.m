//
//  StoryListTableViewCell.m
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/18.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "StoryListTableViewCell.h"
#import <UIImageView+WebCache.h>

@implementation StoryListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
-(void)sendModel:(Stories *)story{
    self.title.text = story.title;
    self.newsImageView.contentMode = UIViewContentModeCenter;
    self.newsImageView.clipsToBounds = YES;
    [self.newsImageView sd_setImageWithURL:[NSURL URLWithString:[story.images firstObject]] placeholderImage:[UIImage imageNamed:@"Image_Preview"]];
    
    if (story.multipic == 0) {
        self.morePic.hidden = YES;
    }else{
        self.morePic.hidden = NO;
    }
    

}
-(void)sendSideModel:(ThemeStories *)model{
    self.title.text = model.title;
    if (model.images) {
        self.newsImageView.hidden = NO;
        self.leadingImageViewConstans.constant = 20;
        self.newsImageView.contentMode = UIViewContentModeCenter;
        self.newsImageView.clipsToBounds = YES;
        [self.newsImageView sd_setImageWithURL:[NSURL URLWithString:[model.images firstObject]] placeholderImage:[UIImage imageNamed:@"Image_Preview"]];
    }else{
        self.newsImageView.hidden = YES;
        self.leadingImageViewConstans.constant = -60;
    }

    self.morePic.hidden = YES;


}
@end

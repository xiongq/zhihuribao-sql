//
//  commentsCell.m
//  知乎日报V3Sql
//
//  Created by xiong on 16/4/14.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "commentsCell.h"

@interface commentsCell()


@end
@implementation commentsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.avaterImageView.layer.cornerRadius = self.avaterImageView.frame.size.width * 0.5;
    self.avaterImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end

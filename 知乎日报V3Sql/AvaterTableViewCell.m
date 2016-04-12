//
//  AvaterTableViewCell.m
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/30.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "AvaterTableViewCell.h"
#import <UIImageView+WebCache.h>

@implementation AvaterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.avaterICON.layer.cornerRadius = self.avaterICON.frame.size.width * 0.5;
    self.avaterICON.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
-(void)sendEditerModel:(Editors *)editors{
    [self.avaterICON sd_setImageWithURL:[NSURL URLWithString:editors.avatar]];
    self.avaterName.text = editors.name;
    self.avaterBIO.text = editors.bio;

}
@end

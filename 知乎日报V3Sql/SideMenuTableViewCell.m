//
//  SideMenuTableViewCell.m
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/17.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "SideMenuTableViewCell.h"

@implementation SideMenuTableViewCell

- (void)awakeFromNib {
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)sendsideModel:(Others *)other{
    if (other.id) {
        self.imageView.hidden = YES;
        self.imageView.image = nil;
    }else{
        self.imageView.hidden = NO;
        self.imageView.image = [UIImage imageNamed:@"Dark_Menu_Icon_Home"];
    }
    self.textLabel.text = other.name;
    self.textLabel.font = [UIFont systemFontOfSize:15];
}
@end

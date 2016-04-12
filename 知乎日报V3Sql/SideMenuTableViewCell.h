//
//  SideMenuTableViewCell.h
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/17.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sideModel.h"

@interface SideMenuTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *fllow;
-(void)sendsideModel:(Others *)other;
@end

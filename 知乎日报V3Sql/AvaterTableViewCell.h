//
//  AvaterTableViewCell.h
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/30.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sideThemeListModel.h"

@interface AvaterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avaterICON;
@property (weak, nonatomic) IBOutlet UIImageView *avaterINFO;
@property (weak, nonatomic) IBOutlet UILabel *avaterName;
@property (weak, nonatomic) IBOutlet UILabel *avaterBIO;
-(void)sendEditerModel:(Editors *)editors;
@end

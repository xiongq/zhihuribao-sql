//
//  StoryListTableViewCell.h
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/18.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHHomeListModel.h"
#import "sideThemeListModel.h"

@interface StoryListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
@property (weak, nonatomic) IBOutlet UIImageView *morePic;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingImageViewConstans;
-(void)sendModel:(Stories *)story;
-(void)sendSideModel:(ThemeStories *)model;
@end

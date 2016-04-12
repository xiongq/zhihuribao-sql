//
//  SideMenuViewController.h
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/17.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
//@protocol  SideMenuCellDelegate<NSObject>
//
//-(void)TouchinsideBtnType:(BtnType)BtnType;
//
//@end
@protocol  SideMenuCellDelegate<NSObject>

-(void)TouchChangeVC:(id)dic;

@end
@interface SideMenuViewController : UIViewController
@property(weak, nonatomic) id<SideMenuCellDelegate>delegate;
@end

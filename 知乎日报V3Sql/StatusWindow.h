//
//  StatusWindow.h
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/23.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatusWindow : UIWindow
+(instancetype)sharedTopWindow;
/** 状态栏的显示/隐藏 */
@property (nonatomic, assign, getter=isStatusBarHidden) BOOL statusBarHidden;
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
@end

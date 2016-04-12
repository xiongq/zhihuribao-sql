//
//  themeContentViewController.h
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/30.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sideThemeListModel.h"

@protocol  themeContentViewDelegate<NSObject>

@optional
/**
 *  代理方法-加载更多旧新闻
 */
-(void)LoadMoreNews;

@end

@interface themeContentViewController : UIViewController
@property(strong, nonatomic) ThemeStories *model;
@property(strong, nonatomic) NSMutableArray *storysArray;
@property(strong, nonatomic) NSIndexPath *indexpath;
@property(weak, nonatomic) id<themeContentViewDelegate>delegate;
@end

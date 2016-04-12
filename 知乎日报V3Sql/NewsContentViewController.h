//
//  NewsContentViewController.h
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/22.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewsContentViewDelegate <NSObject>

@optional
/**
 *  代理方法-加载更多旧新闻
 */
-(void)LoadMoreNews;

@end
@interface NewsContentViewController : UIViewController
/** 索引*/
@property (nonatomic, assign) NSIndexPath *indexpath;
/** 所有日期新闻数组*/
@property (nonatomic, strong) NSArray     *DateWithStorySUMArray;
/** 日期数组*/
@property (nonatomic, strong) NSArray     *DateArray;
@property(weak, nonatomic) id<NewsContentViewDelegate>delegate;
@end

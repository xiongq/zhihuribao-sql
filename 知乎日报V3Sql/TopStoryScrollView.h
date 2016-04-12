//
//  TopStoryScrollView.h
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/18.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TopStoryScrollViewDelegate <NSObject>

-(void)touchTapScroll:(NSInteger)ids;

@end
@interface TopStoryScrollView : UIView
@property (strong, nonatomic) IBOutlet TopStoryScrollView *test;
@property (strong, nonatomic) NSTimer *timer;
@property(weak, nonatomic) id<TopStoryScrollViewDelegate>delegate;

@end

//
//  avaterView.h
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/30.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol avaterviewDelegate <NSObject>

-(void)avaterTouch:(NSMutableArray *)editorsArray;

@end
@interface avaterView : UIView
-(void)sendEditorsArray:(NSMutableArray *)array;
-(void)newsID:(NSInteger) ids;
@property(weak, nonatomic) id<avaterviewDelegate>delegate;
@end

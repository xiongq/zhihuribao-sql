//
//  RefreshView.h
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/21.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefreshView : UIView
@property(nonatomic ,strong) UIView *basiclayerView;
-(void)updateProgress:(CGFloat)progress;
-(void)startAnimation;
-(void)stopAnimation;

@end

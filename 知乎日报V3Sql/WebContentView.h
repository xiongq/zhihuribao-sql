//
//  WebContentView.h
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/22.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHNewsModel.h"

@interface WebContentView : UIWebView
-(void)loadWeb:(ZHNewsModel *)model;
@end

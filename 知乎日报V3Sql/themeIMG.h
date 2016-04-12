//
//  themeIMG.h
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/27.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface themeIMG : UIView
@property(weak, nonatomic) UIVisualEffectView *efffectView;
-(void)imageHTTP:(NSString *)url;
@end

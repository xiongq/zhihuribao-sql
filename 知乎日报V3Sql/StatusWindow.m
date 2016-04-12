//
//  StatusWindow.m
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/23.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "StatusWindow.h"
#import "topVC.h"

@interface StatusWindow ()<NSCopying ,NSMutableCopying>

@end
@implementation StatusWindow
static StatusWindow *_instans = nil;
+(instancetype)sharedTopWindow{
    if (!_instans) {
        _instans = [[self alloc] init];
    }
    return _instans;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        _instans = [[super allocWithZone:zone] init];
    });
    return _instans;
}

-(id)copyWithZone:(NSZone *)zone{
    return _instans;
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    return _instans;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.statusBarStyle = UIStatusBarStyleDefault;
        self.statusBarHidden = NO;
        self.windowLevel = UIWindowLevelAlert;
        self.rootViewController = [[topVC alloc] init];
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20);
    }
    return self;
}
-(void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle{
    _statusBarStyle = statusBarStyle;
    [self.rootViewController setNeedsStatusBarAppearanceUpdate];
}
-(void)setBackgroundColor:(UIColor *)backgroundColor{
    [super setBackgroundColor:[UIColor clearColor]];
}
- (void)setStatusBarHidden:(BOOL)statusBarHidden {
    _statusBarHidden = statusBarHidden;
    [self.rootViewController setNeedsStatusBarAppearanceUpdate];
}
@end

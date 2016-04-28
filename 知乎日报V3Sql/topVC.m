//
//  topVC.m
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/20.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "topVC.h"
#import "StatusWindow.h"
#import <UIKit/UIKit.h>

@interface topVC ()

@end

@implementation topVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    [UIApplication sharedApplication].statusBarHidden = YES;
    //颜色可以改
    self.view.backgroundColor = [UIColor clearColor];
//    self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    NSLog(@"window");

    NSSet *touche = [event allTouches];
    UITouch *touch = [touche anyObject];
    CGPoint touchpoint = [touch locationInView:self.view];
    NSLog(@"点击坐标%@",NSStringFromCGPoint(touchpoint) );
#warning 此处会覆盖掉系统左上角返回APP点击事件
        //点击发出通知，在需要回到顶部的控制器注册通知修改contentoffset就好
        [[NSNotificationCenter defaultCenter] postNotificationName:@"backTop" object:nil];




}

//是否显示状态栏，当然是显示
-(BOOL)prefersStatusBarHidden{
    return [StatusWindow sharedTopWindow].statusBarHidden;
}
//设置状态栏样式
-(UIStatusBarStyle)preferredStatusBarStyle{
    return [StatusWindow sharedTopWindow].statusBarStyle;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end

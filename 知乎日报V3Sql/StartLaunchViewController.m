//
//  StartLaunchViewController.m
//  知乎日报V3Sql
//
//  Created by xiong on 16/4/28.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "StartLaunchViewController.h"
#import <UIImageView+WebCache.h>
#import "NewsRequest.h"
#import "UIView+Extension.h"
#import "AppDelegate.h"
#import "ViewController.h"

@interface StartLaunchViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *ADimageView;
@property (weak, nonatomic) IBOutlet UIImageView *launchImageView;

@end

@implementation StartLaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showADimage];
}

-(void)showADimage{

    [NewsRequest startAnimationImageWithSize:self.view.size Succees:^(id dic) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *temp = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dic[@"img"]]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                _ADimageView.image = temp;

                [UIView animateWithDuration:2.5f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    _launchImageView.alpha = 0;
                    _ADimageView.transform = CGAffineTransformMakeScale(1.08, 1.08);


                } completion:^(BOOL finished) {
                    
                    self.view.window.rootViewController = ((AppDelegate *)[UIApplication sharedApplication].delegate).viewcontroller;
                }];
            });
        });
    } Error:^(NSError *error) {
        NSLog(@"error%@",error);
    }];

}

-(void)dealloc{
    NSLog(@"start-dealloc");
}
@end

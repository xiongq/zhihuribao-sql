//
//  checkDiscussionViewController.m
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/23.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "checkDiscussionViewController.h"

@interface checkDiscussionViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *CheckDiscussionWEB;

@end

@implementation checkDiscussionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.CheckDiscussionWEB.delegate = self;
    if (self.urls) {
        NSURL *url = [NSURL URLWithString:self.urls];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.CheckDiscussionWEB loadRequest:request];
    }

//    [self loadRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadRequest{
//    NSLog(@"%@",self.urls);
    NSURL *url = [NSURL URLWithString:self.urls];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.CheckDiscussionWEB loadRequest:request];

}
@end

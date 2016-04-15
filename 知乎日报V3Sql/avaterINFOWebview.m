//
//  avaterINFOWebview.m
//  知乎日报V3Sql
//
//  Created by xiong on 16/4/11.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "avaterINFOWebview.h"
#import <WebKit/WebKit.h>
#import "UIView+Extension.h"
#import <UINavigationController+FDFullscreenPopGesture.h>

@interface avaterINFOWebview ()
@property(strong, nonatomic) WKWebView *avaterWEB;
@property (weak, nonatomic) IBOutlet UILabel *avaterName;
@end

@implementation avaterINFOWebview
-(WKWebView *)avaterWEB{
    if (!_avaterWEB) {
        _avaterWEB = [[WKWebView alloc] initWithFrame:self.view.frame];
        _avaterWEB.y = 64;
        _avaterWEB.height = _avaterWEB.height - 64;
//        _avaterWEB.navigationDelegate = ;
        [self.view addSubview:_avaterWEB];

    }
    return _avaterWEB;
}
- (IBAction)back:(id)sender {
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.avaterName.text = self.name;
//    https://news-at.zhihu.com/api/4/news/latest8123992
//    NSString *temp = @"https://news-at.zhihu.com/api/4/news/latest8123992";
    [self.avaterWEB loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.avaterurl]]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)dealloc{
    NSLog(@"wkweb");

}
@end

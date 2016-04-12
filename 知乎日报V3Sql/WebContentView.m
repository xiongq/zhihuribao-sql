//
//  WebContentView.m
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/22.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "WebContentView.h"
@interface WebContentView()

@end
@implementation WebContentView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        NSLog(@"loading");
    }
    return self;
}
-(void)loadWeb:(ZHNewsModel *)model{
    NSURL *css = [NSURL URLWithString:[model.css firstObject]];
    NSString *new = [NSString stringWithFormat:@"<html><head> <br /><link  rel=\"stylesheet\" href= %@ </head><body>%@</body></html>",css,model.body];
    [self loadHTMLString:new baseURL:nil];

}
@end

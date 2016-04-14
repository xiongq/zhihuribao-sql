//
//  commentsViewController.h
//  知乎日报V3Sql
//
//  Created by xiong on 16/4/14.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface commentsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *sumComments;
@property (nonatomic, assign) NSInteger ids;
@property (strong , nonatomic) NSString *sumcomm;
@end

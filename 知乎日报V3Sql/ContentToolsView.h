//
//  ContentToolsView.h
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/23.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum btnsender{
    arrows,
    next,
    vote,
    share,
    comment,
}BtnType;
@protocol  ContentToolsViewDelegate<NSObject>

-(void)TouchinsideBtnType:(BtnType)BtnType;

@end
@interface ContentToolsView : UIView

@property (strong, nonatomic) IBOutlet UIView *test;

@property(weak, nonatomic) id<ContentToolsViewDelegate>delegate;
-(void) setComments:(id)comment;
@end

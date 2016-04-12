//
//  ContentToolsView.m
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/23.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "ContentToolsView.h"
#import "UIView+Extension.h"
#import <MJExtension.h>
#import "ZHLongComments.h"

@interface ContentToolsView()
@property (weak, nonatomic) IBOutlet UIButton *arrow;
@property (weak, nonatomic) IBOutlet UIButton *next;
@property (weak, nonatomic) IBOutlet UIButton *vote;
@property (weak, nonatomic) IBOutlet UIButton *share;
@property (weak, nonatomic) IBOutlet UIButton *comment;

@end

@implementation ContentToolsView


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.test = [[[NSBundle mainBundle] loadNibNamed:@"ContentToolsView" owner:self options:nil] firstObject];
        self.test.frame = self.bounds;
        [self addSubview: self.test];
        self.arrow.tag = arrows;
        self.next.tag = next;
        
        self.vote.tag = vote;
        self.share.tag = share;
        self.comment.tag = comment;
        [self buttonAddTarget:[NSArray arrayWithObjects:self.arrow,self.next,self.vote,self.share,self.comment,nil]];
    }
    return self;
}
-(void)buttonAddTarget:(NSArray *)buttonarray{
    for (UIButton *button in buttonarray) {
        [button addTarget:self action:@selector(touchButton:) forControlEvents:UIControlEventTouchUpInside];
    }

}
-(void)touchButton:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(TouchinsideBtnType:)]) {
        [self.delegate TouchinsideBtnType:(BtnType)btn.tag];
    }
}
-(void)setComments:(id)comment{
    ZHLongComments *model = [ZHLongComments mj_objectWithKeyValues:comment];
    [self.vote setTitle:[NSString stringWithFormat:@"%ld",(long)model.popularity] forState:UIControlStateNormal];
    [self.comment setTitle:[NSString stringWithFormat:@"%ld",(long)model.comments] forState:UIControlStateNormal];

}
@end

//
//  avaterView.m
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/30.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "avaterView.h"
#import "NewsRequest.h"
#import <MJExtension.h>
//#import "avaterModel.h"
#import "sideThemeListModel.h"
#import "themeContentModel.h"
#import <UIImageView+WebCache.h>
#import "AvaterViewController.h"

@interface avaterView ()
@property (strong, nonatomic) UIImageView *backline;
@property (strong, nonatomic) UILabel *editerLabel;
@property (strong, nonatomic) UIButton *btn;
@property (strong, nonatomic) NSMutableArray *editorsArray;
@end

@implementation avaterView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.backline = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Profile_Split"]];
        self.backline.frame = CGRectMake(0, 63, [UIScreen mainScreen].bounds.size.width, 0.5);
        [self addSubview:self.backline];

        self.editerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 64, 64)];
        _editerLabel.font = [UIFont systemFontOfSize:15];
        _editerLabel.text = @"推荐者";
        [self addSubview:_editerLabel];

        self.btn = [[UIButton alloc] initWithFrame:self.bounds];
        [_btn addTarget:self action:@selector(avaterPUsh:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn];

        for (int i = 0; i < 5; i++) {

            UIImageView *editAvater = [UIImageView new];

            editAvater.frame = CGRectMake(20 + 64 +40*i, 20, 30, 30);
            editAvater.layer.cornerRadius = 15;
            editAvater.clipsToBounds = YES;
            editAvater.tag = 1000+i;
            [self addSubview:editAvater];
        }


    }
    return self;
}
-(void)sendEditorsArray:(NSMutableArray *)array{
    for (int i = 0; i < 5; i++) {
        UIImageView *editAvater = [self viewWithTag:1000+i];
        editAvater.image = nil;
    }
    for (int i = 0; i < array.count; i++) {
        Recommenders *edit = array[i];
        UIImageView *editAvater = [self viewWithTag:1000+i];
        [editAvater sd_setImageWithURL:[NSURL URLWithString: edit.avatar]];
    }


}
#warning -----bug
-(void)newsID:(NSInteger)ids{
    //发送推荐者请求
    self.editorsArray = [NSMutableArray new];
    [NewsRequest avaterWithID:ids Succees:^(id dic) {
//        NSLog(@"dic%@",dic );

        NSArray *temp = dic[@"items"];
//        sideThemeListModel *model;
        NSArray *edit = dic[@"editors"];
        if (edit) {
            for (int i = 0; i < edit.count; i++) {
                Editors *ed = [Editors mj_objectWithKeyValues:edit[i]];

                [self.editorsArray addObject:ed];
            }

        }
        if (temp) {
            NSDictionary *test = [temp firstObject];
            NSArray *reco = test[@"recommenders"];
            for (int i = 0; i < reco.count; i++) {
                Editors *ed = [Editors mj_objectWithKeyValues:reco[i]];

                [self.editorsArray addObject:ed];
            }

        }


    } Error:^(NSError *error) {
        NSLog(@"error%@",error);
    }];
}
-(void)avaterPUsh:(id)info{
    if ([self.delegate respondsToSelector:@selector(avaterTouch:)]) {
        [self.delegate avaterTouch:self.editorsArray];
    }

}
@end

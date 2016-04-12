//
//  ZHHomeListModel.m
//  知乎日报+FMDB
//
//  Created by xiong on 16/3/13.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "ZHHomeListModel.h"
#import <MJExtension.h>

@implementation ZHHomeListModel

+ (NSDictionary *)objectClassInArray{
    return @{@"stories" : [Stories class], @"top_stories" : [Top_Stories class]};
}
@end


@implementation Stories

@end


@implementation Top_Stories

@end



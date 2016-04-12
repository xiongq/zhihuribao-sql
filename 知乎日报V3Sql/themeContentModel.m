//
//  themeContentModel.m
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/30.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "themeContentModel.h"

@implementation themeContentModel
MJCodingImplementation

+ (NSDictionary *)objectClassInArray{
    return @{@"recommenders" : [Recommenders class]};
}
@end
@implementation Theme
MJCodingImplementation
@end


@implementation Recommenders
MJCodingImplementation
@end



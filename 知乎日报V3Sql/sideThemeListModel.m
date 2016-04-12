//
//  sideThemeListModel.m
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/28.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "sideThemeListModel.h"
#import <MJExtension.h>

@implementation sideThemeListModel
MJCodingImplementation

+ (NSDictionary *)objectClassInArray{
    return @{@"stories" : [ThemeStories class], @"editors" : [Editors class]};
}
@end
@implementation ThemeStories
MJCodingImplementation
@end


@implementation Editors
MJCodingImplementation
@end



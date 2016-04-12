//
//  themeStorySQLTool.h
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/30.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "themeContentModel.h"

@interface themeStorySQLTool : NSObject
/** 用id查询内容*/
+(themeContentModel *)readSQLThemeStoryWithid:(NSInteger)ids;

/** 存取故事模型*/
+(void)SaveThemeStory:(themeContentModel *)model;
@end

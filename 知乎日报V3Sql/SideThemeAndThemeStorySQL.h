//
//  SideThemeAndThemeStorySQL.h
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/28.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SideThemeAndThemeStorySQL : NSObject
+(void)SaveStoryWithID:(id)dic;
+(void)SaveStoryWithNoID:(id)dic;
//+(void)SaveStoryWithNoID:(NSMutableArray *)arr withThemeName:(NSString *)name;
+(id)readDataWithLimitORname:(NSString *)name limit:(NSString *)limit;
@end

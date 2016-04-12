//
//  ZFSqlTools.h
//  知乎日报+FMDB
//
//  Created by xiong on 16/3/13.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZFSqlTools : NSObject
/**给数组存到数据库*/
+(void)SaveStory:(id)json;
/** 根据日期读取数据库*/
+(NSArray *)StoryWithDate:(NSString *)date;
/** 根据id设置已阅读*/
+(void)boolreadWithid:(NSString *)ids;
/** 根据id查询是否阅读*/
+(NSString *)StoryWithids:(NSString *)ids;
@end

//
//  themeStorySQLTool.m
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/30.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "themeStorySQLTool.h"
#import <MJExtension.h>
#import <FMDB.h>


@implementation themeStorySQLTool
//MJCodingImplementation
static FMDatabase *_storydb;
+ (void)initialize
{
    NSString *path =[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"ThemeStory.sqlite"];
//    NSLog(@"path%@",path);
    _storydb = [FMDatabase databaseWithPath:path];
    BOOL open = [_storydb open];
    if (open) {
        //数据库打开成功story->根据id请求返回数据的故事数组，name是栏目名，ids就是栏目id , limit integer NOT NULL UNIQUE
        [_storydb executeUpdate:@"CREATE TABLE IF NOT EXISTS t_themestory(id integer PRIMARY KEY AUTOINCREMENT  NOT NULL, story blob NOT NULL UNIQUE,ids integer NOT NULL UNIQUE)"];
    }else{
        NSLog(@"失败");
    }
}
+(void)SaveThemeStory:(themeContentModel *)model{
    if (model.body) {
        NSInteger ids = model.id;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
        BOOL save =[_storydb executeUpdateWithFormat:@"insert OR IGNORE into t_themestory(story,ids) values (%@,%ld)",data,(long)ids];
        if (save) {
            NSLog(@"栏目save - ok");
        }else{
            NSLog(@"栏目save - error");
        }
    }else{
        //取共享连接
        NSLog(@"没有body，取共享连接");
    }

}
+(themeContentModel *)readSQLThemeStoryWithid:(NSInteger)ids{
    themeContentModel *model;
    NSString *path = [NSString stringWithFormat:@"select *from t_themestory WHERE ids = '%ld'",(long)ids];
    FMResultSet *set = [_storydb executeQuery:path];
    while (set.next) {
        NSData *data = [set objectForColumnName:@"story"];
        model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return model;

}
@end

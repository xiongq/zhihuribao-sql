//
//  ZFSqlTools.m
//  知乎日报+FMDB
//
//  Created by xiong on 16/3/13.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "ZFSqlTools.h"
#import <FMDB.h>

@implementation ZFSqlTools
static FMDatabase *_db;


+(void)initialize{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"story.sqlite"];
    NSLog(@"path%@",path);
    _db = [FMDatabase databaseWithPath:path];
    BOOL open = [_db open];
    if (open) {
//        NSLog(@"打开数据库成功");
    /** 表名t_storys story 二进制故事 date 日期string*/
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_storys(id integer PRIMARY KEY AUTOINCREMENT  NOT NULL, story blob NOT NULL UNIQUE,ids text NOT NULL UNIQUE,read integer NOT NULL,  date text NOT NULL)"];
    }
}
+(void)SaveStory:(id)json{
    NSArray *story = json[@"stories"];
    for (NSDictionary *storyDic in story) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:storyDic];
        [_db executeUpdateWithFormat:@"insert OR IGNORE into t_storys(story,date,ids,read) values (%@,%@,%@,%d);",data,json[@"date"],storyDic[@"id"],0];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"savesucceed" object:nil];
}
/**根据日期读取新闻*/
+(NSArray *)StoryWithDate:(NSString *)date{
    NSString *sql;
    NSMutableArray *array =[NSMutableArray new];
    
    
    if (date == nil) {
        sql = [NSString stringWithFormat:@"select distinct date from t_storys"];
        FMResultSet *set = [_db executeQuery:sql];
        while (set.next) {
            NSString *date = [set stringForColumn:@"date"];
            [array addObject:date];
        }
    }else{
        sql = [NSString stringWithFormat:@"select *from t_storys WHERE date = %@",date];
        FMResultSet *set = [_db executeQuery:sql];
        while (set.next) {
            NSData *data = [set objectForColumnName:@"story"];
            NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [array addObject:dic];
        }
    }

    return array;
}
/**设置是否阅读*/
+(void)boolreadWithid:(NSString *)ids{
    NSString *sql = [NSString stringWithFormat:@"update t_storys set read = %d where ids = %@",1,ids];
   BOOL sucess = [_db executeUpdate:sql];
    if (sucess) {
//        NSLog(@"改成功了");
    }

}
+(NSString *)StoryWithids:(NSString *)ids{
    NSString *sql = [NSString stringWithFormat:@"select *from t_storys WHERE ids = %@",ids];
    FMResultSet *set = [_db executeQuery:sql];
    NSString *date;
    while (set.next) {
        date = [set stringForColumn: @"date"];

    }
    return date;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
@end

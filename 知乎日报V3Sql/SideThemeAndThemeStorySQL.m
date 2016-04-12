//
//  SideThemeAndThemeStorySQL.m
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/28.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "SideThemeAndThemeStorySQL.h"
#import "sideModel.h"
#import "sideThemeListModel.h"
#import <MJExtension.h>
#import <FMDB.h>

@implementation SideThemeAndThemeStorySQL
static FMDatabase *_themedb;
+ (void)initialize
{
    NSString *path =[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Theme.sqlite"];
    _themedb = [FMDatabase databaseWithPath:path];
    BOOL open = [_themedb open];
    if (open) {
        //数据库打开成功story->根据id请求返回数据的故事数组，name是栏目名，ids就是栏目id , limit integer NOT NULL UNIQUE
       [_themedb executeUpdate:@"CREATE TABLE IF NOT EXISTS t_themes(id integer PRIMARY KEY AUTOINCREMENT  NOT NULL, story blob,theme text,name text)"];
    }else{
        NSLog(@"失败");
    }
}
+(void)SaveStoryWithNoID:(id)dic{

    //栏目内容cell
    NSString *name = dic[@"name"];
    NSData *data =[NSKeyedArchiver archivedDataWithRootObject:dic];
    BOOL save =[_themedb executeUpdateWithFormat:@"update t_themes set story = %@ where name = %@",data,name];
    if (save) {
        NSLog(@"更新 - ok");
    }else{
        NSLog(@"更新 - error");
    }

}
+(void)SaveStoryWithID:(id)dic{

    if (dic[@"limit"]) {
        //侧菜单列表栏目
        NSArray *theme = dic[@"others"];
        NSString *limit = (NSString *)dic[@"limit"];

        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:theme];
       BOOL save =[_themedb executeUpdateWithFormat:@"insert OR IGNORE into t_themes(story,theme) values (%@,%@)",data,limit];
        if (save) {
            NSLog(@"栏目save - ok");
        }else{
            NSLog(@"栏目save - error");
        }
    }else{
        //栏目内容cell
        NSString *name = dic[@"name"];
        NSData *data =[NSKeyedArchiver archivedDataWithRootObject:dic];
        BOOL save =[_themedb executeUpdateWithFormat:@"insert OR IGNORE into t_themes(story,name) values (%@,%@)",data,name];
        if (save) {
            NSLog(@"内容save - ok");
        }else{
            NSLog(@"内容save - error");
        }
    }
}
+(id)readDataWithLimitORname:(NSString *)name limit:(NSString *)limit{
    NSString *readPath;
    NSMutableArray *otherArray = [NSMutableArray array];
    sideThemeListModel *model;
    if (limit) {
        readPath = [NSString stringWithFormat:@"select *from t_themes WHERE theme = %@",limit];
    }
    else{
        //数据库字段值如果是中文需要加单引号
        readPath = [NSString stringWithFormat:@"select *from t_themes WHERE name = '%@'",name];
    }
    FMResultSet *set = [_themedb executeQuery:readPath];
    while (set.next) {
        NSData *data = [set objectForColumnName:@"story"];

        NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//        NSLog(@"test123%@",dic);
        if (name != nil) {
            //栏目类容
            model = [sideThemeListModel mj_objectWithKeyValues:dic];
        }else{
            //栏目条目
            otherArray  =[Others mj_objectArrayWithKeyValuesArray:dic];
        }
    }
    if (otherArray.count != 0) {
        return otherArray;
    }else{
        return model;
    }
}
@end

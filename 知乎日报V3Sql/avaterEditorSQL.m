//
//  avaterEditorSQL.m
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/31.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "avaterEditorSQL.h"

@implementation avaterEditorSQL
static FMDatabase *_editordb;
+ (void)initialize
{
    NSString *path =[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"editor.sqlite"];
//    NSLog(@"path%@",path);
    _editordb = [FMDatabase databaseWithPath:path];
    BOOL open = [_editordb open];
    if (open) {
        //数据库打开成功story->根据id请求返回数据的故事数组，name是栏目名，ids就是栏目id , limit integer NOT NULL UNIQUE
        [_editordb executeUpdate:@"CREATE TABLE IF NOT EXISTS t_editor(id integer PRIMARY KEY AUTOINCREMENT  NOT NULL, editor blob NOT NULL UNIQUE,url text NOT NULL UNIQUE)"];
    }else{
        NSLog(@"失败");
    }
}
//+(void)SaveEditor:(Editors *)model{
//    NSString *url = model.avatar;
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
//    BOOL save =[_editordb executeUpdateWithFormat:@"insert OR IGNORE into t_editor(story,url) values (%@,%@)",data,url];
//    if (save) {
//        NSLog(@"主编SQL - ok");
//    }else{
//        NSLog(@"主编SQL - error");
//    }
//
//}
+(void)SaveEditor:(NSMutableArray *)array{
    for (Editors *model in array) {
        NSString *url = model.avatar;

        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
        BOOL save =[_editordb executeUpdateWithFormat:@"insert OR IGNORE into t_editor(editor,url) values (%@,%@)",data,url];
        if (save) {
            NSLog(@"主编SQL - ok");
        }else{
            NSLog(@"主编SQL - error");
        }
    }
}
+(Editors *)readWithAvaterURl:(NSString *)url{
    Editors *model;
    NSString *path = [NSString stringWithFormat:@"select *from t_editor WHERE url = '%@'",url];
    FMResultSet *set = [_editordb executeQuery:path];
    while (set.next) {
        NSData *data = [set objectForColumnName:@"editor"];
        model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//        NSLog(@"查询到数据");
    }
    return model;
}
@end

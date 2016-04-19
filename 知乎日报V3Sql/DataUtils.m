//
//  DataUtils.m
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/21.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "DataUtils.h"
#import "NewsRequest.h"
#import "ZFSqlTools.h"

@implementation DataUtils
+(NSString *)todayDataWithString{
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyyMMdd"];
    return [formatter stringFromDate:today];
}
+(NSString *)nextDataBeforeDays:(NSInteger)days{
    NSDateFormatter *formtter = [NSDateFormatter new];
    [formtter setDateFormat:@"yyyyMMdd"];
    NSDate *nextDay = [NSDate dateWithTimeIntervalSinceNow:-days*60*60*24];
    return [formtter stringFromDate:nextDay];

}
+(NSString *)weeksWithDays:(NSString *)day{
    NSDateFormatter *dateFormat = [NSDateFormatter new];
    [dateFormat setDateFormat:@"yyyyMMdd"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    /**传入的时间string，转成date*/
    NSDate *date = [dateFormat dateFromString:day];
    [dateFormat setDateFormat:@"MM月dd日"];
    NSString *MMddString = [dateFormat stringFromDate:date];
     /**只显示星期*/
    [dateFormat setDateFormat:@"EEE"];
    NSString *EnglishWeek = [dateFormat stringFromDate:date];
    
    /**中文星期字典*/
 // 模拟器和真机语言环境导致的错误
    NSDictionary *weekDic = @{@"Mon":@" 星期一",@"Tue":@" 星期二",@"Wed":@" 星期三",@"Thu":@" 星期四",@"Fri":@" 星期五",@"Sat":@" 星期六",@"Sun":@" 星期日"};
    NSDictionary *weekDic2 = @{@"周一":@" 星期一",@"周二":@" 星期二",@"周三":@" 星期三",@"周四":@" 星期四",@"周五":@" 星期五",@"周六":@" 星期六",@"周日":@" 星期日"};
     /**中文星期*/
    NSString *week = [weekDic valueForKey:EnglishWeek];
    if (!week) {
        week = [weekDic2 valueForKey:EnglishWeek];
    }
    return [MMddString stringByAppendingString:week];

}
/**
 *
 *  秒转换时间
 *  @param time
 *  HH大写是24小时
 *  @return string
 */
+(NSString *)formateDateWithTime:(NSInteger)time{
    NSDate *date = [NSDate new];
    NSTimeInterval seconds = (NSTimeInterval)time;
    date = [NSDate dateWithTimeIntervalSince1970:seconds];
    NSDateFormatter *formate = [NSDateFormatter new];
    [formate setDateFormat:@"MM-dd HH:mm"];
    return [formate stringFromDate:date];

}
+(void)comparNowDateString:(NSString *)oldDateString{
    NSDate *nowdate  = [NSDate date];
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyyMMdd";
    NSDate *olddate = [formatter dateFromString:oldDateString];
    /**
     *  计算当前时间与上一次存入数据库的日期差，有差补全数据库
     */
    int comp = [nowdate timeIntervalSince1970] - [olddate timeIntervalSince1970];
    int index = comp/60/60/24;
    NSLog(@"old%@相差%d天",[NSDate dateWithTimeIntervalSinceNow:-60*60*24],comp/60/60/24);
    if (index < 0) return;
    for (int i = 0; i < index; i++) {
        NSLog(@"%@",[NSDate dateWithTimeIntervalSinceNow:-(60*60*24*i)]);
        [NewsRequest AFNetworkRequestWith:[formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:-(60*60*24*i)]] Succees:^(id dic) {
            NSLog(@"dic%@",dic);
            [ZFSqlTools SaveStory:dic];
        } Error:^(NSError *error) {
            NSLog(@"error%@",error);
        }];
    }




}
@end

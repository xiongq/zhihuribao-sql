//
//  DataUtils.h
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/21.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataUtils : NSObject
/**今天日期*/
+(NSString *)todayDataWithString;
/**传时间过来计算前天日期*/
+(NSString *)nextDataBeforeDays:(NSInteger)days;
+(NSString *)weeksWithDays:(NSString *)day;
/**秒转24小时*/
+(NSString *)formateDateWithTime:(NSInteger)time;
/**判断日期数组是否断了，如果断了就传日期数组排序第二个日期进行判断加载*/
+(void)comparNowDateString:(NSString *)oldDateString;
@end

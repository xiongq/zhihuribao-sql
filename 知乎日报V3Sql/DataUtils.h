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
@end

//
//  NewsRequest.h
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/21.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHNewsModel.h"

typedef void(^success)(id dic);
typedef void(^error)(NSError *error);

@interface NewsRequest : NSObject
@property(strong, nonatomic) void (^testblock)(NSDictionary *dic);
+(void)todayNEWSRequest;
+(void)nextNEWSRequsetWith:(NSString *)days;


+(void)GETHTTPwithThemes:(NSString *)urlstr Succees:(success)Success Error:(error)Error;
+(void)avaterWithID:(NSInteger)ids Succees:(success)Success Error:(error)Error;
+(void)GETThemesWithID:(NSInteger)ids Succees:(success)Success Error:(error)Error;
+(void)beforeLastID:(NSInteger)ids Succees:(success)Success Error:(error)Error;
+(void)AFNetworkRequestWith:(NSString *)days Succees:(success)Success Error:(error)Error;
+(void)avaterinfo:(NSString *)url Succees:(success)Success Error:(error)Error;
@end

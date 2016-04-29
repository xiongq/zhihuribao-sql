//
//  NewsRequest.h
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/21.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHNewsModel.h"
#import <UIKit/UIKit.h>

typedef void(^success)(id dic);
typedef void(^error)(NSError *error);

@interface NewsRequest : NSObject
@property(strong, nonatomic) void (^testblock)(NSDictionary *dic);
+(instancetype)shareRequest;
+(void)todayNEWSRequest;
+(void)nextNEWSRequsetWith:(NSString *)days;
-(void)test;
/**
 *  评论请求
 *
 *  @param urlstr  ids
 *  @param Success model
 *  @param Error   error
 */
+(void)shortCommentsWithIds:(NSInteger)ids Succees:(success)Success Error:(error)Error;
+(void)longCommentsWithIds:(NSInteger)ids Succees:(success)Success Error:(error)Error;

+(void)GETHTTPwithThemes:(NSString *)urlstr Succees:(success)Success Error:(error)Error;
+(void)avaterWithID:(NSInteger)ids Succees:(success)Success Error:(error)Error;
+(void)GETThemesWithID:(NSInteger)ids Succees:(success)Success Error:(error)Error;
+(void)beforeLastID:(NSInteger)ids Succees:(success)Success Error:(error)Error;
+(void)AFNetworkRequestWith:(NSString *)days Succees:(success)Success Error:(error)Error;
+(void)avaterinfo:(NSString *)url Succees:(success)Success Error:(error)Error;

+(void)startAnimationImageWithSize:(CGSize)size Succees:(success)Success Error:(error)Error;
@end

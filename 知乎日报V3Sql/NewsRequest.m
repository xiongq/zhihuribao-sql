//
//  NewsRequest.m
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/21.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "NewsRequest.h"
#import <AFNetworking.h>
#import "ZFSqlTools.h"
#import "DataUtils.h"

#import "ZHHomeListModel.h"
#import <MJExtension.h>
#import <Foundation/Foundation.h>

@interface NewsRequest()
@property(nonatomic, strong) NSArray *items;
@end

@implementation NewsRequest

static NewsRequest *_request;
+(void)todayNEWSRequest{
    [self AFNetworkRequestWith:nil];

}
+(void)load{
    _request = [NewsRequest new];
}
+(instancetype)shareRequest{
    _request = [NewsRequest new];
    return _request;
}
-(void)test{

}
+(void)nextNEWSRequsetWith:(NSString *)days{
    [self AFNetworkRequestWith:days];

}
/**根据日期获取对应日期新闻*/
+(void)AFNetworkRequestWith:(NSString *)days{

    NSString *urls;
    if (days == nil) {
        urls = @"https://news-at.zhihu.com/api/4/news/latest";
    }else{
        urls =[@"https://news-at.zhihu.com/api/4/news/before/"stringByAppendingString:days];
    }
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer = [AFJSONResponseSerializer serializer];
    [manger GET:urls parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ZFSqlTools SaveStory:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"newsRequsest--错误%@",error);
    }];
}
+(void)AFNetworkRequestWith:(NSString *)days Succees:(success)Success Error:(error)Error{
    NSString *urls;
    if (days == nil) {
        urls = @"https://news-at.zhihu.com/api/4/news/latest";
    }else{
        urls =[@"https://news-at.zhihu.com/api/4/news/before/"stringByAppendingString:days];
    }
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.requestSerializer  = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer = [AFJSONResponseSerializer serializer];
    [manger GET:urls parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            if (Success) {
                Success(responseObject);
            }
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (Error) {
            Error(error);
        }
    }];
}

+(void)AFNGETrequestURL:(NSString *)url {
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer = [AFJSONResponseSerializer serializer];
    [manger GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {

        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
/**根据id获取栏目新闻*/
+(void)GETHTTPwithThemes:(NSString *)urlstr Succees:(success)Success Error:(error)Error{
    if (urlstr == nil) {
        urlstr =  @"http://news-at.zhihu.com/api/4/themes";
    }else{
        urlstr = [@"http://news-at.zhihu.com/api/4/theme/"stringByAppendingString:urlstr];
    }
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.requestSerializer  = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer = [AFJSONResponseSerializer serializer];
    [manger GET:urlstr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            if (Success) {
                Success(responseObject);
            }
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (Error) {
            Error(error);
        }
    }];
}
/**根据id获取栏目新闻*/
+(void)GETThemesWithID:(NSInteger)ids Succees:(success)Success Error:(error)Error{
//    NSLog(@"%ld",ids);
    NSString *urlstr = [@"http://news-at.zhihu.com/api/4/news/" stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)ids]];
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.requestSerializer  = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer = [AFJSONResponseSerializer serializer];
    [manger GET:urlstr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            if (Success) {
                Success(responseObject);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (Error) {
            Error(error);
        }
    }];
}
/**根据id获取id之后的 栏目新闻*/
+(void)beforeLastID:(NSInteger)ids Succees:(success)Success Error:(error)Error{
//    NSLog(@"%ld",ids);
    NSString *urlstr = [@"http://news-at.zhihu.com/api/4/theme/12/before/" stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)ids]];
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.requestSerializer  = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer = [AFJSONResponseSerializer serializer];
    [manger GET:urlstr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            if (Success) {
                Success(responseObject);
            }
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (Error) {
            Error(error);
        }
    }];
}
/**根据id获取主编信息*/
+(void)avaterWithID:(NSInteger)ids Succees:(success)Success Error:(error)Error{

    NSString *urlstr = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/story/%@/recommenders",[NSString stringWithFormat:@"%ld", (long)ids]];
//    NSLog(@"url%@",urlstr);
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.requestSerializer  = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer = [AFJSONResponseSerializer serializer];
    [manger GET:urlstr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            if (Success) {
                Success(responseObject);
            }
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (Error) {
            Error(error);
        }
    }];
}
+(void)avaterinfo:(NSString *)url Succees:(success)Success Error:(error)Error{


    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.requestSerializer  = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer = [AFJSONResponseSerializer serializer];
    [manger GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            if (Success) {
                Success(responseObject);
            }
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (Error) {
            Error(error);
        }
    }];
}

+(void)shortCommentsWithIds:(NSInteger)ids Succees:(success)Success Error:(error)Error{

    NSString *urlstr = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/story/%@/short-comments",[NSString stringWithFormat:@"%ld", (long)ids]];
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.requestSerializer  = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer = [AFJSONResponseSerializer serializer];
    [manger GET:urlstr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            if (Success) {
                Success(responseObject);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (Error) {
            Error(error);
        }
    }];

}
+(void)longCommentsWithIds:(NSInteger)ids Succees:(success)Success Error:(error)Error{

    NSString *urlstr = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/story/%@/long-comments",[NSString stringWithFormat:@"%ld", (long)ids]];
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.requestSerializer  = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer = [AFJSONResponseSerializer serializer];
    [manger GET:urlstr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            if (Success) {
                Success(responseObject);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (Error) {
            Error(error);
        }
    }];
    
}
@end

//
//  commentsModel.h
//  知乎日报V3Sql
//
//  Created by xiong on 16/4/14.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Comments;

@interface commentsModel : NSObject

@property (nonatomic, strong) NSArray<Comments *> *comments;

@end
@interface Comments : NSObject

@property (nonatomic, copy) NSString *author;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, assign) NSInteger likes;

@property (nonatomic, assign) NSInteger time;

@property(nonatomic, strong) NSDictionary *reply_to;

@property (nonatomic, copy) NSString *avatar;

@end


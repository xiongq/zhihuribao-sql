//
//  ZHLongComments.h
//  知乎日报2
//
//  Created by xiong on 15/11/26.
//  Copyright © 2015年 xiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHLongComments : NSObject
/** 点赞*/
@property (nonatomic, assign) NSInteger popularity;
/** 评论总数*/
@property (nonatomic, assign) NSInteger comments;
/** 长评论*/
@property (nonatomic, assign) NSInteger long_comments;
/** 不知道*/
@property (nonatomic, assign) NSInteger post_reasons;
/** 正常评论*/
@property (nonatomic, assign) NSInteger normal_comments;
/** 短评论*/
@property (nonatomic, assign) NSInteger short_comments;

@end

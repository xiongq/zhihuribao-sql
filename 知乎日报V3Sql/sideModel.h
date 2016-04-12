//
//  sideModel.h
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/25.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Others;
@interface sideModel : NSObject

@property (nonatomic, assign) NSInteger limit;

@property (nonatomic, strong) NSArray *subscribed;

@property (nonatomic, strong) NSArray<Others *> *others;

@end
@interface Others : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *Description;

@property (nonatomic, copy) NSString *thumbnail;

@property (nonatomic, assign) NSInteger color;

@end


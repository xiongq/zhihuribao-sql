//
//  ZHHomeListModel.h
//  知乎日报+FMDB
//
//  Created by xiong on 16/3/13.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Stories,Top_Stories;
@interface ZHHomeListModel : NSObject

@property (nonatomic, copy) NSString *date;

@property (nonatomic, strong) NSArray<Stories *> *stories;

@property (nonatomic, strong) NSArray<Top_Stories *> *top_stories;

@end
@interface Stories : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) NSArray<NSString *> *images;

@property (nonatomic, copy) NSString *ga_prefix;

@property (nonatomic, assign ) NSInteger multipic;

@end

@interface Top_Stories : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *image;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *ga_prefix;

@end


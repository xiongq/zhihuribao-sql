//
//  themeContentModel.h
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/30.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>

@class Theme,Recommenders;
@interface themeContentModel : NSObject <NSCoding>

@property (nonatomic, strong) NSArray<Recommenders *> *recommenders;

@property (nonatomic, copy) NSString *ga_prefix;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSArray<NSString *> *css;

@property (nonatomic, strong) Theme *theme;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *body;

@property (nonatomic, copy) NSString *share_url;

@property (nonatomic, strong) NSArray *js;

@end
@interface Theme : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *thumbnail;

@end

@interface Recommenders : NSObject

@property (nonatomic, copy) NSString *avatar;

@end


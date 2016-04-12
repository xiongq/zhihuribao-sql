//
//  ZHNewsModel.h
//  知乎日报2
//
//  Created by xiong on 15/11/23.
//  Copyright © 2015年 xiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Section;
@interface ZHNewsModel : NSObject

@property (nonatomic, copy) NSString *image_source;

@property (nonatomic, copy) NSString *ga_prefix;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *image;

@property (nonatomic, strong) Section *section;

@property (nonatomic, strong) NSArray<NSString *> *css;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *body;

@property (nonatomic, copy) NSString *share_url;

@property (nonatomic, strong) NSArray *js;

@end
@interface Section : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *thumbnail;

@end


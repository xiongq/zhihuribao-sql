//
//  sideThemeListModel.h
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/28.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ThemeStories,Editors;
@interface sideThemeListModel : NSObject<NSCoding>

@property (nonatomic, assign) NSInteger color;

@property (nonatomic, strong) NSArray<ThemeStories *> *stories;

@property (nonatomic, copy) NSString *image_source;

@property (nonatomic, copy) NSString *image;

@property (nonatomic, strong) NSArray<Editors *> *editors;

@property (nonatomic, copy) NSString *Description;

@property (nonatomic, copy) NSString *background;

@property (nonatomic, copy) NSString *name;

@end
@interface ThemeStories : NSObject

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSArray *images;

@end

@interface Editors : NSObject

@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *bio;

@property (nonatomic, copy) NSString *zhihu_url_token;

@end


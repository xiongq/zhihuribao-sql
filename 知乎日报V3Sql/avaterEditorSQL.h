//
//  avaterEditorSQL.h
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/31.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sideThemeListModel.h"
#import <MJExtension.h>
#import <FMDB.h>

@interface avaterEditorSQL : NSObject

//+(void)SaveEditor:(Editors *)model;
+(void)SaveEditor:(NSMutableArray *)array;
+(Editors *)readWithAvaterURl:(NSString *)url;
@end

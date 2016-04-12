//
//  oneTopStoryImageAndTittle.h
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/18.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol oneTopImageDelegate <NSObject>

-(void)touchImage:(NSString *)title;

@end

@interface oneTopStoryImageAndTittle : UIView
@property (weak, nonatomic) IBOutlet UIImageView *TopStoryImageView;
@property (weak, nonatomic) IBOutlet UILabel *TopStroyTitle;
@property (weak, nonatomic) IBOutlet UILabel *TopStroyImageSourceTitle;
@property (assign, nonatomic) NSInteger ids;

@property(weak, nonatomic) id<oneTopImageDelegate>delegate;
@end

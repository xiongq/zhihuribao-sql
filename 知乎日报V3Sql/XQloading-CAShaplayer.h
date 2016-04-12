//
//  XQloading-CAShaplayer.h
//  知乎日报--加载动画实验
//
//  Created by xiong on 16/3/6.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XQloading_CAShaplayer ;
@protocol XQloading_CAShaplayeDelegate <NSObject>

@optional
//** 网络错误点击重新加载*/
-(void)reload;

@end
@interface XQloading_CAShaplayer : UIView
//@property (nonatomic, weak) id<ErrorDelegate>delegate;
/** 开始动画*/
- (void)StartAnimation;
/** 结束动画*/
- (void)StopAnimation;
/** 显示错误信息*/
- (void)waitReload;
/** 错误信息文字*/
- (void)SetErrorText:(NSString *)errorText;
/** 设置线条宽度和颜色，rect:layer的path和大小*/
- (void)SetlayersLineWidth:(CGFloat )lineWidth strokeColor:(UIColor *)strokeColor layerFrameAndPath:(CGRect )rect;

@property (nonatomic, weak) id <XQloading_CAShaplayeDelegate>delegate;
@end

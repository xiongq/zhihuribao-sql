//
//  AppDelegate.m
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/17.
//  Copyright © 2016年 xiong. All rights reserved.
//
#warning - 需要重构代码和注释、完成评论控制器、完成主编信息控制器、详情页面跳转
#import "AppDelegate.h"
#import "StatusWindow.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

#import "WXApi.h"

#import "WeiboSDK.h"

#import <EventKit/EventKit.h>

#import "StartLaunchViewController.h"



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [UIWindow new];
    UIStoryboard *temp = [UIStoryboard storyboardWithName:@"StartLaunchViewController" bundle:[NSBundle mainBundle]];
    StartLaunchViewController *launchvc =[temp instantiateViewControllerWithIdentifier:@"LaunchStoryboard"];
    self.window.rootViewController = launchvc;
    [self.window makeKeyWindow];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self viewcontroller];
    });


    [StatusWindow sharedTopWindow].hidden = NO;

    [ShareSDK registerApp:@"122a5ee914e95"
          activePlatforms:@[@(SSDKPlatformTypeSinaWeibo),@(SSDKPlatformTypeYinXiang),@(SSDKPlatformTypeSMS),@(SSDKPlatformTypeMail),@(SSDKPlatformTypeCopy),@(SSDKPlatformTypeWechat),@(SSDKPlatformSubTypeQQFriend)]
                 onImport:^(SSDKPlatformType platformType) {
                     switch (platformType) {
                         case SSDKPlatformTypeSinaWeibo:

                             [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                             break;
                        case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             break;
                         case SSDKPlatformSubTypeQQFriend:
                             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                             break;
                         default:
                             break;
                     }
                 } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                     switch (platformType) {
                         case SSDKPlatformTypeSinaWeibo:
                             [appInfo SSDKSetupSinaWeiboByAppKey:@"977035606"
                                                       appSecret:@"e26c3e1694fa32dad49d70453435bc92"
                                                     redirectUri:@"http://www.baidu.com"
                                                        authType:SSDKAuthTypeBoth];
                             break;
                         case SSDKPlatformTypeYinXiang:
                             [appInfo SSDKSetupEvernoteByConsumerKey:@"flyxiongq"
                                                      consumerSecret:@"b4267e66c2afefdd"
                                                             sandbox:YES];

                             break;
                         case SSDKPlatformTypeWechat:
                             [appInfo SSDKSetupWeChatByAppId:@"test" appSecret:@"rect"];

                             break;
                         case SSDKPlatformSubTypeQQFriend:
                             [appInfo SSDKSetupQQByAppId:@"test" appKey:@"test" authType:@"test"];

                             break;
                         default:
                             break;
                     }
                 }];


    return YES;
}
-(UIViewController *)viewcontroller{
    if (!_viewcontroller) {
    
//        _viewcontroller  = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]].instantiateInitialViewController;
        UIStoryboard *temp = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        _viewcontroller = [temp instantiateViewControllerWithIdentifier:@"homeNavi"];
    }
    return _viewcontroller;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

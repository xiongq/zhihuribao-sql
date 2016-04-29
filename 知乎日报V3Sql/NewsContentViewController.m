//
//  NewsContentViewController.m
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/22.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "NewsContentViewController.h"
#import "checkDiscussionViewController.h"
#import "commentsViewController.h"

#import "WebControllerContentPicView.h"
#import "WebContentView.h"
#import "ContentToolsView.h"
#import "XQloading-CAShaplayer.h"

#import "NewsRequest.h"
#import "StatusWindow.h"
#import "UIView+Extension.h"

#import "ZHNewsModel.h"
#import "ZHHomeListModel.h"
#import "commentsModel.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <UINavigationController+FDFullscreenPopGesture.h>

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>


@interface NewsContentViewController ()<UIWebViewDelegate,UIScrollViewDelegate,ContentToolsViewDelegate,XQloading_CAShaplayeDelegate>
/** webview*/
@property (weak, nonatomic) IBOutlet WebContentView              *webContent;
/** 工具条*/
@property (weak, nonatomic) IBOutlet ContentToolsView            *ContentTools;
/** 顶部图片信息View*/
@property (weak, nonatomic) IBOutlet WebControllerContentPicView *topPicView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint          *topPicHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint          *topPicTop;
/** 顶部白条*/
@property (weak, nonatomic) IBOutlet UIView                      *status;
@property (strong, nonatomic) XQloading_CAShaplayer *loading;
@end

@implementation NewsContentViewController
{
    /** 索引*/
    NSIndexPath *path;
    /** 是否拿到数据*/
    BOOL isachieve;

    ZHNewsModel *tempModel;

    NSString *tempdic;
}
-(XQloading_CAShaplayer *)loading{
    if (!_loading) {
        _loading =[[XQloading_CAShaplayer alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height -44)];
        _loading.backgroundColor = [UIColor whiteColor];
        _loading.delegate = self;
        [self.view addSubview:_loading];
        [_loading SetErrorText:@"网络错误请重试"];
        [_loading SetlayersLineWidth:5 strokeColor:[UIColor lightGrayColor] layerFrameAndPath:CGRectMake(0, 0, 40, 40)];
    }
    return _loading;
}
#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.webContent.delegate                  = self;
    self.webContent.scrollView.delegate       = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.fd_prefersNavigationBarHidden        = YES;

    path = self.indexpath;
    [self  firstNews:path];
    self.ContentTools.delegate = self;

    /**接收通知：数据存取到SQL通知*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotificationSelector) name:@"savesucceed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BackTop) name:@"backTop" object:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [StatusWindow sharedTopWindow].statusBarStyle = UIStatusBarStyleLightContent;
}
-(void)NextNewsAnimation{
    CGAffineTransform offsetUp = CGAffineTransformMakeTranslation(0, -self.view.height);
    UIEdgeInsets edge = UIEdgeInsetsMake(0, 0, 0, 0);
    UIView *fromView = [self.view resizableSnapshotViewFromRect:self.webContent.frame afterScreenUpdates:YES withCapInsets:edge];
    [self.view addSubview:fromView];
    [UIView animateWithDuration:0.4 animations:^{
        fromView.transform = offsetUp;
    } completion:^(BOOL finished) {
        [fromView removeFromSuperview];
    }];

}
#pragma mark - 自定义方法
-(void)BackTop{
    if (self.webContent.scrollView.contentOffset.y == 0)return;
    [self.webContent.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
}
/** 加载新闻*/
-(void)firstNews:(NSIndexPath *)paths{
    [self.loading StartAnimation];
    [self.topPicView setImageWithTitle:nil];
    NSArray *temp                = self.DateWithStorySUMArray[paths.section];
    NSArray *storys              = [Stories mj_objectArrayWithKeyValuesArray:temp];
    Stories *model               = storys[paths.row];
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.requestSerializer     = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer    = [AFJSONResponseSerializer serializer];
    NSString *urls               = [@"http://news-at.zhihu.com/api/4/news/" stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)model.id] ];
    NSString *storyCommitUrl = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/story-extra/%ld",(long)model.id];
    [manger GET:urls parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZHNewsModel *model =[ZHNewsModel mj_objectWithKeyValues:responseObject];
        [self.topPicView setImageWithTitle:model];
        [self.webContent loadWeb:model];
        tempModel = model;
        isachieve = NO;
        path = paths;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"web--错误%@",error);
        [self.loading waitReload];
    }];

    [manger GET:storyCommitUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.ContentTools setComments:responseObject];
        NSLog(@"%@",responseObject[@"comments"]);
        tempdic = responseObject[@"comments"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"com--错误%@",error);
    }];
}
/**
 *  点击下一个时判断索引存在，自动加1
 *  @return 有->yes
 */
-(BOOL)NextNewsJudge{
    /** 有木有数据*/
    BOOL HaveDate = YES;

    /** 索引*/
    NSIndexPath *index   = path;
    /** 索引的scetion*/
    NSInteger dateIndex  = index.section;
    /** 索引的row*/
    NSInteger storyIndex = index.row;
    /** 日期数组个数*/
    NSInteger dateCount  = self.DateArray.count;

//    点击传过来的索引 注意index是0开始  count是1开始 等于就越界
    if (dateIndex < dateCount) {
            NSArray *StoryCount = self.DateWithStorySUMArray[dateIndex];
            /** 在日期数组内，继续判断日期数组中storyindex是否存在*/
        if (storyIndex < StoryCount.count) {
            /** 在日期数组内，date日期不变，storyindex + 1 ；赋值前判断+1可能存在的越界*/
            if (storyIndex +1 == StoryCount.count) {
                //因为inde（0.1.2.3.。。）始终 是比数组个数小1的（1.2.3.4...）
                storyIndex = 0;
                //如果故事索引+1 == 故事个数，#（index 1 ，count 2）， index+1 = 2（0，1，2）大于数组个数->越界
                    if (dateIndex + 1 < dateCount) {
                        //dateindex加1还在范围内就+1
                        dateIndex++;
                    }else{//若等于
                        //说明是到最后了，设置bool没有数据了
                        HaveDate = NO;
                    }
              }else{
                  //+1小于！=storycount，那么说明没到该日期最后一个
                    storyIndex++;
                }
            }
        }else{
             /** 没有日期数据，通知去加载下一个日期的数据回来*/
            HaveDate = NO;
//            dateIndex++;
//            storyIndex = 0;

    }
    if (HaveDate == YES) {
        //有数据，就把索引更新为下一个的索引
        NSIndexPath *temp = [NSIndexPath indexPathForRow:storyIndex inSection:dateIndex];
        path = temp;
    }
    return HaveDate;
}
/**
 *  通知方法
 */
-(void)NotificationSelector{
    isachieve = YES;
    NSIndexPath *temp = [NSIndexPath indexPathForRow:0 inSection:path.section +1];
    [self firstNews:temp];
}
#pragma mark - 代理
-(void)reload{
    NSLog(@"reload_test");
    [self.loading StartAnimation];
    [self firstNews:path];


}
/**
 *  工具条代理
 */
-(void)TouchinsideBtnType:(BtnType)BtnType{
    NSArray *imagesArrays = @[[UIImage imageNamed:@"News_Navigation_Share_Highlight"]];
    switch (BtnType) {
        case arrows:
//            NSLog(@"返回");
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case next:
            NSLog(@"下一个");
            [self NextNewsAnimation];
//            NSLog(@"%@",path);
            /** 根据当前索引判断有没有*/
           BOOL haveData = [self NextNewsJudge];
            if (haveData) {
                //存在 就按加1索引去请求下一个的数据
                 [self firstNews:path];
//                NSLog( @"有--------------");
            }else{
                //没有让代理去拿数据，如果代理拿到数据了就放弃执行
                if (isachieve == NO) {
                    if ([self.delegate respondsToSelector:@selector(LoadMoreNews)]) {
                        [self.delegate LoadMoreNews];
                        }
                }
            }
            break;
        case vote:
            NSLog(@"点赞");

            break;
        case share:
            if (imagesArrays) {
                NSMutableDictionary *shareParams = [NSMutableDictionary new];
                [shareParams SSDKSetupShareParamsByText:[tempModel.title stringByAppendingFormat:@"(数据来源于知乎日报，测试-shareSDK @xiongqtest )%@",tempModel.share_url]
                                                 images:nil
                                                    url:[NSURL URLWithString:tempModel.share_url]
                                                  title:tempModel.title
                                                   type:SSDKContentTypeAuto];
                [shareParams SSDKSetupEvernoteParamsByText:@"test"
                                                    images:nil
                                                     title:@"dasdasdasda"
                                                  notebook:@"First Notebook"
                                                      tags:@[@"Evernote",@"block"] platformType:SSDKPlatformTypeEvernote];

                [ShareSDK showShareActionSheet:nil
                                         items:nil
                                   shareParams:shareParams
                           onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                               switch (state) {
                                   case SSDKResponseStateSuccess:
                                   {
                                       NSLog(@"sucess");
                                       UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"分享成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
                                       UIAlertAction *defulaction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

                                       }];
                                       [alertView addAction:defulaction];
                                       [self presentViewController:alertView animated:YES completion:nil];
                                       break;
                                   }
                                   case SSDKResponseStateFail:
                                   {

                                       UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"分享失败" message:[NSString stringWithFormat:@"%@",error] preferredStyle:UIAlertControllerStyleAlert];
                                       UIAlertAction *defulaction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

                                       }];
                                       [alertView addAction:defulaction];
                                       [self presentViewController:alertView animated:YES completion:nil];
                                       break;
                                   }
                                   default:
                                       break;
                               }
                           }];
            }

            break;
        case comment:


//            [self commentsWithids:tempModel.id];
        {
            commentsViewController *com = [self.storyboard instantiateViewControllerWithIdentifier:@"comments"];
            com.sumcomm = [NSString stringWithFormat:@"%@条评论",tempdic];
            com.ids = tempModel.id;

            [self.navigationController pushViewController:com animated:YES];
            break;
        }

    }
}


/**
 *  scrollview代理
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"%f",scrollView.contentOffset.y);
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 0) {
        self.topPicTop.constant = - offsetY;
    }else{
        self.topPicTop.constant = 0;
        self.topPicHeight.constant = 220 - offsetY;
        if (offsetY <= -60) {
            self.webContent.scrollView.contentOffset = CGPointMake(0, -64);
        }
    }
    if (offsetY > 200) {
        self.status.alpha =1;
        [StatusWindow sharedTopWindow].statusBarStyle = UIStatusBarStyleDefault;
    }else{
        self.status.alpha =0;
        [StatusWindow sharedTopWindow].statusBarStyle = UIStatusBarStyleLightContent;
    }
    [self.topPicView updateConstraints];
    [self.view layoutIfNeeded];
}
/**
 *  webview代理
 */
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        checkDiscussionViewController *checkdiscussionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"check"];
        checkdiscussionVC.urls = [NSString stringWithFormat:@"%@",request.URL];;
        [self.navigationController pushViewController:checkdiscussionVC animated:YES];
        return NO;
    }
    return YES;
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
//    [self.loading StartAnimation];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.loading StopAnimation];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self.loading waitReload];
}
-(void)dealloc{
    NSLog(@"wed delloc");
    self.webContent.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end

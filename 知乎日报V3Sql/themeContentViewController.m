//
//  themeContentViewController.m
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/30.
//  Copyright © 2016年 xiong. All rights reserved.
//  换成WKWebview 还有处bug：loading动画时作者view层级不应该在loadingview之上


#import "themeContentViewController.h"
#import "avaterView.h"
#import "ContentToolsView.h"
#import "NewsRequest.h"
#import "themeContentModel.h"
#import <MJExtension.h>
#import <AFNetworking.h>
#import "themeStorySQLTool.h"
#import "avaterEditorSQL.h"
#import "AvaterViewController.h"
#import <UINavigationController+FDFullscreenPopGesture.h>
#import <WebKit/WebKit.h>
#import <Masonry.h>
#import "UIView+Extension.h"
#import "XQloading-CAShaplayer.h"
#import "commentsViewController.h"

@interface themeContentViewController ()<ContentToolsViewDelegate, avaterviewDelegate, XQloading_CAShaplayeDelegate, WKUIDelegate, WKNavigationDelegate>
@property (weak, nonatomic) IBOutlet avaterView         *avaterview;
@property (weak, nonatomic) IBOutlet ContentToolsView   *contentTools;
//@property (weak, nonatomic) IBOutlet UIWebView          *webContentView;
@property (strong, nonatomic)  WKWebView          *webContentView;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webtoViewConstrainsTOP;
@property (strong, nonatomic) XQloading_CAShaplayer *loading;
@end

@implementation themeContentViewController{
    BOOL isanimation;
    NSInteger index;
    ZHNewsModel *tempModel;
    NSString *tempdic;
}
/**
 *  懒加载
 */
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
-(WKWebView *)webContentView{
    if (!_webContentView) {
        /// 配置configuration 保证全屏
        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:wkUScript];
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        wkWebConfig.userContentController = wkUController;
        _webContentView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height- 64 -44) configuration:wkWebConfig];
        _webContentView.UIDelegate= self;
        _webContentView.navigationDelegate = self;


    }
    return _webContentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /**
     *  隐藏当前控制器navibar，及顶部空白
     */
    self.fd_prefersNavigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentTools.delegate = self;
    self.avaterview.delegate = self;
    index = self.indexpath.row;
    themeContentModel *sqlModel =  [themeStorySQLTool readSQLThemeStoryWithid:self.model.id];
    if (sqlModel) {
        //数据库中-有就加载数据库中的模型，（有一种body是空的，没有存）
//        NSLog(@"数据库中有数据");
        [self loadHtml:sqlModel];

    }else{
//        NSLog(@"没有数据");
        //数据库中-没有-发送请求，（有一种body是空的）
        [NewsRequest GETThemesWithID:self.model.id Succees:^(id dic) {

            //成功返回数据，转模型存取sqlite

            themeContentModel *model = [themeContentModel mj_objectWithKeyValues:dic];
            [themeStorySQLTool SaveThemeStory:model];
//            NSLog(@"avater-----%lu",(unsigned long)model.recommenders.count);
            //模型中body空
            if (model.body) {
                    [self loadHtml:model];
                }else{
                    //模型中body空，加载share-url
                    [self.webContentView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:model.share_url]]];
            }

        } Error:^(NSError *error) {
            [self.loading waitReload];
        }];
    }
    [self loadcommients];
    [self.view addSubview:self.webContentView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BackTop) name:@"backTop" object:nil];
}
-(void)BackTop{
    if (self.webContentView.scrollView.contentOffset.y == 0)return;
    [self.webContentView.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];

}
-(void)loadcommients{
    NSString *storyCommitUrl = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/story-extra/%ld",(long)self.model.id];
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.requestSerializer     = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer    = [AFJSONResponseSerializer serializer];
    [manger GET:storyCommitUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.contentTools setComments:responseObject];
        NSLog(@"contentTools%@",responseObject[@"comments"]);
        tempdic = responseObject[@"comments"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"com--错误%@",error);
    }];

}
-(void)loadHtml:(themeContentModel *)model{
//    http://news-at.zhihu.com/api/4/story/7015707/recommenders 这是推荐者
    if ([model.recommenders firstObject]) {
        self.avaterview.hidden = NO;
        /**
         *  顶部主编视图的显示隐藏，更改webview尺寸
         */
        self.webContentView.y = 64;
        self.webContentView.height = self.view.height - 64 -44;

        [self.avaterview newsID:model.id];
        [self.avaterview sendEditorsArray:(NSMutableArray *)model.recommenders];
    }else{
        self.avaterview.hidden = YES;
        self.webContentView.y= 0;
        self.webContentView.height = self.view.height - 44;

    }
    NSURL *css = [NSURL URLWithString:[model.css firstObject]];


    NSString *news = [NSString stringWithFormat:@"<!DOCTYPE><html><head><link  rel=\"stylesheet\" href= %@> </head> <body>%@</body></html>",css,model.body];
    [self.webContentView loadHTMLString:news baseURL:nil];


}
-(void)NextNewsAnimation{
    CGAffineTransform offsetUp = CGAffineTransformMakeTranslation(0, -self.view.height);
    UIEdgeInsets edge = UIEdgeInsetsMake(0, 0, 0, 0);
    UIView *fromView = [self.view resizableSnapshotViewFromRect:self.webContentView.frame afterScreenUpdates:YES withCapInsets:edge];
    [self.view addSubview:fromView];
    [UIView animateWithDuration:0.7 animations:^{
        fromView.transform = offsetUp;
    } completion:^(BOOL finished) {
        [fromView removeFromSuperview];
    }];

}

#pragma mark - toolsbarDelegate
/**
 *  工具栏delegate
 */
-(void)TouchinsideBtnType:(BtnType)BtnType{
    switch (BtnType) {
        case arrows:
            //            NSLog(@"返回");
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case next:


            NSLog(@"下一个");

            NSInteger count = self.storysArray.count;
            if (index < count - 1) {
                [self NextNewsAnimation];
                
                if (isanimation == NO) {
                    [self.loading StartAnimation];
                    isanimation = YES;
                }

                index++;
                self.model = self.storysArray[index];

                [self NextNewsWithid:self.model.id];
                [self loadcommients];

            }
            if (index == count - 1) {
#warning 需要处理下到达最后一个按键不能点击，delegate请求成功需要通知，才能继续下一步
//                UIButton *btn = [self.view viewWithTag:next];
//                btn.enabled = NO;
                if ([self.delegate respondsToSelector:@selector(LoadMoreNews)]) {
                    [self.delegate LoadMoreNews];
                }
            }

            break;
        case vote:
            NSLog(@"点赞");

            break;
        case share:
            NSLog(@"分享");
            break;
        case comment:
            NSLog(@"评论");
            commentsViewController *com = [self.storyboard instantiateViewControllerWithIdentifier:@"comments"];
            com.sumcomm = [NSString stringWithFormat:@"%@条评论",tempdic];
            com.ids = self.model.id;

            [self.navigationController pushViewController:com animated:YES];
            break;

    }

}
/**
 *  载入动画，网络请求失败代理
 */
-(void)reload{


}
#pragma mark - wkwebviewnavidelegate
/**
 *  开始加载
 */
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    if (isanimation == NO) {
        [self.loading StartAnimation];
        isanimation = YES;
    }


}
/**
 *  完成加载
 */
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{

    [self.loading StopAnimation];
    isanimation = NO;
}
/**
 *  失败
 */
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [self.loading waitReload];
}
/**
 *  点击主编view push控制器
 *
 *  @param editorsArray 主编模型
 */
-(void)avaterTouch:(NSMutableArray *)editorsArray{
    AvaterViewController *avaterVC = [self.storyboard instantiateViewControllerWithIdentifier:@"avatervc"];
    avaterVC.editerArray = editorsArray;
    [self.navigationController pushViewController:avaterVC animated:YES];

}
/**
 *  通过id查找文章
 *
 *  @param ids id
 */
-(void)NextNewsWithid:(NSInteger)ids{
    themeContentModel *sqlModel =  [themeStorySQLTool readSQLThemeStoryWithid:ids];
    if (sqlModel) {
        //数据库中-有就加载数据库中的模型，（有一种body是空的，没有存）
        NSLog(@"数据库中有数据");
        [self loadHtml:sqlModel];
    }else{
        NSLog(@"没有数据");
        //数据库中-没有-发送请求，（有一种body是空的）
        [NewsRequest GETThemesWithID:ids Succees:^(id dic) {
//            [self.loading StopAnimation];
            //成功返回数据，转模型存取sqlite
            themeContentModel *model = [themeContentModel mj_objectWithKeyValues:dic];
            [themeStorySQLTool SaveThemeStory:model];
            //模型中body空
            if (model.body) {
                [self loadHtml:model];
            }else{
                //模型中body空，加载share-url
                [self.webContentView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:model.share_url]]];
            }
        } Error:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

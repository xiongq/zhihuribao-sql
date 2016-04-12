//
//  themeContentViewController.m
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/30.
//  Copyright © 2016年 xiong. All rights reserved.
//  换成WKWebview


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

@interface themeContentViewController ()<ContentToolsViewDelegate, avaterviewDelegate>
@property (weak, nonatomic) IBOutlet avaterView         *avaterview;
@property (weak, nonatomic) IBOutlet ContentToolsView   *contentTools;
//@property (weak, nonatomic) IBOutlet UIWebView          *webContentView;
@property (strong, nonatomic)  WKWebView          *webContentView;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webtoViewConstrainsTOP;

@end

@implementation themeContentViewController{

    NSInteger index;
}
/**
 *  懒加载
 */
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
    [self.view addSubview:self.webContentView];



    self.contentTools.delegate = self;
    self.avaterview.delegate = self;
    index = self.indexpath.row;
    themeContentModel *sqlModel =  [themeStorySQLTool readSQLThemeStoryWithid:self.model.id];
    if (sqlModel) {
        //数据库中-有就加载数据库中的模型，（有一种body是空的，没有存）
        NSLog(@"数据库中有数据");
        [self loadHtml:sqlModel];
    }else{
        NSLog(@"没有数据");
        //数据库中-没有-发送请求，（有一种body是空的）
        [NewsRequest GETThemesWithID:self.model.id Succees:^(id dic) {
            //成功返回数据，转模型存取sqlite
            themeContentModel *model = [themeContentModel mj_objectWithKeyValues:dic];
            [themeStorySQLTool SaveThemeStory:model];
            NSLog(@"avater-----%lu",(unsigned long)model.recommenders.count);
            //模型中body空
            if (model.body) {
                    [self loadHtml:model];
                }else{
                    //模型中body空，加载share-url
                    [self.webContentView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:model.share_url]]];
            }
        } Error:^(NSError *error) {
            
        }];
    }



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

                index++;
                self.model = self.storysArray[index];
                NSLog(@"ids%ld",(long)self.model.id);
                [self NextNewsWithid:self.model.id];

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
            break;
        default:
            break;
    }

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

@end

//
//  ViewController.m
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/17.
//  Copyright © 2016年 xiong. All rights reserved.
//
//列表的网络加载显示和数据库缓存了
//1.AFN获取数据---请求分离到模型中做
//2.数据转模型或是先存数据库，取出时转模型（？）
//3.fmdb处理数据库的查询存取更新删

#import "ViewController.h"
#import "SideMenuViewController.h"
#import "NewsContentViewController.h"

#import "StoryListTableViewCell.h"
#import "TopStoryScrollView.h"
#import "RefreshView.h"
#import "oneTopStoryImageAndTittle.h"

#import "UIView+Extension.h"
#import "ZFSqlTools.h"
#import "DataUtils.h"
#import <MJExtension.h>
#import <Masonry.h>
#import <UINavigationController+FDFullscreenPopGesture.h>

#import "StatusWindow.h"
#import "NewsRequest.h"

#import "testViewController.h"

#import "sideModel.h"

#define kheight 220
#define sidewidth 240
#define RefreshOffsetY 40

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,NewsContentViewDelegate,SideMenuCellDelegate,TopStoryScrollViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableviewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topScrollHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TopScrollTOP;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BasicViewAutoLayoutRigh;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BasicViewAutoLayoutLeft;
/**基础view，动画*/
@property (weak, nonatomic) IBOutlet UIView *BasicView;

@property (weak, nonatomic) IBOutlet UITableView *StoryListTableView;
@property (strong, nonatomic) IBOutlet TopStoryScrollView *topScrollView;
/**加Navig导航条*/
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIStackView *refreshLabelStack;
@property (weak, nonatomic) IBOutlet UIView *StatusBar;
@property (weak, nonatomic) IBOutlet RefreshView *loadingView;
@property(strong, nonatomic) testViewController *testVC;

@property(strong, nonatomic) UIView *testView;
@property(strong, nonatomic) UIView *tempView;

/**侧菜单*/
@property(strong, nonatomic) SideMenuViewController *sideMenu;
/**详情控制器*/
@property(weak, nonatomic) NewsContentViewController *newsVC;
/**顶部滑动新闻view*/
@property (strong, nonatomic) oneTopStoryImageAndTittle *one;
@property (weak, nonatomic) IBOutlet TopStoryScrollView *scrollnews;
/**侧菜单滑动手势*/
@property(strong, nonatomic) UIPanGestureRecognizer *pan;
/**故事数组*/
@property(strong, nonatomic) NSMutableArray *menuItems;
/**日期数组*/
@property(strong, nonatomic) NSMutableArray *sectionTitleAray;

@end

@implementation ViewController{
    /** 侧边菜单显示*/
    BOOL isShowSideMenu;
    /** 正在刷新*/
    BOOL isRefreshing;
    /** 到达底部*/
    BOOL isloadBottom;
    BOOL isAnimation;
    CGFloat offsetx;
    BOOL DateJudge;
}
static CGFloat const SideMenuAnimationDuration = 0.5f;
#pragma mark - 懒加载
-(NSMutableArray *)menuItems{
    if (!_menuItems) {
        _menuItems = [NSMutableArray array];
    }
    return _menuItems;
}
-(NSMutableArray *)sectionTitleAray{
    if (!_sectionTitleAray) {
        _sectionTitleAray = [NSMutableArray array];
    }
    return _sectionTitleAray;
}
-(SideMenuViewController *)sideMenu{
    if (!_sideMenu) {
        _sideMenu = [[SideMenuViewController alloc] initWithNibName:@"SideMenuViewController" bundle:nil];
    }
    return _sideMenu;
}
-(testViewController *)testVC{
    if (!_testVC) {
        _testVC = [[testViewController alloc] init];

    }
    return _testVC;
}


-(UIPanGestureRecognizer *)pan{
    if (!_pan) {
        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slideGesture:)];
    }
    return _pan;
}

#pragma mark 生命周期
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BackTop) name:@"backTop" object:nil];
    /**
     *  根据bool值判断，避免反复进行数据库查询判断
     */
    if (DateJudge) return;
    NSArray *dateArray = [NSArray new];
    dateArray = [[ZFSqlTools StoryWithDate:nil] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSComparisonResult result = [obj1 compare:obj2];
        return result == NSOrderedAscending;

    }];
    /**
     *  数据库中存的日期和请求日期不一样的，请求20160419的新闻，返回的是20160418的新闻。最后一个日期重复这样是避免用户关闭APP时数据库中存取的当天新闻不全
     */
//    NSLog(@"%@",dateArray [1]);
    if (dateArray.count == 0) return;
    [DataUtils comparNowDateString:dateArray [0]];
//    [DataUtils comparNowDateString:@"20160415"];
    DateJudge = YES;

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.scrollnews.timer setFireDate:[NSDate distantPast]];

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.scrollnews.timer setFireDate:[NSDate distantFuture]];
//    self.BasicViewAutoLayoutLeft.constant = 0;
//    self.BasicViewAutoLayoutRigh.constant = 0;
//    NSLog(@"viewWillDisappear%@---%@",self.tempVC.view,self.testVC.view);
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

//    NSLog(@"viewDidDisappear%@---%@",self.tempVC.view,self.testVC.view);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backTop" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.fd_interactivePopDisabled     = YES;
    //状态栏样式
    [StatusWindow sharedTopWindow].statusBarStyle = UIStatusBarStyleLightContent;
    isloadBottom = YES;
    [self readSqlStory];
    [NewsRequest todayNEWSRequest];

    [self.StoryListTableView registerNib:[UINib nibWithNibName:@"StoryListTableViewCell" bundle:nil ] forCellReuseIdentifier:@"storylists"];
    self.StoryListTableView.dataSource = self;
    self.StoryListTableView.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //sideMenu初始化
    self.sideMenu.view.frame = CGRectMake(-sidewidth, 0, sidewidth, self.view.height);
    [self.view addSubview:self.sideMenu.view];
    [self addChildViewController:self.sideMenu];
    [self.sideMenu didMoveToParentViewController:self];
    isShowSideMenu= NO;
    self.sideMenu.delegate = self;
    [self.view addGestureRecognizer:self.pan];
    self.topScrollView.delegate = self;









    /**通知 返回顶部*/

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readSqlWithReload) name:@"savesucceed" object:nil];
}
#pragma mark 数组排序和数据加载
-(NSArray *)ArrayCompareAscending:(NSArray *)arr{
    NSArray *temp = [arr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSComparisonResult result =  [obj1[@"ga_prefix"] compare:obj2[@"ga_prefix"] ];
        //NSOrderedAscending 降序    NSOrderedDescending升序
        return result == NSOrderedAscending;
    }];
    return temp;
}

-(BOOL)readSqlStory{
    // 每次查询都会重复添加已经有的日期，导致加载的都是重复的。已经fix
    NSMutableArray *test = [NSMutableArray new];
    NSArray *dateArray = [NSArray new];
    dateArray = [[ZFSqlTools StoryWithDate:nil] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSComparisonResult result = [obj1 compare:obj2];
        return result == NSOrderedAscending;

    }];
    self.sectionTitleAray = (NSMutableArray *)dateArray;

    if (self.sectionTitleAray.count) {
        for (NSString *date in self.sectionTitleAray) {
            NSArray *temp = [self ArrayCompareAscending:[ZFSqlTools StoryWithDate:date]];
                        NSLog(@"%lu",(unsigned long)temp.count);
            [test addObject:temp];
        }
        self.menuItems = test;
        return YES;
    }else{
        return NO;
    }


}
#pragma mark - 收到通知处理和给详情更新数据
-(void)readSqlWithReload{
    [self.loadingView stopAnimation];
    if ([self readSqlStory]) {
        [self.StoryListTableView reloadData];
        if (self.newsVC) {
            self.newsVC.DateArray = self.sectionTitleAray;
            self.newsVC.DateWithStorySUMArray = self.menuItems;
        }
    }
}
#pragma mark - TableView数据源和头设置
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionTitleAray.count;
}
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    NSArray *dateArray = self.menuItems[section];

    return dateArray.count;
}
//头高
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 44;
}
//头文字
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
    header.backgroundColor = [UIColor colorWithRed:0.0667 green:0.478 blue:0.804 alpha:1];
    UILabel *dataLabel = [[UILabel alloc]initWithFrame:header.bounds];

    dataLabel.text = [DataUtils weeksWithDays:self.sectionTitleAray[section]];
    dataLabel.textColor = [UIColor whiteColor];
    dataLabel.textAlignment = NSTextAlignmentCenter;
    dataLabel.font = [UIFont systemFontOfSize:15];
    [header addSubview:dataLabel];

    return header;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StoryListTableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"storylists" forIndexPath:indexPath];
    if (self.menuItems.count) {
        NSArray *temp =  self.menuItems[indexPath.section];
        NSArray *storyArray = [Stories mj_objectArrayWithKeyValuesArray:temp];
        [cell sendModel:storyArray[indexPath.row]];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //判断当前点击时sideMenu是否隐藏
    if (isShowSideMenu) {
        [self hidenSideMenus];
        return;
    }
    NewsContentViewController *newsController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewsController"];
    newsController.indexpath = indexPath;
    newsController.DateWithStorySUMArray = self.menuItems;
    newsController.DateArray = self.sectionTitleAray;
    newsController.delegate = self;
    self.newsVC = newsController;
    [self.navigationController pushViewController:newsController animated:YES];
}
#pragma mark - 侧菜单显示隐藏处理
/** 点击非侧滑菜单隐藏*/
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"eeee");
    if (isShowSideMenu) {
         [self hidenSideMenus];

    }
}
/** 显示菜单*/
- (IBAction)showSideMenu:(id)sender {
    self.BasicViewAutoLayoutLeft.constant =sidewidth;
    self.BasicViewAutoLayoutRigh.constant = -sidewidth;
    [self.BasicView setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:SideMenuAnimationDuration animations:^{
        self.sideMenu.view.x = 0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        isShowSideMenu = YES;
    }];
}
/** 隐藏菜单*/
-(void)hidenSideMenus{
    [UIView animateWithDuration:SideMenuAnimationDuration animations:^{
        self.sideMenu.view.x = -sidewidth;
        self.BasicView.x = 0;
        self.BasicViewAutoLayoutLeft.constant = 0;
        self.BasicViewAutoLayoutRigh.constant = 0;

        [self.BasicView setNeedsUpdateConstraints];
    } completion:^(BOOL finished) {
        isShowSideMenu = NO;
    }];
}
/** 滑动 显示菜单*/
-(void)slideGesture:(UIPanGestureRecognizer *)slidePanGesture{
    offsetx = [slidePanGesture translationInView:self.view].x;
    if (offsetx > 0 && offsetx < sidewidth ) {
//        NSLog(@"offset%f",self.BasicViewAutoLayoutLeft.constant );
        self.sideMenu.view.x = offsetx -sidewidth;
        self.BasicViewAutoLayoutLeft.constant = offsetx;
        self.BasicViewAutoLayoutRigh.constant = -offsetx;
        [self.BasicView setNeedsUpdateConstraints];


    }
    if (slidePanGesture.state == UIGestureRecognizerStateEnded) {
        if (offsetx >= 120) {
            [self showSideMenu:nil];
        }else{
            NSLog(@"hiden");
            [self hidenSideMenus];
        }
    }
}
#pragma mark - 详情页面代理webview
-(void)LoadMoreNews{
    [NewsRequest nextNEWSRequsetWith:[self.sectionTitleAray lastObject]];
}
-(void)TouchChangeVC:(id)dic{
    Others *other = dic;
    if (other.id) {
//        [self hidenSideMenus];
        testViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"testController"];

        vc.others = other;

        [self.navigationController pushViewController:vc animated:YES];


    }else{

        [self hidenSideMenus];
    }
}
#pragma mark - 顶部滚动点击代理
-(void)touchTapScroll:(NSInteger)ids{

    NSInteger row;
    NSInteger sectiong;

    NSString *date = [ZFSqlTools StoryWithids:[NSString stringWithFormat:@"%lu",(long)ids]];
    for (int i = 0; i < self.menuItems.count; i++) {
        if ([date isEqualToString:self.sectionTitleAray[i]]) {
            sectiong  = i;
            NSLog(@"index-sectiong-%d",i);
            break;
        }
    }

    /**
     *  遍历数组找出下标
     */
    NSArray *temp = self.menuItems[sectiong];
    NSArray *storyArray = [Stories mj_objectArrayWithKeyValuesArray:temp];
    for (int i = 0; i < storyArray.count; i++) {
        Stories *test = storyArray[i];
        if (ids == test.id) {
            row = i;
            NSLog(@"index-row-%d",i);
            break;
        }
    }
    NSIndexPath *index = [NSIndexPath indexPathForRow:row inSection:sectiong];
    NewsContentViewController *newsController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewsController"];
    newsController.indexpath = index;
    newsController.DateWithStorySUMArray = self.menuItems;
    newsController.DateArray = self.sectionTitleAray;
    newsController.delegate = self;
    self.newsVC = newsController;
    [self.navigationController pushViewController:newsController animated:YES];

}
#pragma mark - 下拉上拉处理scrolldelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsety = scrollView.contentOffset.y;

    if ([scrollView isEqual:self.StoryListTableView]) {
        if (offsety == 0) {
            [UIView animateWithDuration:0.3 animations:^{
                self.topView.backgroundColor = self.StatusBar.backgroundColor = [UIColor clearColor];
            }];

        }
        if (offsety > 0) {
            if (self.menuItems.count) {
             
            if (offsety >= 90 * [self.menuItems[0] count] +200) {
                self.refreshLabelStack.hidden= YES;
                self.topView.hidden = YES;
            }else{
                self.refreshLabelStack.hidden= NO;
                self.topView.hidden = NO;
            }
        }
             /**------------**/ /**------------**/
        self.TopScrollTOP.constant = -offsety;
//        self.topScrollHeight.constant = kheight;
        CGFloat alpha;
            if (offsety <= 40) {
                alpha = 0;
                }else{
                alpha = (offsety -40)/64;
                }
            /**------------**/ /**------------**/
         self.StatusBar.backgroundColor =  self.topView.backgroundColor = [UIColor colorWithRed:0.0667 green:0.478 blue:0.804 alpha:alpha];
            [self.loadingView updateProgress:0];
    }else {

            self.TopScrollTOP.constant = 0;
            self.topScrollHeight.constant = kheight - offsety;
        if (isRefreshing) {
            [self.loadingView updateProgress:0];
        }else{
            [self.loadingView updateProgress:-offsety/40];

        }

        self.topView.backgroundColor = self.StatusBar.backgroundColor = [UIColor clearColor];
            if (offsety <= -64) {
                self.StoryListTableView.contentOffset = CGPointMake(0, -64);
                }
        }
        [self.view layoutIfNeeded];
        if ((offsety + scrollView.height) > scrollView.contentSize.height) {
//            NSLog(@"到底了");
            if (isloadBottom) {
                return;
            }else{
                isloadBottom = YES;
                [NewsRequest nextNEWSRequsetWith:[self.sectionTitleAray lastObject]];
            }
        }
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //下拉刷新
    isloadBottom = NO;
    CGFloat offset = scrollView.contentOffset.y;
    if (offset < -44) {
        [NewsRequest todayNEWSRequest];
        [self.loadingView startAnimation];
    }
}

#pragma mark - 顶部点击放回顶部通知方法
-(void)BackTop{
    if (self.StoryListTableView.contentOffset.y == 0) return;
    [self.StoryListTableView setContentOffset:CGPointMake(0, 0) animated:YES ];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%s",__func__);
}
@end

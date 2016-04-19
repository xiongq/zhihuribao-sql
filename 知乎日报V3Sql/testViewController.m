//
//  testViewController.m
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/25.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "testViewController.h"
#import "AvaterViewController.h"
#import "themeIMG.h"
#import "StoryListTableViewCell.h"
#import "RefreshView.h"
#import "NewsRequest.h"
#import "sideThemeListModel.h"
#import "SideThemeAndThemeStorySQL.h"
#import "avaterEditorSQL.h"
#import "themeContentViewController.h"
#import <MJExtension.h>
#import "UIView+Extension.h"
#import <UIImageView+WebCache.h>
#import <UINavigationController+FDFullscreenPopGesture.h>

@interface testViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,themeContentViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *themeTableview;
@property (weak, nonatomic) IBOutlet themeIMG *themeImageVIew;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *themeImageHeight;
@property (weak, nonatomic) IBOutlet RefreshView *refreshView;
@property (weak, nonatomic) IBOutlet UILabel *ThemeNameLabei;
@property (strong, nonatomic) NSMutableArray *storiesArray;
@property (strong, nonatomic) NSMutableArray *editorsArray;
@property (strong, nonatomic) sideThemeListModel *temp;
@property (weak, nonatomic) themeContentViewController *themevc;



@end

@implementation testViewController{
    BOOL isbottom;
}
-(NSMutableArray *)storiesArray{
    if (!_storiesArray) {
        _storiesArray = [NSMutableArray new];
    }
    return _storiesArray;
}
-(NSMutableArray *)editorsArray{
    if (!_editorsArray) {
        _editorsArray = [NSMutableArray new];
    }
    return _editorsArray;
}
-(themeContentViewController *)themevc{
    if (!_themevc) {
        _themevc = [self.storyboard instantiateViewControllerWithIdentifier:@"themecontent"];
//        _themevc.delegate = self;

    }
    return _themevc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;

    [self.themeTableview registerNib:[UINib nibWithNibName:@"StoryListTableViewCell" bundle:nil ] forCellReuseIdentifier:@"storylists"];
    self.themeTableview.tableFooterView = [[UIView alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.ThemeNameLabei.text = self.others.name;

    sideThemeListModel *models =  [SideThemeAndThemeStorySQL readDataWithLimitORname:self.others.name limit:nil];

    if (models) {
            [self reloadTableViewWithModel:models];
        }else{
            [NewsRequest GETHTTPwithThemes:[NSString stringWithFormat:@"%ld",(long)self.others.id] Succees:^(id dic) {
            [SideThemeAndThemeStorySQL SaveStoryWithID:dic];
            sideThemeListModel *model = [sideThemeListModel mj_objectWithKeyValues:dic];
            [self reloadTableViewWithModel:model];
        } Error:^(NSError *error) {

        }];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BackTop) name:@"backTop" object:nil];
}
-(void)BackTop{
    if (self.themeTableview.contentOffset.y == 0)return;
    [self.themeTableview setContentOffset:CGPointMake(0, 0) animated:YES];

}
-(void)reloadTableViewWithModel:(sideThemeListModel *)model{
    self.temp = model;
    [self.themeImageVIew imageHTTP:model.background];
    self.storiesArray = (NSMutableArray *)model.stories;
    self.editorsArray = (NSMutableArray *)model.editors;
    [avaterEditorSQL SaveEditor:self.editorsArray];
    [self.themeTableview reloadData];

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.storiesArray) {
        return self.storiesArray.count;
    }
    return 20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StoryListTableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"storylists" forIndexPath:indexPath];
    if (self.storiesArray) {
    [cell sendSideModel:self.storiesArray[indexPath.row]];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    UIImageView *backLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Profile_Split"]];
    backLine.frame = CGRectMake(0, 39, self.view.frame.size.width, 0.5);
    [header addSubview:backLine];

    UILabel *editerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 40, 40)];
    editerLabel.font = [UIFont systemFontOfSize:15];
    editerLabel.text = @"主编";
    [header addSubview:editerLabel];
    for (int i = 0; i < self.editorsArray.count; i++) {
        Editors *edit = self.editorsArray[i];
        UIImageView *editAvater = [UIImageView new];
        
        editAvater.frame = CGRectMake(60 + 50*i, 5, 30, 30);
        editAvater.layer.cornerRadius = 15;
        editAvater.clipsToBounds = YES;
        [editAvater sd_setImageWithURL:[NSURL URLWithString: edit.avatar]];
        [header addSubview:editAvater];
    }

    UIButton *btn = [[UIButton alloc] initWithFrame:header.bounds];

    [btn addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:btn];

    return header;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    self.themevc = [self.storyboard instantiateViewControllerWithIdentifier:@"themecontent"];
    self.themevc.delegate = self;
    self.themevc.model = self.storiesArray[indexPath.row];
    self.themevc.indexpath = indexPath;
    self.themevc.storysArray = self.storiesArray;
    [self.navigationController pushViewController:self.themevc animated:YES];

}
-(void)test{
    AvaterViewController *avaterVC = [self.storyboard instantiateViewControllerWithIdentifier:@"avatervc"];
    avaterVC.editerArray = self.editorsArray;
    [self.navigationController pushViewController:avaterVC animated:YES];
}
-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
//    NSLog(@"%f",offsetY);
    if (offsetY > 0 ) {

    }else{
        self.themeImageHeight.constant = 64- offsetY;
        self.themeImageVIew.efffectView.alpha = 1 -((-offsetY)/ 64);

        if (offsetY < -108) {
            self.themeTableview.contentOffset= CGPointMake(0, -108);
        }
    }
    CGFloat bottom = self.themeTableview.contentSize.height;
    if (offsetY + self.themeTableview.height > bottom) {
        NSLog(@"到底了");
        if (isbottom) {
            return;
        }else{
            isbottom = YES;
            [self isbottomLoadBeforelast];
        }
    }
}
-(void)isbottomLoadBeforelast{
    ThemeStories *story = [self.storiesArray lastObject];
    [NewsRequest beforeLastID:story.id Succees:^(id dic) {

        NSArray *arr = dic[@"stories"];
        if (arr.count  == 0) {
            NSLog(@"没有更多");
        }else{

            NSLog(@"更多");
            sideThemeListModel *model = [sideThemeListModel mj_objectWithKeyValues:dic];
            for (int i = 0; i < model.stories.count; i++) {
                [self.storiesArray addObject:model.stories[i]];
            }

            self.temp.stories = self.storiesArray;
            NSDictionary *dic = [self.temp mj_keyValues];
            [SideThemeAndThemeStorySQL SaveStoryWithNoID:dic];
            [self.themeTableview reloadData];

            isbottom = NO;
            if (self.themevc) {
                self.themevc.storysArray = self.storiesArray;
            }
        }

    } Error:^(NSError *error) {
        NSLog(@"bottom%@",error);
        isbottom = YES;
    }];

}

-(void)LoadMoreNews{
    NSLog(@"delegate - loadNews");
    [self isbottomLoadBeforelast];
}
-(void)dealloc{
    NSLog(@"test ---- %@",self);
    self.themevc.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
@end

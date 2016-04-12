//
//  SideMenuViewController.m
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/17.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "SideMenuViewController.h"
#import "ImageWithLabelBtn.h"
#import "SideMenuTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "NewsRequest.h"
#import "sideModel.h"
#import <MJExtension.h>
#import "testViewController.h"
#import "SideThemeAndThemeStorySQL.h"

//#import <UINavigationController+FDFullscreenPopGesture.h>

@interface SideMenuViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *sideMenu;
@property(strong, nonatomic) NSArray *menuItems;
@property(strong, nonatomic) NSMutableArray *themeItems;
@property(strong, nonatomic) NewsRequest *tett;
@end

@implementation SideMenuViewController
static NSString *const cellIdentifier = @"cells";
- (IBAction)Signin:(id)sender {
    //登陆
}
- (IBAction)favor:(ImageWithLabelBtn *)sender {
    //收藏
}
- (IBAction)message:(ImageWithLabelBtn *)sender {
    //消息
}
- (IBAction)setting:(ImageWithLabelBtn *)sender {
    //设置
}
- (IBAction)download:(id)sender {

//     [SideThemeAndThemeStorySQL readDataWithLimitORname:0 limit:@"1000"];

}
- (IBAction)DayandNight:(id)sender {
    //白天夜晚的主题
//    [NewsRequest themsReques];
}
-(NSMutableArray *)themeItems{
    if (!_themeItems) {
        _themeItems = [NSMutableArray new];
    }
    return _themeItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.fd_interactivePopDisabled     = YES;
    [self.sideMenu registerNib:[UINib nibWithNibName:@"SideMenuTableViewCell" bundle:nil] forCellReuseIdentifier:@"cells"];
    self.sideMenu.dataSource = self;
    self.sideMenu.delegate = self;
    NSMutableArray *tempSql = [SideThemeAndThemeStorySQL readDataWithLimitORname:nil limit:@"1000"];
    if (tempSql.count != 0) {
        self.themeItems = [Others mj_objectArrayWithKeyValuesArray:tempSql];
        [self reloadTableview];
    }else{
        [NewsRequest GETHTTPwithThemes:nil Succees:^(id dic) {
            [SideThemeAndThemeStorySQL SaveStoryWithID:dic];
            self.themeItems = [Others mj_objectArrayWithKeyValuesArray:dic[@"others"]];
            [self reloadTableview];
        } Error:^(NSError *error) {
            NSLog(@"%@",error);
        }];

    }
}
-(void)reloadTableview{
    Others *temp = [Others new];
    temp.name = @"首页";
    [self.themeItems insertObject:temp atIndex:0];
    [self.sideMenu reloadData];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma make - TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.themeItems.count;
}
#pragma make - TableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SideMenuTableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"cells"
                                    forIndexPath:indexPath];
    Others *other = self.themeItems[indexPath.row];
    [cell sendsideModel:other];
    cell.textLabel.textColor = [UIColor grayColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{



    if ([self.delegate respondsToSelector:@selector(TouchChangeVC:)]) {
        Others *other = self.themeItems[indexPath.row];

        [self.delegate TouchChangeVC:other];
    }

}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"%@",NSStringFromCGPoint(scrollView.contentOffset));
//    UIColor *backgroundColor = [UIColor colorWithRed:0.106 green:0.125 blue:0.141 alpha:1];
//    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//    gradientLayer.frame = self.sideMenu.bounds;
//    gradientLayer.colors =
//    @[ (id)[UIColor clearColor].CGColor, (id)backgroundColor.CGColor];
//    gradientLayer.endPoint = CGPointMake(0.5, 0.8);
//    gradientLayer.startPoint = CGPointMake(0.5, 1);
//    self.sideMenu.layer.mask = gradientLayer;
}
@end

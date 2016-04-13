//
//  AvaterViewController.m
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/30.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "AvaterViewController.h"
#import "AvaterTableViewCell.h"
#import "NewsRequest.h"
#import "avaterINFOWebview.h"
#import <UINavigationController+FDFullscreenPopGesture.h>

@interface AvaterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *avaterTableview;

@end

@implementation AvaterViewController
- (IBAction)backUP:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.avaterTableview registerNib:[UINib nibWithNibName:@"AvaterTableViewCell" bundle:nil] forCellReuseIdentifier:@"avatercell"];
    self.avaterTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.editerArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AvaterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"avatercell"];
    Editors *editor = self.editerArray[indexPath.row];
    [cell sendEditerModel:editor];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Editors *editor = self.editerArray[indexPath.row];
    NSInteger avater = editor.id;
    NSString *avaterURL;
    if (editor.zhihu_url_token) {//token获取是在avaterView遍历存到数据库的
        NSLog(@"zhihu_url_token%@",editor.zhihu_url_token);
        avaterURL = [NSString stringWithFormat:@"https://www.zhihu.com/people/%@",editor.zhihu_url_token];
    }else{
        avaterURL = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/editor/%ld/profile-page/ios",(long)avater];

    }

    avaterINFOWebview *avaterVC = [self.storyboard instantiateViewControllerWithIdentifier:@"avaterINFO"];
    avaterVC.avaterurl = avaterURL;
    avaterVC.name = editor.name;
//    NSLog(@"%@",url);
    [self.navigationController pushViewController:avaterVC animated:YES];
    
//    [NewsRequest avaterinfo:editor.url Succees:^(id dic) {
//        NSLog(@"avater----%@",dic);
//    } Error:^(NSError *error) {
//        NSLog(@"error%@",error);
//    } ];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end

//
//  commentsViewController.m
//  知乎日报V3Sql
//
//  Created by xiong on 16/4/14.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "commentsViewController.h"
#import "commentsCell.h"
#import "NewsRequest.h"
#import "commentsModel.h"
#import <MJExtension.h>
#import <UINavigationController+FDFullscreenPopGesture.h>

@interface commentsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *commentsTable;
@property (weak, nonatomic) IBOutlet UIView *tools;
@property(strong, nonatomic) NSMutableArray *commentArray;

@end

@implementation commentsViewController
-(NSMutableArray *)commentArray{
    if (!_commentArray) {
        _commentArray = [NSMutableArray new];
    }
    return _commentArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.sumComments.text = self.sumcomm;
    [self commentsWithids:self.ids];
    [self.commentsTable registerNib:[UINib nibWithNibName:@"commentsCell" bundle:nil ] forCellReuseIdentifier:@"commentscell"];
    self.commentsTable.delegate = self;
    self.commentsTable.dataSource = self;
    self.commentsTable.estimatedRowHeight = 110;
    self.commentsTable.rowHeight = UITableViewAutomaticDimension;

}


-(void)commentsWithids:(NSInteger)ids{

    [NewsRequest shortCommentsWithIds:ids Succees:^(id dic) {
        if (dic[@"comments"] != nil) {
            NSArray *shorttemp = [Comments mj_objectArrayWithKeyValuesArray:dic[@"comments"]];
            [self.commentArray addObject:shorttemp];
        }
        [self.commentsTable reloadData];
    } Error:^(NSError *error) {
        NSLog(@"%@",error);
    }];

        [NewsRequest longCommentsWithIds:ids Succees:^(id dic) {
            if (dic[@"comments"] != nil) {
                NSArray *longtemp = [Comments mj_objectArrayWithKeyValuesArray:dic[@"comments"]];
                [self.commentArray  insertObject:longtemp atIndex:0];

            }

            [self.commentsTable reloadData];
            
        } Error:^(NSError *error) {
            NSLog(@"%@",error);
        }];





    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.commentArray.count;


}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.commentArray.count !=0) {
        NSArray *array = self.commentArray[section];
        return array.count;

    }else{

        return 0;
    }

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    commentsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentscell" forIndexPath:indexPath];

    Comments *model = self.commentArray[indexPath.section][indexPath.row];
    cell.authorLabei.text = model.author;
    if (model.reply_to) {
        NSString *replyauthor = model.reply_to[@"author"];
        NSString *replycontent = model.reply_to[@"content"];
        cell.contentTextView.text = [NSString stringWithFormat:@"%@//%@ %@",model.content,replyauthor,replycontent];
    }else{

        cell.contentTextView.text = model.content;
    }

    return cell;

}
//自定义SectionHeader
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    UILabel *rows = [[UILabel alloc] initWithFrame:header.frame];
    header.backgroundColor = [UIColor whiteColor];
    NSArray *temp = self.commentArray[section];
    if (section == 0) {
        rows.text = [NSString stringWithFormat:@"%ld条长论",temp.count];
    }else{
        rows.text = [NSString stringWithFormat:@"%ld条短论",temp.count];
    }

    rows.textAlignment = NSTextAlignmentLeft;

    [header addSubview:rows];
    return header;

}

//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    commentsCell *cell = self.commentsTable.visibleCells
//    CGRect rect = cell.contentTextView.frame;
//    CGFloat heights = rect.size.height;
//    UIFont *font = cell.contentTextView.font;
//    NSMutableDictionary *attrs = [NSMutableDictionary new];
//    attrs[NSFontAttributeName] = font;
//    CGSize maxsize = CGSizeMake(rect.size.width, MAXFLOAT);
//    CGSize temp = [cell.contentTextView.text boundingRectWithSize:maxsize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
//
//
//    return 110 + temp.height - heights;
//}

@end

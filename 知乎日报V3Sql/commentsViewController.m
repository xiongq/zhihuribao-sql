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
#import "UIView+Extension.h"
#import <UIImageView+WebCache.h>
#import <UINavigationController+FDFullscreenPopGesture.h>
#import "DataUtils.h"

@interface commentsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *commentsTable;
@property (weak, nonatomic) IBOutlet UIView *tools;
@property(strong, nonatomic) NSMutableArray *commentArray;

@end

@implementation commentsViewController{
    NSIndexPath *selecttemp;
    CGFloat rowsHeight;


}
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

    /**
     *  自动调整cell高度
     */
    self.commentsTable.estimatedRowHeight = 80;
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
    [cell.moreBtn addTarget:self action:@selector(changgeCellHeight:event:) forControlEvents:UIControlEventTouchUpInside];

    Comments *model = self.commentArray[indexPath.section][indexPath.row];
    cell.authorLabei.text = model.author;
    if (model.reply_to) {

        cell.replyTextView.hidden  = NO;

        cell.replyTextViewHeight.constant = 42;
        NSString *replyauthor = model.reply_to[@"author"];
        NSString *replycontent = model.reply_to[@"content"];
        cell.replyTextView.text = [NSString stringWithFormat:@"//%@: %@",replyauthor,replycontent];
        CGFloat textHeight = [self replyHeightWithCell:cell];
        if (textHeight > 20) {
            cell.moreBtn.hidden = NO;
        }
    }else{
        cell.replyTextView.hidden = cell.moreBtn.hidden = YES;
        cell.replyTextViewHeight.constant = 0;
    }
    cell.contentTextView.text = model.content;
    cell.timeLabei.text = [DataUtils formateDateWithTime:model.time];
    cell.likesLabei.text = [NSString stringWithFormat:@"%ld",(long)model.likes];
    [cell.avaterImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    [cell.moreBtn setTitle:@"展开" forState:UIControlStateNormal];


    return cell;

}
/**
 *  更改cell高度
 *
 *  @param sender btn
 *  @param event  btn点击事件
 */
-(void)changgeCellHeight:(id)sender event:(id)event{
    /**
     *  可优化，不需要计算，展示更多就移除reply的高度约束，收起就添加一个42的高度约束
     */
    /**
     *  拿到点击EVENT 根据indexPathForRowAtPoint方法计算indexpath
     */
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:_commentsTable];
    NSIndexPath *indexpath =[_commentsTable indexPathForRowAtPoint:currentTouchPosition];
    UIButton *btn = sender;

    if (indexpath != nil) {
        commentsCell *cell = [self.commentsTable cellForRowAtIndexPath:indexpath];
        CGFloat textHeight = [self replyHeightWithCell:cell];

        if (cell.replyTextView.height > textHeight+20) {
            cell.replyTextViewHeight.constant = 42;
            [btn setTitle:@"展开" forState:UIControlStateNormal];
//            NSLog(@"还原");
        }else{
            cell.replyTextViewHeight.constant += textHeight -20;
//            NSLog(@"lasheng");
             [btn setTitle:@"收起" forState:UIControlStateNormal];
        }

        [self.commentsTable beginUpdates];
        [self.commentsTable endUpdates];

    }
}
/**
 *  计算文字高度
 *
 *  @return 回复textview高度
 */
-(CGFloat)replyHeightWithCell:(commentsCell *)cell{
    NSMutableDictionary *attrs = [NSMutableDictionary new];
    attrs[NSFontAttributeName] = cell.replyTextView.font;
    CGSize maxsize = CGSizeMake(cell.contentTextView.width, MAXFLOAT);
    CGSize temp = [cell.replyTextView.text boundingRectWithSize:maxsize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    return temp.height;
}
//自定义SectionHeader
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    UILabel *rows = [[UILabel alloc] initWithFrame:header.frame];
    header.backgroundColor = [UIColor whiteColor];
    NSArray *temp = self.commentArray[section];
    if (section == 0) {
        rows.text = [NSString stringWithFormat:@"     %ld条长论",temp.count];
    }else{
        rows.text = [NSString stringWithFormat:@"     %ld条短论",temp.count];
    }

    rows.textAlignment = NSTextAlignmentLeft;

    [header addSubview:rows];
    return header;

}


@end

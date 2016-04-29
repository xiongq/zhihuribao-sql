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
@property (nonatomic, strong)NSMutableArray<NSNumber *> *isExpland;//这里用到泛型，防止存入非数字类型

@end

@implementation commentsViewController{
    NSIndexPath *selecttemp;
    CGFloat rowsHeight;


}
-(NSMutableArray<NSNumber *> *)isExpland{
    if (!_isExpland) {
        _isExpland = [NSMutableArray new];
        [_isExpland addObject:@1];
        [_isExpland addObject:@0];

    }
    return _isExpland;
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
    self.commentsTable.tableFooterView = [[UIView alloc] init];

    //用0代表收起，非0代表展开，默认都是收起的


    /**
     *  自动调整cell高度
     */
    self.commentsTable.estimatedRowHeight = 300;
    self.commentsTable.rowHeight = UITableViewAutomaticDimension;

}


-(void)commentsWithids:(NSInteger)ids{
    [NewsRequest longCommentsWithIds:ids Succees:^(id dic) {
        if (dic[@"comments"] != nil) {
            NSArray *longtemp = [Comments mj_objectArrayWithKeyValuesArray:dic[@"comments"]];
            [self.commentArray  insertObject:longtemp atIndex:0];

        }

        [self.commentsTable reloadData];

    } Error:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    [NewsRequest shortCommentsWithIds:ids Succees:^(id dic) {
        if (dic[@"comments"] != nil) {
            NSArray *shorttemp = [Comments mj_objectArrayWithKeyValuesArray:dic[@"comments"]];
            [self.commentArray addObject:shorttemp];
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
//    if (self.commentArray.count !=0) {
        NSArray *array = self.commentArray[section];
        if ([self.isExpland[section] boolValue]) {
            return array.count;

    }else{

        return 0;
    }

//    }

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    commentsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentscell" forIndexPath:indexPath];
    [cell.moreBtn addTarget:self action:@selector(changgeCellHeight:event:) forControlEvents:UIControlEventTouchUpInside];
//    [tableView setSeparatorInset: UIEdgeInsetsMake(0, 0, 0, 0)];
    Comments *model = self.commentArray[indexPath.section][indexPath.row];
    cell.authorLabei.text = model.author;
    if (model.reply_to) {

        cell.replyTextView.hidden  = NO;

        cell.replyTextViewHeight.constant = 33;
        NSString *replyauthor = model.reply_to[@"author"];
        NSString *replycontent = model.reply_to[@"content"];
        if (replyauthor != nil) {
            cell.replyTextView.text = [NSString stringWithFormat:@"//%@: %@",replyauthor,replycontent];
            CGFloat textHeight = [self replyHeightWithCell:cell];


            if (textHeight < 33) {
                cell.moreBtn.hidden = YES;
            }else{
                cell.moreBtn.hidden = NO;
            }
            cell.replyTextView.backgroundColor = [UIColor whiteColor];
        }else{

            cell.replyTextView.text = @"原评论，已被删除";
            cell.moreBtn.hidden = YES;
            cell.replyTextView.backgroundColor = [UIColor lightGrayColor];
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

//    cell.replyTextView.backgroundColor = [UIColor redColor];
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
        NSLog(@"begin--replyHeight%f  fktextHeight%f",cell.replyTextViewHeight.constant,textHeight);
        [self.commentsTable beginUpdates];
        if (cell.replyTextView.height > textHeight +20) {
            cell.replyTextViewHeight.constant = 33;
            [btn setTitle:@"展开" forState:UIControlStateNormal];
//            NSLog(@"还原");
        }else{
            cell.replyTextViewHeight.constant += textHeight -10;
//            NSLog(@"lasheng");
             [btn setTitle:@"收起" forState:UIControlStateNormal];
        }
        [self.commentsTable endUpdates];
//        NSLog(@"end--replyHeight%f",cell.replyTextViewHeight.constant);

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
    UIButton *header = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.commentsTable.sectionHeaderHeight)];
    UILabel *rows = [[UILabel alloc] initWithFrame:header.frame];
    header.backgroundColor = [UIColor whiteColor];

    UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Profile_Split"]];
    line.frame = CGRectMake( 0, CGRectGetMaxY(self.commentsTable.tableHeaderView.frame) - 0.5 +44,self.view.width, 0.5);

    NSArray *temp = self.commentArray[section];
    if (section == 0) {
        
        if (temp.count == 0) {
//            NSLog(@"head%f",self.commentsTable.sectionHeaderHeight);
            [header setImage:[UIImage imageNamed:@"Dark_Comment_Empty"]  forState:UIControlStateNormal];

        }else{
            rows.text = [NSString stringWithFormat:@"     %ld条长论",temp.count];
            [header addSubview:line];
        }

    }else{
        rows.text = [NSString stringWithFormat:@"     %ld条短论",temp.count];
        [header addSubview:line];
    }

    rows.textAlignment = NSTextAlignmentLeft;
    header.tag = 666 + section;


//    for (int i = 0; i < header.subviews.count; i++) {
//        NSLog(@"%@",header.subviews[i]);
//    }

//    [header setBackgroundImage:[UIImage imageNamed:@"Profile_Split"] forState:UIControlStateNormal];

    [header addSubview:rows];
    [header addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    return header;

}
-(void)buttonAction:(UIButton *)btn{
    NSInteger section = btn.tag - 666;
    /**
     *  如果长评空，点击短评就将短评移动
     */
//    if (section == 1) {
//        NSArray *test = self.commentArray[0];
//        if (test.count == 0) {
//            self.commentsTable.contentOffset = CGPointMake(0, self.view.height - 64 - 40 -44);
//        }
//    }
    if (section == 1) {
        self.commentsTable.contentOffset = CGPointMake(0, CGRectGetMinY(btn.frame));
//        [self.commentsTable setContentOffset:CGPointMake(0, CGRectGetMinY(btn.frame)) animated:YES];
    }
    self.isExpland[section] = [self.isExpland[section] isEqual:@0]?@1:@0;
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:section];
    [self.commentsTable reloadSections:set withRowAnimation:UITableViewRowAnimationFade];



}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSArray *test = self.commentArray[section];
    if (test.count == 0) {
        return self.view.height - 64 - 40 -44;
    }else{
        return 44;
    }

}
-(void)dealloc{
    NSLog(@"commDEALLOC");
//    self.commentArray = nil;
}

@end

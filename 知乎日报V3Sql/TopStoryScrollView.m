//
//  TopStoryScrollView.m
//  知乎日报V3Sql
//
//  Created by xiong on 16/3/18.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "TopStoryScrollView.h"
#import "oneTopStoryImageAndTittle.h"
#import "UIView+Extension.h"
#import "NewsRequest.h"
#import "ZHHomeListModel.h"
#import <MJExtension.h>
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define giveImage 3
@interface TopStoryScrollView ()<UIScrollViewDelegate,oneTopImageDelegate>

@property (strong, nonatomic) IBOutlet  UIPageControl *TopStoryPageControl;
@property (strong, nonatomic) IBOutlet UIScrollView *TopStoryScroll;
@property (strong, nonatomic) oneTopStoryImageAndTittle *leftView;
@property (strong, nonatomic) oneTopStoryImageAndTittle *centerView;
@property (strong, nonatomic) oneTopStoryImageAndTittle *rightView;
@property (strong, nonatomic) UITapGestureRecognizer *tap;

@end

@implementation TopStoryScrollView{
    ZHHomeListModel *models;
    int currentImageIndex;
    int imagecount;
    BOOL isTimer;

}
-(UITapGestureRecognizer *)tap{
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc] init];
    }
    return _tap;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.test = [[[NSBundle mainBundle] loadNibNamed:@"topStoryScrollView" owner:self options:nil] firstObject];
        self.test.frame = self.bounds;
        [self addSubview:self.test];
        [self testTitle];
        self.centerView.delegate = self.rightView.delegate =self;
        self.TopStoryPageControl.pageIndicatorTintColor = [UIColor grayColor];
        self.TopStoryPageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        [NewsRequest AFNetworkRequestWith:nil Succees:^(id dic) {
            ZHHomeListModel *model = [ZHHomeListModel mj_objectWithKeyValues:dic];
            [self setImageAndTitle:model];
        } Error:^(NSError *error) {

        }];


    }
    return self;
}
-(void)testTitle{

    self.TopStoryScroll.contentSize = CGSizeMake(3*kScreenWidth, self.bounds.size.height);
    self.TopStoryScroll.contentInset = UIEdgeInsetsZero;
    self.TopStoryScroll.contentOffset = CGPointMake(kScreenWidth, 0);
    self.TopStoryScroll.pagingEnabled = YES;
    self.TopStoryPageControl.numberOfPages = 5;
    self.TopStoryPageControl.currentPage = 0;
    self.TopStoryScroll.showsHorizontalScrollIndicator = NO;

    _leftView   = [oneTopStoryImageAndTittle new];
    _centerView = [oneTopStoryImageAndTittle new];
    _rightView  = [oneTopStoryImageAndTittle new];
    _leftView.TopStroyImageSourceTitle.hidden =  _leftView.TopStroyImageSourceTitle.hidden = _leftView.TopStroyImageSourceTitle.hidden = YES;

    [self.TopStoryScroll addSubview:_leftView];
    [self.TopStoryScroll addSubview:_centerView];
    [self.TopStoryScroll addSubview:_rightView];
    
    [_leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.TopStoryScroll.mas_height);
        make.width.mas_equalTo(kScreenWidth);
        make.top.equalTo(self.TopStoryScroll.mas_top);
        make.left.mas_equalTo(0);
    }];
    [_centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.TopStoryScroll.mas_height);
        make.width.mas_equalTo(kScreenWidth);
        make.top.equalTo(self.TopStoryScroll.mas_top);
        make.left.mas_equalTo(kScreenWidth);
    }];
    [_rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.TopStoryScroll.mas_height);
        make.width.mas_equalTo(kScreenWidth);
        make.top.equalTo(self.TopStoryScroll.mas_top);
        make.left.mas_equalTo(2*kScreenWidth);
    }];

}
-(void)setImageAndTitle:(ZHHomeListModel *)model{
    models = model;
    imagecount = (int)model.top_stories.count;
    Top_Stories *first = model.top_stories[0];
    Top_Stories *secend = model.top_stories[1];
    Top_Stories *thred = model.top_stories[2];

    _leftView.TopStroyTitle.text = first.title;
    _centerView.TopStroyTitle.text = secend.title;
    _centerView.ids = secend.id;
    _rightView.TopStroyTitle.text = thred.title;


    [_leftView.TopStoryImageView sd_setImageWithURL:[NSURL URLWithString:first.image]];
    [_centerView.TopStoryImageView sd_setImageWithURL:[NSURL URLWithString:secend.image]];
    [_rightView.TopStoryImageView sd_setImageWithURL:[NSURL URLWithString:thred.image]];
    currentImageIndex = 1;
    self.TopStoryPageControl.currentPage =currentImageIndex;

//    [self.tap addTarget:self action:@selector(touchtap)];
//    [self.TopStoryScroll addGestureRecognizer:self.tap];
     _timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(upcontentoffset) userInfo:nil repeats:YES];
    isTimer  = YES;



}

-(void)upcontentoffset{



    [self reloadImagewith];
    [self.TopStoryScroll setContentOffset:CGPointMake(2*kScreenWidth, 0) animated:YES];
     self.TopStoryPageControl.currentPage = currentImageIndex;


}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self reloadImagewith];
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{

    self.TopStoryPageControl.currentPage = currentImageIndex;

}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_timer setFireDate:[NSDate distantFuture]];
    isTimer = NO;
}

-(void)temp{


}
-(void)reloadImagewith{
    CGFloat offsetx = self.TopStoryScroll.contentOffset.x;
    int leftIndex,rightIndex;
    if (offsetx > kScreenWidth) {
        //向右滑
        currentImageIndex = (currentImageIndex + 1)% imagecount;
    }else if (offsetx < kScreenWidth){
        //向左滑
        currentImageIndex = (currentImageIndex + imagecount - 1)% imagecount;
    }


    [_centerView.TopStoryImageView sd_setImageWithURL:[NSURL URLWithString:models.top_stories[currentImageIndex].image]];
    _centerView.TopStroyTitle.text = models.top_stories[currentImageIndex].title;
    _centerView.ids = models.top_stories[currentImageIndex].id;
    leftIndex = (currentImageIndex + imagecount -1)%imagecount;
    rightIndex = (currentImageIndex + 1)%imagecount;

    [_leftView.TopStoryImageView  sd_setImageWithURL:[NSURL URLWithString:models.top_stories[leftIndex].image]];
    _leftView.TopStroyTitle.text = models.top_stories[leftIndex].title;
    [_rightView.TopStoryImageView  sd_setImageWithURL:[NSURL URLWithString:models.top_stories[rightIndex].image]];
    _rightView.TopStroyTitle.text = models.top_stories[rightIndex].title;
    _rightView.ids = models.top_stories[rightIndex].id;

    self.TopStoryScroll.contentOffset = CGPointMake(kScreenWidth, 0);

}


-(void)touchImage:(NSString *)title{
    for (Top_Stories *temp in models.top_stories) {
        if ([title isEqualToString:temp.title]) {
            if ([self.delegate respondsToSelector:@selector(touchTapScroll:)]) {
                [self.delegate touchTapScroll:temp.id];
            }
            break;
        }
    }
}
@end

//
//  KJ_BookTableViewController.m
//  XinMinClub
//
//  Created by 杨科军 on 16/5/23.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "KJ_BookTableViewController.h"

@interface KJ_BookTableViewController()<UIScrollViewDelegate>{
    NSInteger N; // 卷轴个数
}

@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UIScrollView *bottomScrollView;

@end

@implementation KJ_BookTableViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self falseData];
    
    [self.view addSubview:self.topImageView];
    [self.view addSubview:self.bottomScrollView];
    
    // 创建button
    [self establishButton];
}

#pragma mark 假数据
- (void)falseData{
    UIImage *im=[UIImage imageNamed:@"10.jpg"];
    self.topImageView.image=im;
    N=16;
}

#pragma mark 视图控件
- (UIImageView *)topImageView{
    if (!_topImageView) {
        _topImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, SCREEN_HEIGHT/4-20)];
        _topImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonpress1:)];
        [_topImageView addGestureRecognizer:singleTap1];
    }
    return _topImageView;
}

- (UIScrollView*)bottomScrollView{
    if (!_bottomScrollView) {
        CGFloat x=0;
        CGFloat y = self.topImageView.bounds.size.height+self.topImageView.bounds.origin.y+10;
        CGFloat w = SCREEN_WIDTH;
        CGFloat h = SCREEN_HEIGHT - y - 44 - 64;
        _bottomScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(x, y, w, h)];
        _bottomScrollView.delegate=self;
        _bottomScrollView.pagingEnabled = YES; // 当不足一张的时候显示最大的那个内容
        _bottomScrollView.showsHorizontalScrollIndicator = NO; // 关闭显示水平大概位置的条状物
        _bottomScrollView.showsVerticalScrollIndicator = NO; // 关闭显示垂直大概位置的条状物
    }
    return _bottomScrollView;
}

- (void)establishButton{
    CGFloat h = (self.bottomScrollView.bounds.size.height-80)/2;
    CGFloat w = (CGFloat)h*0.5;
    CGFloat s = (SCREEN_WIDTH-3*w)/4;
    
    NSInteger d=N/6+1;
    NSInteger p=0;
    if (N%6!=0) {
        d=d+1;
        p=N%6;
    }
    
    NSInteger t=0;
    NSInteger e=N;
    NSInteger c=0;
    
    for (NSInteger k=0; k<d; k++) {
        if (e>=6) {
            t=6;
        }else
            t=e;
        e=e-6;
        
        for (NSInteger i=0; i<t; i++) {
            UIButton *b=[UIButton buttonWithType:UIButtonTypeCustom];
            NSInteger j=0;
            NSInteger l=i;
            if (l/3==1) {
                l=l%3;
                j=1;
            }
            CGFloat x = s*(l+1)+w*l+k*SCREEN_WIDTH;
            CGFloat y = 20+j*(h+40);
            b.frame=CGRectMake(x, y, w, h);
            b.tag=c;
            b.layer.masksToBounds=YES;
            b.layer.borderWidth=3;
            b.layer.borderColor=[[UIColor redColor] CGColor];
            [b addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *la=[[UILabel alloc]initWithFrame:CGRectMake((w-w/4)/2, 10, w/4, h-20)];
            la.textAlignment=NSTextAlignmentCenter;
            la.backgroundColor = [UIColor greenColor];
            NSString *strText = [NSString stringWithFormat:@"第 %d 个老师的课程",c];
            la.text = strText;
            la.font=[UIFont systemFontOfSize:15];
            la.numberOfLines = 0;
            
            [b addSubview:la];
            [self.bottomScrollView addSubview:b];
            c++;
        }
    }
    
    self.bottomScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*(d-1), self.bottomScrollView.bounds.size.height);
}

#pragma mark 点击事件
- (IBAction)buttonpress1:(id)sender{
    NSLog(@"点击了最上面的推荐老师图片！！！");
}

- (IBAction)buttonTouch:(UIButton*)sender{
    NSLog(@"点击了第%d本课程！！", sender.tag);
}

@end


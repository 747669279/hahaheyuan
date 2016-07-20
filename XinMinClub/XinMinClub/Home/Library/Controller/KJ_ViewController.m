//
//  KJ_ViewController.m
//  XinMinClub
//
//  Created by 杨科军 on 16/7/18.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "KJ_ViewController.h"
<<<<<<< HEAD
#import "KJ_DDViewController.h"
=======
#import "CLassTableViewController.h"
>>>>>>> origin/master

@interface KJ_ViewController (){
    NSInteger N; // 课程节数
    UILabel *la;
    UIButton *b;
    UIView *vv;
    NSInteger xzz; // 显示字体个数
    NSString *sssss; // 假数据简介介绍文字
}

@property(nonatomic, readonly) UIViewController *viewController;

@property (nonatomic, strong) UIImageView *backImage;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *alabel;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *bbb;
@property (nonatomic, strong) UIScrollView *xscrollView;

@end

@implementation KJ_ViewController

- (id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        N=15;
        xzz=0;
        [self xxx];
        // 毛玻璃
        [self addSubview:self.backImage];
        
        [self.backView addSubview:self.imageView];
        [self.backView addSubview:self.alabel];
        [self.backView addSubview:self.label];
        [self.label addSubview:self.bbb];
        [self.backView addSubview:self.xscrollView];
        
        [self addSubview:self.backView];
    }
    return self;
}

// 计算出一个字所占大小
- (void)xxx{
    sssss=@"这只是拿来测试的而已，随便吧计算机发电机房到附近的设计费了圣诞节福利的送积分楼上的解放路的时刻就发了多少级分类电视剧分类考试的减肥了电视剧发了多少解放路口男盗女娼美女从明年形成项目内侧面像那次你信息传媒你想吃啥就到处是的基础上的警察局倒计时了圣诞节佛为飞机为房间了肯德基的三轮车的理财女司机的身份的女的穿。然后就这样结束吧。水电费建设大街监控计算机的附件多少级分类九分裤就打飞机发动机飞机看见飞机飞机人如减肥打客服几时放假来得及发空间付款金额可减肥可减肥觉得了伺服电机尽快圣诞节福利及就减肥来得及飞机 及福建省的。水电费建设大街监控计算机的附件多少级分类九分裤就打飞机发动机飞机看见飞";
    NSLog(@"%f",SCREEN_HEIGHT);
    // 6P
    if (SCREEN_HEIGHT==736) {
        xzz=70;
    }
    // 6
    if (SCREEN_HEIGHT==667) {
        xzz=53;
    }
    // 5S
    if (SCREEN_HEIGHT==568) {
        xzz=34;
    }
}

#pragma mark 界面布局
- (UIImageView*)backImage{
    if (!_backImage) {
        _backImage=[[UIImageView alloc]initWithFrame:self.bounds];
        _backImage.image=[UIImage imageNamed:@"maoboli.jpg"];
        _backImage.alpha=0.4;
    }
    return _backImage;
}
- (UIView *)backView{
    if (!_backView) {
        _backView=[[UIView alloc]initWithFrame:CGRectMake(20, 80, SCREEN_WIDTH-40, self.bounds.size.height-160)];
        _backView.backgroundColor=[UIColor colorWithRed:0.9893 green:0.5765 blue:0.1574 alpha:0.9];
        _backView.layer.masksToBounds=YES;
        _backView.layer.cornerRadius=2;
        _backView.layer.borderWidth=2;
        _backView.layer.borderColor=[UIColor blackColor].CGColor;

    }
    return _backView;
}
- (UIImageView*)imageView{
    if (!_imageView) {
        CGFloat w=self.backView.bounds.size.width/3;
        _imageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 20, w, w)];
        _imageView.image=[UIImage imageNamed:@"10.jpg"];
        _imageView.layer.masksToBounds=YES;
        _imageView.layer.cornerRadius=w/2;
        _imageView.layer.borderWidth=1;
        _imageView.layer.borderColor=[UIColor blackColor].CGColor;
    }
    return _imageView;
}
- (UILabel *)alabel{
    if (!_alabel) {
        CGFloat x = self.imageView.bounds.origin.x+self.imageView.bounds.size.width+20;
        CGFloat y = self.imageView.bounds.origin.y+10;
        CGFloat w = self.backView.bounds.size.width-x-10;
        CGFloat h = 30;
        _alabel=[[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
        _alabel.textAlignment=NSTextAlignmentLeft;
        _alabel.text=@"作者名字";
        _alabel.font = [UIFont systemFontOfSize:18];   //设置内容字体和字体大小
    }
    return _alabel;
}
- (UIButton*)bbb{
    if (!_bbb) {
        _bbb=[UIButton buttonWithType:UIButtonTypeCustom];
        _bbb.frame=CGRectMake(_label.bounds.size.width-52, _label.bounds.size.height-22, 50, 30);
        [_bbb setTitle:@"展开" forState:UIControlStateNormal];
        _bbb.backgroundColor=[UIColor colorWithRed:0.9893 green:0.5765 blue:0.1574 alpha:0.9];
        [_bbb addTarget:self action:@selector(bbbTouch) forControlEvents:UIControlEventTouchUpInside];
        _bbb.layer.masksToBounds=YES;
        _bbb.layer.borderWidth=2;
        _bbb.layer.cornerRadius=5;
        _bbb.layer.borderColor=[UIColor blackColor].CGColor;
    }
    return _bbb;
}
- (UILabel *)label{
    if (!_label) {
        CGFloat x = self.imageView.bounds.origin.x+self.imageView.bounds.size.width+20;
        CGFloat y = self.imageView.bounds.origin.y+40;
        CGFloat w = self.backView.bounds.size.width-x-10;
        CGFloat h = self.imageView.bounds.size.height;
        _label=[[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
        _label.textAlignment=NSTextAlignmentLeft;
        _label.text=[sssss substringToIndex:xzz-1];
        _label.numberOfLines=0;
        _label.userInteractionEnabled = YES;
    }
    return _label;
}

- (UIScrollView*)xscrollView{
    if (!_xscrollView) {
        CGFloat s=self.backView.bounds.size.width/4;
        CGFloat y=self.label.bounds.origin.y+self.label.bounds.size.height+50;
        CGFloat h=self.backView.bounds.size.height-y;
        _xscrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, y, self.backView.bounds.size.width, h)];
        for (NSInteger i=0; i<N; i++) {
            UIButton *bb=[UIButton buttonWithType:UIButtonTypeCustom];
            bb.frame=CGRectMake(2+s*i, 0, s-2, h);
            bb.tag=i;
            [bb addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
            bb.backgroundColor=[UIColor redColor];
            bb.layer.masksToBounds=YES;
            bb.layer.borderWidth=1;
            bb.layer.borderColor=[UIColor blackColor].CGColor;

            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((s-s/3)/2,10,s/3,h-20)];
            NSString *s=[NSString stringWithFormat:@"第\n%d\n节\n课",i+1];
            if (i+1<10) {
                s=[NSString stringWithFormat:@"第\n %d\n节\n课",i+1];
            }
            label.text=s;
            label.font = [UIFont systemFontOfSize:23];   //设置内容字体和字体大小
            label.numberOfLines = [label.text length];
//            label.backgroundColor=[UIColor greenColor];
            [bb addSubview:label];
            [_xscrollView addSubview:bb];
        }
        _xscrollView.contentSize=CGSizeMake((s)*N+2, h);
    }
    return _xscrollView;
}

#pragma mark 点击事件
- (void)bbbTouch{
    NSLog(@"hhhhh");
    NSString *tttt=[sssss substringFromIndex:xzz-1];
    self.bbb.alpha=0;
    CGFloat y=self.label.bounds.origin.y+self.label.bounds.size.height+35;
    CGFloat h=self.backView.bounds.size.height-y;
    la=[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.backView.bounds.size.width-20, h)];
    la.backgroundColor=[UIColor clearColor];
    la.text=tttt;
    la.numberOfLines=0;
    la.textAlignment = NSTextAlignmentLeft;  //文本对齐方式
    CGSize size = [tttt sizeWithFont:la.font constrainedToSize:CGSizeMake(la.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    if (size.height>h-15) {
        size.height=h-30;
    }
    //根据计算结果重新设置UILabel的尺寸
    [la setFrame:CGRectMake(10, y, self.backView.bounds.size.width-20, size.height)];
    
    b=[UIButton buttonWithType:UIButtonTypeCustom];
    b.frame=CGRectMake((self.backView.bounds.size.width-150)/2, size.height+y-5, 150, 30);
    [b setTitle:@"收起" forState:UIControlStateNormal];
    b.backgroundColor=[UIColor colorWithRed:0.9893 green:0.5765 blue:0.1574 alpha:0.9];
    [b addTarget:self action:@selector(bbbTouch1) forControlEvents:UIControlEventTouchUpInside];
    b.layer.masksToBounds=YES;
    b.layer.borderWidth=2;
    b.layer.cornerRadius=5;
    b.layer.borderColor=[UIColor blackColor].CGColor;

    vv=[[UIView alloc]initWithFrame:CGRectMake(0, y, self.backView.bounds.size.width, h)];
    vv.backgroundColor=[UIColor colorWithRed:0.9771 green:0.5877 blue:0.1981 alpha:1.0];
    
    CATransition *animation = [CATransition animation];
    animation.duration = 2.0;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionReveal;
    animation.subtype = kCATransitionFromBottom;
    [la.layer addAnimation:animation forKey:nil];
    
    [self.backView addSubview:vv];
    [self.backView addSubview:b];
    [self.backView addSubview:la];
}
- (void)bbbTouch1{
    self.bbb.alpha=1;
    [la removeFromSuperview];
    [vv removeFromSuperview];
    [b removeFromSuperview];
}
- (IBAction)buttonTouch:(UIButton*)sender{
    NSLog(@"点击的第%d节课！！",sender.tag+1);
<<<<<<< HEAD
    KJ_DDViewController *kj_dd=[[KJ_DDViewController alloc] init];
    UINavigationController *nnn=[[UINavigationController alloc]initWithRootViewController:kj_dd];
    kj_dd.view.backgroundColor=[UIColor grayColor];
    [self.viewController presentViewController:nnn animated:NO completion:nil];
}

//  获取当前view所处的viewController重写读方法
- (UIViewController *)viewController{
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
=======
    CLassTableViewController *c = [[CLassTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            [((UIViewController*)nextResponder).navigationController pushViewController:c animated:YES];
            return;
        }
    }
>>>>>>> origin/master
}


@end

//
//  NineGridView.m
//  XinMinClub
//
//  Created by 杨科军 on 16/6/24.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "NineGridView.h"
#import "BookView.h"
#import "PeopleView.h"
#import "MyNews.h"
#import "NewsMode.h"
#define X ((([UIScreen mainScreen].bounds.size.width)-30)/3)
#define Y (((self.bounds.size.height)-120)/3-8)
#define P (([UIScreen mainScreen].bounds.size.width)/20)


@interface NineGridView()

@property(nonatomic, readonly) UIViewController *viewController;

@property (nonatomic, copy) UIButton *bbb;
@property (nonatomic, strong) UILabel *aaa;

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;
@property (nonatomic, strong) UIButton *button3;
@property (nonatomic, strong) UIButton *button4;
@property (nonatomic, strong) UIButton *button5;
@property (nonatomic, strong) UIButton *button6;
@property (nonatomic, strong) UIButton *button7;
@property (nonatomic, strong) UIButton *button8;
@property (nonatomic, strong) UIButton *button9;
@property (nonatomic, strong) UIView *v1;
@property (nonatomic, strong) UIView *v2;
@property (nonatomic, strong) UIView *v3;
@property (nonatomic, strong) UIView *v4;
@property (nonatomic, strong) UIView *v5;

@end

@implementation NineGridView

- (id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self addSubview:self.backImageView];
        
        [self addSubview:self.v1];
        [self addSubview:self.v2];
        [self addSubview:self.v3];
        [self addSubview:self.v4];
        [self addSubview:self.v5];
        
        [self addSubview:self.bbb];
        [self addSubview:self.aaa];
        
        [self addSubview:self.button1];
        [self addSubview:self.button2];
        [self addSubview:self.button3];
        [self addSubview:self.button4];
        [self addSubview:self.button5];
        [self addSubview:self.button6];
        [self addSubview:self.button7];
        [self addSubview:self.button8];
        [self addSubview:self.button9];
    }
    return self;
}

- (void)setIsPeople:(NSInteger)isPeople{
    _isPeople=isPeople;
    if (_isPeople==0) {
        _aaa.text=@"大道之行也，天下为公。";
    }
    if (_isPeople==1) {
        _aaa.text=@"芸芸众生，皆是平等。";
    }
    if (_isPeople==2) {
        _aaa.text=@"修身养性，道法自然。";
    }
    [self ruturnButton:isPeople];
}

- (UIButton*)bbb{
    if (!_bbb) {
        _bbb=[UIButton buttonWithType:UIButtonTypeCustom];
        _bbb.frame=CGRectMake(10, 5, 40, P);
        [_bbb setTitle:@"返回" forState:UIControlStateNormal];
        [_bbb setTitleColor:[UIColor redColor]forState:UIControlStateNormal];
        _bbb.titleLabel.font=[UIFont fontWithName:@"AppleGothic" size:13];
        _bbb.layer.masksToBounds=YES;
        _bbb.layer.cornerRadius=2;
        _bbb.layer.borderColor=[[UIColor blackColor] CGColor];
        _bbb.layer.borderWidth=1;
        [_bbb addTarget:self action:@selector(kkk) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bbb;
}
- (void)kkk{
    NSLog(@"返回小人");
    [self.bbb removeFromSuperview];
    [self.aaa removeFromSuperview];
    [self.v1 removeFromSuperview];
    [self.v2 removeFromSuperview];
    [self.v3 removeFromSuperview];
    [self.v4 removeFromSuperview];
    [self.v5 removeFromSuperview];
    [self.button1 removeFromSuperview];
    [self.button2 removeFromSuperview];
    [self.button3 removeFromSuperview];
    [self.button4 removeFromSuperview];
    [self.button5 removeFromSuperview];
    [self.button6 removeFromSuperview];
    [self.button7 removeFromSuperview];
    [self.button8 removeFromSuperview];
    [self.button9 removeFromSuperview];
    [self.backImageView removeFromSuperview];

    PeopleView *pv=[[PeopleView alloc]initWithFrame:self.bounds];
    [self addSubview:pv];
}
- (UILabel*)aaa{
    if (!_aaa) {
        CGFloat x=self.bbb.bounds.origin.x+self.bbb.bounds.size.width+20;
        CGFloat y=self.bbb.bounds.origin.y+5;
        CGFloat w=SCREEN_WIDTH-x;
        CGFloat h=self.bbb.bounds.size.height;
        _aaa=[[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
        _aaa.font=[UIFont fontWithName:@"AppleGothic" size:14];
    }
    return _aaa;
}
- (UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView=[[UIImageView alloc]initWithFrame:self.bounds];
        _backImageView.image=[UIImage imageNamed:@"beijing"];
    }
    return _backImageView;
}

- (UIButton*)button1{
    if (!_button1) {
        _button1=[UIButton buttonWithType:UIButtonTypeCustom];
        _button1.frame=CGRectMake(15, 10+P, X+8, Y);
        //        _button1.layer.masksToBounds=YES;
        //        _button1.layer.borderWidth=3;
        //        _button1.layer.borderColor=[[UIColor colorWithRed:0.2371 green:0.2371 blue:0.2371 alpha:1.0] CGColor];
        _button1.tag=1;
        
        [_button1 addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button1;
}
- (UIView *)v1{
    if (!_v1) {
        _v1=[[UIView alloc]initWithFrame:CGRectMake(12, 13+P, X+11, Y)];
        _v1.layer.masksToBounds=YES;
        _v1.layer.borderWidth=3;
        _v1.layer.borderColor=[[UIColor colorWithRed:0.2371 green:0.2371 blue:0.2371 alpha:1.0] CGColor];
    }
    return _v1;
}

- (UIButton*)button2{
    if (!_button2) {
        _button2=[UIButton buttonWithType:UIButtonTypeCustom];
        _button2.frame=CGRectMake(X+25, 9+P, X, Y);
        _button2.layer.masksToBounds=YES;
        _button2.layer.borderWidth=2;
        _button2.layer.borderColor=[[UIColor colorWithRed:0.2371 green:0.2371 blue:0.2371 alpha:1.0] CGColor];
        _button2.tag=2;
        [_button2 addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button2;
}

- (UIButton*)button3{
    if (!_button3) {
        _button3=[UIButton buttonWithType:UIButtonTypeCustom];
        _button3.frame=CGRectMake(2*X+27, 8+P, X-7, Y);
        //        _button3.layer.masksToBounds=YES;
        //        _button3.layer.borderWidth=3;
        //        _button3.layer.borderColor=[[UIColor colorWithRed:0.2371 green:0.2371 blue:0.2371 alpha:1.0] CGColor];
        _button3.tag=3;
        [_button3 addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button3;
}
- (UIView *)v2{
    if (!_v2) {
        _v2=[[UIView alloc]initWithFrame:CGRectMake(2*X+25, 9+P, X-7, Y+2)];
        _v2.layer.masksToBounds=YES;
        _v2.layer.borderWidth=3;
        _v2.layer.borderColor=[[UIColor colorWithRed:0.2371 green:0.2371 blue:0.2371 alpha:1.0] CGColor];
    }
    return _v2;
}

- (UIButton*)button4{
    if (!_button4) {
        _button4=[UIButton buttonWithType:UIButtonTypeCustom];
        _button4.frame=CGRectMake(15, Y+12+P, X+8, Y-22);
        //        _button4.layer.masksToBounds=YES;
        //        _button4.layer.borderWidth=3;
        //        _button4.layer.borderColor=[[UIColor colorWithRed:0.2371 green:0.2371 blue:0.2371 alpha:1.0] CGColor];
        _button4.tag=4;
        [_button4 addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button4;
}
- (UIView *)v3{
    if (!_v3) {
        _v3=[[UIView alloc]initWithFrame:CGRectMake(12, Y+10+P, 3, Y-20)];
        _v3.layer.masksToBounds=YES;
        _v3.layer.borderWidth=1.4;
        _v3.layer.borderColor=[[UIColor colorWithRed:0.2371 green:0.2371 blue:0.2371 alpha:1.0] CGColor];
    }
    return _v3;
}

- (UIButton*)button5{
    if (!_button5) {
        _button5=[UIButton buttonWithType:UIButtonTypeCustom];
        _button5.frame=CGRectMake(X+28, Y+10+P, X-4.7, Y-17);
        //        _button5.layer.masksToBounds=YES;
        //        _button5.layer.borderWidth=3;
        //        _button5.layer.borderColor=[[UIColor colorWithRed:0.2371 green:0.2371 blue:0.2371 alpha:1.0] CGColor];
        _button5.tag=5;
        [_button5 addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button5;
}
- (UIView *)v4{
    if (!_v4) {
        _v4=[[UIView alloc]initWithFrame:CGRectMake(X+25, Y+8+P, X-1, Y-13)];
        _v4.layer.masksToBounds=YES;
        _v4.layer.borderWidth=3;
        _v4.layer.borderColor=[[UIColor colorWithRed:0.2371 green:0.2371 blue:0.2371 alpha:1.0] CGColor];
    }
    return _v4;
}


- (UIButton*)button6{
    if (!_button6) {
        _button6=[UIButton buttonWithType:UIButtonTypeCustom];
        _button6.frame=CGRectMake(2*X+26, Y+11+P, X-11, Y-21);
        //        _button6.layer.masksToBounds=YES;
        //        _button6.layer.borderWidth=3;
        //        _button6.layer.borderColor=[[UIColor colorWithRed:0.2371 green:0.2371 blue:0.2371 alpha:1.0] CGColor];
        _button6.tag=6;
        [_button6 addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button6;
}
- (UIView *)v5{
    if (!_v5) {
        _v5=[[UIView alloc]initWithFrame:CGRectMake(3*X+15, Y+8+P, 3, Y-18)];
        _v5.layer.masksToBounds=YES;
        _v5.layer.borderWidth=3;
        _v5.layer.borderColor=[[UIColor colorWithRed:0.2371 green:0.2371 blue:0.2371 alpha:1.0] CGColor];
    }
    return _v5;
}


- (UIButton*)button7{
    if (!_button7) {
        _button7=[UIButton buttonWithType:UIButtonTypeCustom];
        _button7.frame=CGRectMake(15, 2*Y+P, X, Y-5);
        _button7.layer.masksToBounds=YES;
        _button7.layer.borderWidth=2;
        _button7.layer.borderColor=[[UIColor colorWithRed:0.2371 green:0.2371 blue:0.2371 alpha:1.0] CGColor];
        _button7.tag=7;
        [_button7 addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button7;
}

- (UIButton*)button8{
    if (!_button8) {
        _button8=[UIButton buttonWithType:UIButtonTypeCustom];
        _button8.frame=CGRectMake(X+25, 2*Y+P, X-5, Y-5);
        _button8.layer.masksToBounds=YES;
        _button8.layer.borderWidth=2;
        _button8.layer.borderColor=[[UIColor colorWithRed:0.2371 green:0.2371 blue:0.2371 alpha:1.0] CGColor];
        _button8.tag=8;
        [_button8 addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button8;
}

- (UIButton*)button9{
    if (!_button9) {
        _button9=[UIButton buttonWithType:UIButtonTypeCustom];
        _button9.frame=CGRectMake(2*X+31, 2*Y+P, X-12, Y-5);
        _button9.layer.masksToBounds=YES;
        _button9.layer.borderWidth=2;
        _button9.layer.borderColor=[[UIColor colorWithRed:0.2371 green:0.2371 blue:0.2371 alpha:1.0] CGColor];
        _button9.tag=9;
        [_button9 addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button9;
}

//  获取当前view所处的viewController重写读方法
- (UIViewController*)viewController{
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (IBAction)button:(UIButton*)sender{
    BookView *bvc=[[BookView alloc] init];
    bvc.view.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    bvc.view.backgroundColor=[UIColor whiteColor];
    
    switch (sender.tag) {
        case 1:
            NSLog(@"1");
            bvc.kj_title=@"经典";
            [self.viewController.navigationController pushViewController:bvc animated:NO];
            break;
        case 2:
            NSLog(@"2");
                       // bvc.kj_title=@"2";
           // [self.viewController.navigationController pushViewController:bvc animated:NO];
            
            break;
            
        case 3:
            NSLog(@"3");
            
//            bvc.kj_title=@"3";
//            [self.viewController.navigationController pushViewController:bvc animated:NO];
            
            break;
            
        case 4:
            NSLog(@"4");
//            bvc.kj_title=@"4";
//            [self.viewController.navigationController pushViewController:bvc animated:NO];
            
            break;
            
        case 5:
            NSLog(@"1");
//            bvc.kj_title=@"5";
//            [self.viewController.navigationController pushViewController:bvc animated:NO];
            
            break;
            
        case 6:
            NSLog(@"1");
//            bvc.kj_title=@"6";
//            [self.viewController.navigationController pushViewController:bvc animated:NO];
            
            break;
            
        case 7:
            NSLog(@"1");
//            bvc.kj_title=@"7";
//            [self.viewController.navigationController pushViewController:bvc animated:NO];
            
            break;
            
        case 8:
            NSLog(@"1");
//            bvc.kj_title=@"8";
//            [self.viewController.navigationController pushViewController:bvc animated:NO];
            
            break;
            
        case 9:
            NSLog(@"1");
//            bvc.kj_title=@"9";
//            [self.viewController.navigationController pushViewController:bvc animated:NO];
            
            break;
    }
    
    //////
//    MyNews *nav = [[MyNews alloc]init];
//    [self.viewController.navigationController presentViewController:nav animated:NO completion:nil];
//    nav.TheTitle=@"习近平会见世界卫生组织中干事贺学军";
//    nav.URL=@"http://video.sina.com.cn/p/news/hangpai/doc/2016-07-25/143465296325.html";
//    NewsMode *mode=[[NewsMode alloc]init];
//    NSMutableArray *aa=[NSMutableArray array];
//    mode.recommendedText=@"第208节十八大代表大会决定贺学军为主席";
//    mode.recommendedURL=@"http://www.aiuxian.com/relative/p-609499.html";
//    [aa addObject:mode];
//    NewsMode *mode1=[[NewsMode alloc]init];
//    mode1.recommendedText=@"美国就贺学军担任面壁者方案持肯定态度";
//    mode1.recommendedURL=@"http://www.aiuxian.com/relative/p-609499.html";
//    [aa addObject:mode1];
//    NewsMode *mode2=[[NewsMode alloc]init];
//    mode2.recommendedText=@"比尔盖茨把所有遗产捐献给贺学军，贺学军表示并不在乎";
//    mode2.recommendedURL=@"http://www.aiuxian.com/relative/p-609499.html";
//    [aa addObject:mode2];
//    nav.recommended=aa;
    //////////
}

// 填充每个九宫格的图片
- (void)ruturnButton:(NSInteger)index{
    NSMutableArray *xx=[NSMutableArray array];
    UIImage *ab1=[UIImage imageNamed:@"10.jpg"];
    [xx addObject:ab1];
    UIImage *ab2=[UIImage imageNamed:@"12.jpg"];
    [xx addObject:ab2];
    UIImage *ab3=[UIImage imageNamed:@"13.gif"];
    [xx addObject:ab3];
    UIImage *ab4=[UIImage imageNamed:@"14.jpg"];
    [xx addObject:ab4];
    UIImage *ab5=[UIImage imageNamed:@"5.jpg"];
    [xx addObject:ab5];
    UIImage *ab6=[UIImage imageNamed:@"6.jpg"];
    [xx addObject:ab6];
    UIImage *ab7=[UIImage imageNamed:@"7.jpg"];
    [xx addObject:ab7];
    UIImage *ab8=[UIImage imageNamed:@"8.jpg"];
    [xx addObject:ab8];
    UIImage *ab9=[UIImage imageNamed:@"9.jpg"];
    [xx addObject:ab9];
    if (index==0) {
        [self.button1 setImage:xx[0] forState:UIControlStateNormal];
        [self.button2 setImage:xx[1] forState:UIControlStateNormal];
        [self.button3 setImage:xx[2] forState:UIControlStateNormal];
        [self.button4 setImage:xx[3] forState:UIControlStateNormal];
        [self.button5 setImage:xx[4] forState:UIControlStateNormal];
        [self.button6 setImage:xx[5] forState:UIControlStateNormal];
        [self.button7 setImage:xx[6] forState:UIControlStateNormal];
        [self.button8 setImage:xx[7] forState:UIControlStateNormal];
        [self.button9 setImage:xx[8] forState:UIControlStateNormal];
    }
    if (index==1) {
        [self.button1 setImage:xx[0] forState:UIControlStateNormal];
        [self.button2 setImage:xx[1] forState:UIControlStateNormal];
        [self.button3 setImage:xx[2] forState:UIControlStateNormal];
        [self.button4 setImage:xx[3] forState:UIControlStateNormal];
        [self.button5 setImage:xx[4] forState:UIControlStateNormal];
        [self.button6 setImage:xx[5] forState:UIControlStateNormal];
        [self.button7 setImage:xx[6] forState:UIControlStateNormal];
        [self.button8 setImage:xx[7] forState:UIControlStateNormal];
        [self.button9 setImage:xx[8] forState:UIControlStateNormal];
    }
    if (index==2) {
        [self.button1 setImage:xx[0] forState:UIControlStateNormal];
        [self.button2 setImage:xx[1] forState:UIControlStateNormal];
        [self.button3 setImage:xx[2] forState:UIControlStateNormal];
        [self.button4 setImage:xx[3] forState:UIControlStateNormal];
        [self.button5 setImage:xx[4] forState:UIControlStateNormal];
        [self.button6 setImage:xx[5] forState:UIControlStateNormal];
        [self.button7 setImage:xx[6] forState:UIControlStateNormal];
        [self.button8 setImage:xx[7] forState:UIControlStateNormal];
        [self.button9 setImage:xx[8] forState:UIControlStateNormal];
    }
}

@end

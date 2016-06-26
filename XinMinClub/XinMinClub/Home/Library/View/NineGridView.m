//
//  NineGridView.m
//  XinMinClub
//
//  Created by 杨科军 on 16/6/24.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "NineGridView.h"
#import "BookView.h"

#define X ((([UIScreen mainScreen].bounds.size.width)-30)/3)
#define Y (((self.bounds.size.height)-120)/3)


@interface NineGridView()

@property(nonatomic, readonly) UIViewController *viewController;

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

@end

@implementation NineGridView

- (id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self addSubview:self.backImageView];
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
    [self ruturnButton:isPeople];
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
        _button1.frame=CGRectMake(15, 10, X+8, Y);
//        _button1.layer.masksToBounds=YES;
//        _button1.layer.borderWidth=3;
//        _button1.layer.borderColor=[[UIColor colorWithRed:0.2371 green:0.2371 blue:0.2371 alpha:1.0] CGColor];
        _button1.tag=1;
        UIView *v=[[UIView alloc]initWithFrame:CGRectMake(12, 13, X+11, Y)];
        v.layer.masksToBounds=YES;
        v.layer.borderWidth=3;
        v.layer.borderColor=[[UIColor colorWithRed:0.2371 green:0.2371 blue:0.2371 alpha:1.0] CGColor];
        [self addSubview:v];
        [_button1 addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button1;
}

- (UIButton*)button2{
    if (!_button2) {
        _button2=[UIButton buttonWithType:UIButtonTypeCustom];
        _button2.frame=CGRectMake(X+25, 9, X, Y);
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
        _button3.frame=CGRectMake(2*X+27, 8, X-7, Y);
//        _button3.layer.masksToBounds=YES;
//        _button3.layer.borderWidth=3;
//        _button3.layer.borderColor=[[UIColor colorWithRed:0.2371 green:0.2371 blue:0.2371 alpha:1.0] CGColor];
        _button3.tag=3;
        UIView *v=[[UIView alloc]initWithFrame:CGRectMake(2*X+25, 11, X-7, Y)];
        v.layer.masksToBounds=YES;
        v.layer.borderWidth=3;
        v.layer.borderColor=[[UIColor colorWithRed:0.2371 green:0.2371 blue:0.2371 alpha:1.0] CGColor];
        [self addSubview:v];
        [_button3 addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button3;
}

- (UIButton*)button4{
    if (!_button4) {
        _button4=[UIButton buttonWithType:UIButtonTypeCustom];
        _button4.frame=CGRectMake(15, Y+12, X+9, Y-22);
//        _button4.layer.masksToBounds=YES;
//        _button4.layer.borderWidth=3;
//        _button4.layer.borderColor=[[UIColor colorWithRed:0.2371 green:0.2371 blue:0.2371 alpha:1.0] CGColor];
        _button4.tag=4;
        UIView *v=[[UIView alloc]initWithFrame:CGRectMake(12, Y+10, 3, Y-20)];
        v.layer.masksToBounds=YES;
        v.layer.borderWidth=1.4;
        v.layer.borderColor=[[UIColor colorWithRed:0.2371 green:0.2371 blue:0.2371 alpha:1.0] CGColor];
        [self addSubview:v];
        [_button4 addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button4;
}

- (UIButton*)button5{
    if (!_button5) {
        _button5=[UIButton buttonWithType:UIButtonTypeCustom];
        _button5.frame=CGRectMake(X+29.2, Y+10, X-4.7, Y-17);
//        _button5.layer.masksToBounds=YES;
//        _button5.layer.borderWidth=3;
//        _button5.layer.borderColor=[[UIColor colorWithRed:0.2371 green:0.2371 blue:0.2371 alpha:1.0] CGColor];
        _button5.tag=5;
        UIView *v=[[UIView alloc]initWithFrame:CGRectMake(X+26, Y+8, X-1, Y-13)];
        v.layer.masksToBounds=YES;
        v.layer.borderWidth=3;
        v.layer.borderColor=[[UIColor colorWithRed:0.2371 green:0.2371 blue:0.2371 alpha:1.0] CGColor];
        [self addSubview:v];
        [_button5 addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button5;
}

- (UIButton*)button6{
    if (!_button6) {
        _button6=[UIButton buttonWithType:UIButtonTypeCustom];
        _button6.frame=CGRectMake(2*X+26, Y+11, X-11, Y-21);
//        _button6.layer.masksToBounds=YES;
//        _button6.layer.borderWidth=3;
//        _button6.layer.borderColor=[[UIColor colorWithRed:0.2371 green:0.2371 blue:0.2371 alpha:1.0] CGColor];
        _button6.tag=6;
        UIView *v=[[UIView alloc]initWithFrame:CGRectMake(3*X+15, Y+8, 3, Y-18)];
        v.layer.masksToBounds=YES;
        v.layer.borderWidth=3;
        v.layer.borderColor=[[UIColor colorWithRed:0.2371 green:0.2371 blue:0.2371 alpha:1.0] CGColor];
        [self addSubview:v];
        [_button6 addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button6;
}

- (UIButton*)button7{
    if (!_button7) {
        _button7=[UIButton buttonWithType:UIButtonTypeCustom];
        _button7.frame=CGRectMake(15, 2*Y, X, Y-5);
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
        _button8.frame=CGRectMake(X+25, 2*Y, X-5, Y-5);
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
        _button9.frame=CGRectMake(2*X+31, 2*Y, X-12, Y-5);
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
        
    }
}

// 填充每个九宫格的图片
- (void)ruturnButton:(NSInteger)index{
    if (index==0) {
        NSMutableArray *xx=[NSMutableArray array];
        for (NSInteger i=0; i<9; i++) {
            UIImage *ab=[UIImage imageNamed:@"001_0000s_0002_102-副本"];
            [xx addObject:ab];
        }
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
        NSLog(@".....释");
    }
    if (index==2) {
        NSLog(@".....道");
    }
}

@end

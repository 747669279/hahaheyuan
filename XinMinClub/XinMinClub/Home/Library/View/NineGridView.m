//
//  NineGridView.m
//  XinMinClub
//
//  Created by 杨科军 on 16/6/24.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "NineGridView.h"

#define X ((([UIScreen mainScreen].bounds.size.width)-30)/3)
#define Y (((self.bounds.size.height)-120)/3)


@interface NineGridView()

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
        _button1.frame=CGRectMake(15, 10, X+10, Y);
        _button1.layer.masksToBounds=YES;
        _button1.layer.borderWidth=3;
        _button1.layer.borderColor=[[UIColor colorWithRed:0.2371 green:0.2371 blue:0.2371 alpha:1.0] CGColor];
        _button1.tag=1;
        UIView *v=[[UIView alloc]initWithFrame:CGRectMake(12, 13, X+10, Y)];
        v.layer.masksToBounds=YES;
        v.layer.borderWidth=3;
        v.layer.borderColor=[[UIColor colorWithRed:0.7118 green:0.1328 blue:0.2464 alpha:1.0] CGColor];
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
        _button3.frame=CGRectMake(2*X+27, 8, X-10, Y);
        _button3.layer.masksToBounds=YES;
        _button3.layer.borderWidth=3;
        _button3.layer.borderColor=[[UIColor colorWithRed:0.2371 green:0.2371 blue:0.2371 alpha:1.0] CGColor];
        _button3.tag=3;
        UIView *v=[[UIView alloc]initWithFrame:CGRectMake(2*X+25, 11, X-10, Y)];
        v.layer.masksToBounds=YES;
        v.layer.borderWidth=3;
        v.layer.borderColor=[[UIColor colorWithRed:0.7118 green:0.1328 blue:0.2464 alpha:1.0] CGColor];
        [self addSubview:v];
        [_button3 addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button3;
}

- (UIButton*)button4{
    if (!_button4) {
        _button4=[UIButton buttonWithType:UIButtonTypeCustom];
        _button4.frame=CGRectMake(0, Y, X, Y);
    }
    return _button4;
}

- (UIButton*)button5{
    if (!_button5) {
        _button5=[UIButton buttonWithType:UIButtonTypeCustom];
        _button5.frame=CGRectMake(X, Y, X, Y);
    }
    return _button5;
}

- (UIButton*)button6{
    if (!_button6) {
        _button6=[UIButton buttonWithType:UIButtonTypeCustom];
        _button6.frame=CGRectMake(2*X, Y, X, Y);
    }
    return _button1;
}

- (UIButton*)button7{
    if (!_button7) {
        _button7=[UIButton buttonWithType:UIButtonTypeCustom];
        _button7.frame=CGRectMake(0, 2*Y, X, Y);
    }
    return _button7;
}

- (UIButton*)button8{
    if (!_button8) {
        _button8=[UIButton buttonWithType:UIButtonTypeCustom];
        _button8.frame=CGRectMake(X, 2*Y, X, Y);
    }
    return _button8;
}

- (UIButton*)button9{
    if (!_button9) {
        _button9=[UIButton buttonWithType:UIButtonTypeCustom];
        _button9.frame=CGRectMake(2*X, 2*Y, X, Y);
    }
    return _button9;
}

- (IBAction)button:(UIButton*)sender{
    switch (sender.tag) {
        case 1:
            NSLog(@"1");
            break;
            
        default:
            break;
    }
}

@end

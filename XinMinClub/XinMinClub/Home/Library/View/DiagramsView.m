//
//  DiagramsView.m
//  XinMinClub
//
//  Created by 杨科军 on 16/6/22.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "DiagramsView.h"
#import <QuartzCore/QuartzCore.h>

@interface DiagramsView()

@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;

@property (nonatomic, strong) UIImageView *imag;
@property (nonatomic, strong) UIImageView *imag1;
//@property (nonatomic, strong) UIButton *button3;
//@property (nonatomic, strong) UIButton *button4;
//@property (nonatomic, strong) UIButton *button5;

@end

@implementation DiagramsView

- (id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self addSubview:self.button1];
        [self addSubview:self.button2];
        [self addSubview:self.imag];
        [self addSubview:self.imag1];
        //        [self addSubview:self.button3];
        //        [self addSubview:self.button4];
        //        [self addSubview:self.button5];
    }
    return self;
}

- (UIButton *)button1{
    if (!_button1) {
        _button1=[UIButton buttonWithType:UIButtonTypeCustom];
        _button1.frame=CGRectMake(SCREEN_WIDTH/8, SCREEN_HEIGHT/8, SCREEN_WIDTH/4, 10);
        //        _button1.backgroundColor=[UIColor blackColor];
        [_button1 setImage:[UIImage imageNamed:@"1213123123"] forState:UIControlStateNormal];
    }
    return _button1;
}


- (UIButton *)button2{
    if (!_button2) {
        _button2=[UIButton buttonWithType:UIButtonTypeCustom];
        _button2.frame=CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH/8-SCREEN_WIDTH/4, SCREEN_HEIGHT/8, SCREEN_WIDTH/4, 10);
        //        _button2.backgroundColor=[UIColor blackColor];
        [_button2 setImage:[UIImage imageNamed:@"1231212418971923"] forState:UIControlStateNormal];
        
    }
    return _button2;
}
- (UIImageView*)imag{
    if (!_imag) {
        _imag= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"12347"]];
        
        _imag.frame=CGRectMake((self.frame.size.width - SCREEN_WIDTH*5/10) / 2, SCREEN_HEIGHT/4-40, SCREEN_WIDTH*5/10, (SCREEN_WIDTH)*5/10);
        
        _imag.backgroundColor = [UIColor clearColor];
    }
    return _imag;
}
- (UIImageView*)imag1{
    if (!_imag1) {
        _imag1= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"12312"]];
        _imag1.frame=CGRectMake((self.frame.size.width - SCREEN_WIDTH*5/10) / 2, SCREEN_HEIGHT/4-40, SCREEN_WIDTH*5/10, (SCREEN_WIDTH)*5/10);
        _imag1.backgroundColor = [UIColor clearColor];
    }
    return _imag1;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [UIView beginAnimations:@"clockwiseAnimation" context:NULL];
//    /* Make the animation 5 seconds long */
//    [UIView setAnimationDuration:2.0f];
//    [UIView setAnimationDelegate:self];
//    //停止动画时候调用clockwiseRotationStopped方法
//    [UIView setAnimationDidStopSelector:@selector(clockwiseRotationStopped:finished:context:)];
////    顺时针旋转90度
//    _imag.transform = CGAffineTransformMakeRotation((0 * M_PI) / 180.0f);
//    _imag1.transform = CGAffineTransformMakeRotation((0 * M_PI) / 180.0f);
//    /* Commit the animation */
////    [UIView commitAnimations];
//    [UIView animateWithDuration:2
//                     animations:^{
//                         _imag.transform = CGAffineTransformRotate(self.transform, 110);
//                         _imag1.transform = CGAffineTransformRotate(self.transform, 110);
//                     }
//                     completion:^(BOOL completed){
//                         NSLog(@"Completed");
//                     }];
    [self startAnimation];
}

static NSInteger angle = 0;

-(void) startAnimation
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.01];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
    _imag.transform = CGAffineTransformMakeRotation(angle * (M_PI / 180.0f));
    _imag1.transform = CGAffineTransformMakeRotation(angle * (M_PI / 180.0f));
    [UIView commitAnimations];
}

-(void)endAnimation
{
    angle -= 40;
    if (angle >= -370) {
        [self depreate];
//        return;
    }
    [self startAnimation];
}

- (void)depreate {
    [UIView animateWithDuration:2
                     animations:^{
                        _imag.center = CGPointMake(-400, _imag.center.y);
                        _imag1.center = CGPointMake(800, _imag.center.y);
                     }
                     completion:^(BOOL completed){
                         NSLog(@"Completed");
                     }];
}

- (void)clockwiseRotationStopped:(NSString *)paramAnimationID finished:(NSNumber *)paramFinished
                         context:(void *)paramContext{
    [UIView beginAnimations:@"counterclockwiseAnimation"context:NULL];
    /* 5 seconds long */
    [UIView setAnimationDuration:2.0f];
    /* 回到原始旋转 */
    _imag.transform = CGAffineTransformIdentity;
    _imag1.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
}



//- (UIButton *)button3{
//    if (!_button3) {
//        _button3=[UIButton buttonWithType:UIButtonTypeCustom];
//        _button3.frame=CGRectMake(SCREEN_WIDTH/2-SCREEN_WIDTH/8, SCREEN_HEIGHT/4, SCREEN_WIDTH/4, 20);
//        _button3.backgroundColor=[UIColor whiteColor];
//
//
//    }
//    return _button3;
//}
//
//- (UIButton *)button4{
//    if (!_button4) {
//        _button4=[UIButton buttonWithType:UIButtonTypeCustom];
//        _button4.frame=CGRectMake(SCREEN_WIDTH/2-SCREEN_WIDTH/8, SCREEN_HEIGHT/4+40, SCREEN_WIDTH/4, 20);
//        _button4.backgroundColor=[UIColor whiteColor];
//
//
//    }
//    return _button4;
//}
//
//- (UIButton *)button5{
//    if (!_button5) {
//        _button5=[UIButton buttonWithType:UIButtonTypeCustom];
//        _button5.frame=CGRectMake(SCREEN_WIDTH/2-SCREEN_WIDTH/8, SCREEN_HEIGHT/4+80, SCREEN_WIDTH/4, 20);
//        _button5.backgroundColor=[UIColor whiteColor];
//
//
//    }
//    return _button5;
//}



@end

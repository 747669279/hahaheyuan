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

@property (nonatomic ,strong) UIImageView *imageview;
@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;
@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIImageView *imag;
@property (nonatomic, strong) UIImageView *imag1;
@property (nonatomic, strong) UIButton *button3;
@property(nonatomic )CGPoint  initalCenter;

@end

@implementation DiagramsView

- (id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self addSubview:self.button1];
        [self addSubview:self.button2];
        [self addSubview:self.imag];
        [self addSubview:self.imag1];
        [self addSubview:self.button3];
        _view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _view1.backgroundColor=[UIColor colorWithRed:0.653 green:0.9593 blue:1.0 alpha:0.0];
        [self addSubview:self.view1];
//        CGRect imageFrame;
//        if ([[UIDevice currentDevice].model isEqualToString:@"ipad"]) {
//            imageFrame = CGRectMake(0,0,300,200);
//        }else {
//            imageFrame = CGRectMake(0,0,240,160);
//        }
//        self.imageview = [[UIImageView alloc] initWithFrame:imageFrame];
//        self.imageview.image = [UIImage imageNamed:@"1213123123.png"];
//        self.imageview.center = self.view1.center;
//        [self addSubview:self.imageview];
        
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
       self.button1.userInteractionEnabled = YES;
         [self addGestureRecognizer:pan];
        self.initalCenter = self.button1.center;
    }
    return self;
}

- (UIButton *)button1{
    if (!_button1) {
        _button1=[UIButton buttonWithType:UIButtonTypeCustom];
        _button1.frame=CGRectMake(SCREEN_WIDTH/8, SCREEN_HEIGHT/8, SCREEN_WIDTH/4, 10);
        //        _button1.backgroundColor=[UIColor blackColor];
        [_button1 setImage:[UIImage imageNamed:@"1213123123"] forState:UIControlStateNormal];
       // [_button1 addTarget:self action:@selector(Share:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button1;
}
-(IBAction)Share:(id)sender{
    NSLog(@"点击了");
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
        _imag= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"123471"]];
        
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

//    [self startAnimation];
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
    angle -= 10;
    if (angle <= -370) {
        [self depreate];
        return;
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

//- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
//{
//    NSLog(@"x:%f",[[touches anyObject] locationInView:self].x);
//    NSLog(@"y:%f",[[touches anyObject] locationInView:self].y);
//    _button1.center=[[touches anyObject] locationInView:self];
//    
//}
//
//-(void)viewDidLoad{
//   
//     }

  -(void)pan:(UIPanGestureRecognizer *)sender{
      NSLog(@"%f", [sender translationInView:self.view1].x);
        NSLog(@"%f", [sender translationInView:self.view1].y);
      if (sender.state == UIGestureRecognizerStateBegan)
      { }else if(sender.state == UIGestureRecognizerStateChanged)
      {
          CGPoint translation = [sender translationInView:self.view1];
          self.button1.center = CGPointMake(self.initalCenter.x + translation.x,self.initalCenter.y + translation.y);
       }else{
          self.initalCenter = self.button1.center;
//          [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{ self.imageview.center = self.initalCenter; } completion:^(BOOL finished) { }];
      }
    }

- (UIButton *)button3{
    if (!_button3) {
        _button3=[UIButton buttonWithType:UIButtonTypeCustom];
        _button3.frame=CGRectMake(SCREEN_WIDTH-60, 10, 50, 30);
        [_button3 setTitle:@"跳过" forState:UIControlStateNormal];
        [_button3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_button3 addTarget:self action:@selector(xxx) forControlEvents:UIControlEventTouchUpInside];
        _button3.layer.masksToBounds=YES;
        _button3.layer.borderColor=[[UIColor redColor] CGColor];
        _button3.layer.borderWidth=0.5;
        _button3.layer.cornerRadius=5;
    }
    return _button3;
}

- (void)xxx{
    NSLog(@"跳过八卦图!!!");

}

@end

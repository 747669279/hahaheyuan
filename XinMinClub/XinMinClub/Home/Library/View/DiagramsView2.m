//
//  DiagramsView.m
//  XinMinClub
//
//  Created by 杨科军 on 16/6/22.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "DiagramsView2.h"
#import <QuartzCore/QuartzCore.h>
#import "PeopleView.h"

@interface DiagramsView2(){
    int i;
    int j1;
    int j2;
    int j3;
    int j4;
    int j5;
    int j6;
    int j7;
    int j8;
    NSMutableArray *Gossip;
    NSString *mima;
}

@property (nonatomic ,strong) UIImageView *imageview;
@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIImageView *imag;
@property (nonatomic, strong) UIImageView *imag1;
@property (nonatomic, strong) UIImageView *beijing;
//拖动卦象模块
@property (strong, nonatomic)  UIImageView *Quangua;//卦象的布局
@property (strong, nonatomic)  UIImageView *q;//单挂全色
@property (strong, nonatomic)  UIImageView *w;//单挂半色
@property(nonatomic )CGPoint  line1initalCenter;//单挂全色中点
@property(nonatomic )CGPoint  line2initalCenter;//单挂半色中点
//每一个挂的形式 命名（名字+标记）
@property (strong, nonatomic)  UIView *q13;
@property (strong, nonatomic)  UIView *q12;
@property (strong, nonatomic)  UIView *q11;

@property (strong, nonatomic)  UIView *q23;
@property (strong, nonatomic)  UIView *q22;
@property (strong, nonatomic)  UIView *q21;

@property (strong, nonatomic)  UIView *q33;
@property (strong, nonatomic)  UIView *q32;
@property (strong, nonatomic)  UIView *q31;

@property (strong, nonatomic)  UIView *q43;
@property (strong, nonatomic)  UIView *q42;
@property (strong, nonatomic)  UIView *q41;

@property (strong, nonatomic)  UIView *q53;
@property (strong, nonatomic)  UIView *q52;
@property (strong, nonatomic)  UIView *q51;

@property (strong, nonatomic)  UIView *q63;
@property (strong, nonatomic)  UIView *q62;
@property (strong, nonatomic)  UIView *q61;

@property (strong, nonatomic)  UIView *q73;
@property (strong, nonatomic)  UIView *q72;
@property (strong, nonatomic)  UIView *q71;

@property (strong, nonatomic)  UIView *q83;
@property (strong, nonatomic)  UIView *q82;
@property (strong, nonatomic)  UIView *q81;
//每一个挂的坐标范围
@property (strong, nonatomic)  UIView *q1;
@property (strong, nonatomic)  UIView *q2;
@property (strong, nonatomic)  UIView *q3;
@property (strong, nonatomic)  UIView *q4;
@property (strong, nonatomic)  UIView *q5;
@property (strong, nonatomic)  UIView *q6;
@property (strong, nonatomic)  UIView *q7;
@property (strong, nonatomic)  UIView *q8;

@end

@implementation DiagramsView2

- (id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        i=0;
        j1=0;
        j2=0;
        j3=0;
        j4=0;
        j5=0;
        j6=0;
        j7=0;
        j8=0;
        Gossip=[NSMutableArray arrayWithObjects:@"9",@"9",@"9",@"9",@"9",@"9",@"9",@"9",@"9",@"9",@"9",@"9",@"9",@"9",@"9",@"9",@"9",@"9",@"9",@"9",@"9",@"9",@"9",@"9",nil];
        mima=@"900000099990000009999999911111991111191919999999";
        [self addSubview:self.imag];
        [self addSubview:self.imag1];
        [self addSubview:self.beijing];
        [self addSubview:self.Quangua];
        [self addSubview:self.q];
        [self addSubview:self.w];
        [self addSubview:self.q1];
        [self addSubview:self.q2];
        [self addSubview:self.q3];
        [self addSubview:self.q4];
        [self addSubview:self.q5];
        [self addSubview:self.q6];
        [self addSubview:self.q7];
        [self addSubview:self.q8];
        [self stay:self.q :self.w];
    }
    return self;
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
    
    //[self startAnimation];
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

//拖动模块布局
-(UIImageView*)beijing{
    if (!_beijing) {
        _beijing=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _beijing.image=[UIImage imageNamed:@"beijing"];
    }
    return _beijing;
}
-(UIImageView*)Quangua{
    if (!_Quangua) {
        _Quangua=[[UIImageView alloc]initWithFrame:CGRectMake(37, 58, 250, 250)];
        _Quangua.image=[UIImage imageNamed:@"quantu"];
        
    }
    return _Quangua;
}
-(UIImageView*)q{
    if (!_q) {
        _q=[[UIImageView alloc]initWithFrame:CGRectMake(30, 0, 55, 55)];
        UIImageView *a=[[UIImageView alloc]initWithFrame:CGRectMake(0,30, 55, 8)];
        a.image=[UIImage imageNamed:@"quangua"];
        [_q addSubview:a];
    }
    return _q;
}
-(UIImageView*)w{
    if (!_w) {
        _w=[[UIImageView alloc]initWithFrame:CGRectMake(230, 0, 55, 55)];
        UIImageView *a=[[UIImageView alloc]initWithFrame:CGRectMake(0,30, 55, 8)];
        a.image=[UIImage imageNamed:@"banggua"];
        [_w addSubview:a];
    }
    return _w;
}
-(UIView*)q1{
    if (!_q1) {
        _q1=[[UIView alloc]initWithFrame:CGRectMake(170, 100, 80, 60)];
        _q1.alpha=0;
        _q11=[[UIView alloc]initWithFrame:CGRectMake(179, 107, 68, 10)];
        _q11.backgroundColor=[UIColor blackColor];
        _q11.alpha=0;
        [self addSubview:_q11];
        _q12=[[UIView alloc]initWithFrame:CGRectMake(179, 122, 68, 10)];
        _q12.backgroundColor=[UIColor blackColor];
        _q12.alpha=0;
        [self addSubview:_q12];
        
        _q13=[[UIView alloc]initWithFrame:CGRectMake(179, 138, 68, 10)];
        _q13.backgroundColor=[UIColor blackColor];
        _q13.alpha=0;
        [self addSubview:_q13];
        
    }
    return _q1;
}
-(UIView*)q2{
    if (!_q2) {
        _q2=[[UIView alloc]initWithFrame:CGRectMake(260, 120, 80, 80)];
        _q2.backgroundColor=[UIColor colorWithRed:0.887 green:1.000 blue:0.436 alpha:0.000];
        _q21=[[UIView alloc]initWithFrame:CGRectMake(271, 164, 68, 10)];
        _q21.backgroundColor=[UIColor blackColor];
        
        _q22=[[UIView alloc]initWithFrame:CGRectMake(255, 175, 68, 10)];
        _q22.backgroundColor=[UIColor blackColor];
        
        _q23=[[UIView alloc]initWithFrame:CGRectMake(266.5, 115, 68, 10)];
        UIImageView *q231=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"banggua"]];
        q231.bounds=_q23.bounds;
        [_q23 addSubview:q231];
        _q21.transform=CGAffineTransformMakeRotation(0.93);
        _q22.transform=CGAffineTransformMakeRotation(0.93);
        _q23.transform=CGAffineTransformMakeRotation(0.93);
        [self addSubview:_q21];
        [self addSubview:_q22];
        [self addSubview:_q23];
        _q21.alpha=0;
        _q22.alpha=0;
        _q23.alpha=0;
    }
    return _q2;
}

-(UIView*)q3{
    if (!_q3) {
        _q3=[[UIView alloc]initWithFrame:CGRectMake(300, 210, 60, 80)];
        _q3.backgroundColor=[UIColor colorWithRed:0.887 green:1.000 blue:0.436 alpha:0];
        _q31=[[UIView alloc]initWithFrame:CGRectMake(285, 208, 68, 10)];
        UIImageView *q331=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"banggua"]];
        q331.bounds=_q31.bounds;
        [_q31 addSubview:q331];
        _q31.alpha=0;
        [self addSubview:_q31];
        _q32=[[UIView alloc]initWithFrame:CGRectMake(300, 250, 68, 10)];
        _q32.alpha=0;
        _q32.backgroundColor=[UIColor blackColor];
        [self addSubview:_q32];
        
        _q33=[[UIView alloc]initWithFrame:CGRectMake(325, 208, 68, 10)];
        UIImageView *q333=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"banggua"]];
        q333.bounds=_q33.bounds;
        [_q33 addSubview:q333];
        _q33.alpha=0;
        [self addSubview:_q33];
        _q31.transform=CGAffineTransformMakeRotation(1.58);
        _q32.transform=CGAffineTransformMakeRotation(1.58);
        _q33.transform=CGAffineTransformMakeRotation(1.58);
    }
    return _q3;
}
-(UIView*)q4{
    if (!_q4) {
        _q4=[[UIView alloc]initWithFrame:CGRectMake(260, 300, 80, 80)];
        _q4.backgroundColor=[UIColor colorWithRed:0.887 green:1.000 blue:0.436 alpha:0];
        _q41=[[UIView alloc]initWithFrame:CGRectMake(255, 321, 68, 10)];
        _q41.backgroundColor=[UIColor blackColor];
        _q41.alpha=0;
        [self addSubview:_q41];
        _q42=[[UIView alloc]initWithFrame:CGRectMake(298, 306, 68, 10)];
        _q42.alpha=0;
        UIImageView *q432=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"banggua"]];
        q432.bounds=_q41.bounds;
        [_q42 addSubview:q432];
        [self addSubview:_q42];
        
        _q43=[[UIView alloc]initWithFrame:CGRectMake(310, 317, 68, 10)];
        UIImageView *q433=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"banggua"]];
        q433.bounds=_q43.bounds;
        [_q43 addSubview:q433];
        _q43.alpha=0;
        [self addSubview:_q43];
        _q41.transform=CGAffineTransformMakeRotation(2.34);
        _q42.transform=CGAffineTransformMakeRotation(2.34);
        _q43.transform=CGAffineTransformMakeRotation(2.34);
    }
    return _q4;
}
-(UIView*)q5{
    if (!_q5) {
        _q5=[[UIView alloc]initWithFrame:CGRectMake(135, 256, 60, 40)];
        _q5.backgroundColor=[UIColor colorWithRed:0.887 green:1.000 blue:0.436 alpha:0];
        UIImageView *q531=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"banggua"]];
        UIImageView *q532=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"banggua"]];
        UIImageView *q533=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"banggua"]];
        _q51=[[UIView alloc]initWithFrame:CGRectMake(89.5, 256, 53, 8)];
        _q51.alpha=0;
        q531.bounds=_q51.bounds;
        [_q51 addSubview:q531];
        [self addSubview:_q51];
        _q52=[[UIView alloc]initWithFrame:CGRectMake(89.5, 268, 53, 8)];
        _q52.alpha=0;
        q532.bounds=_q52.bounds;
        [_q52 addSubview:q532];
        [self addSubview:_q52];
        _q53=[[UIView alloc]initWithFrame:CGRectMake(89.5, 282, 53, 8)];
        _q53.alpha=0;
        q533.bounds=_q53.bounds;
        [_q53 addSubview:q533];
        [self addSubview:_q53];
    }
    return _q5;
}
-(UIView*)q6{
    if (!_q6) {
        _q6=[[UIView alloc]initWithFrame:CGRectMake(65, 226, 60, 60)];
        _q6.backgroundColor=[UIColor colorWithRed:0.887 green:1.000 blue:0.436 alpha:0];
        _q61=[[UIView alloc]initWithFrame:CGRectMake(62.5, 262, 53, 8)];
        _q61.backgroundColor=[UIColor blackColor];
        _q61.alpha=0;
        [self addSubview:_q61];
        _q62=[[UIView alloc]initWithFrame:CGRectMake(107.5, 284, 53, 8)];
        _q62.alpha=0;
        UIImageView *q632=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"banggua"]];
        q632.bounds=_q61.bounds;
        [_q62 addSubview:q632];
        [self addSubview:_q62];
        
        _q63=[[UIView alloc]initWithFrame:CGRectMake(115.5, 274, 53, 8)];
        UIImageView *q633=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"banggua"]];
        q633.bounds=_q63.bounds;
        [_q63 addSubview:q633];
        _q63.alpha=0;
        [self addSubview:_q63];
        _q61.transform=CGAffineTransformMakeRotation(3.78);
        _q62.transform=CGAffineTransformMakeRotation(3.78);
        _q63.transform=CGAffineTransformMakeRotation(3.78);
        
    }
    return _q6;
}
-(UIView*)q7{
    if (!_q7) {
        _q7=[[UIView alloc]initWithFrame:CGRectMake(23, 150, 60, 80)];
        _q7.backgroundColor=[UIColor colorWithRed:0.887 green:1.000 blue:0.436 alpha:0];
        _q71=[[UIView alloc]initWithFrame:CGRectMake(21, 182, 53, 8)];
        _q71.backgroundColor=[UIColor blackColor];
        _q71.alpha=0;
        [self addSubview:_q71];
        _q72=[[UIView alloc]initWithFrame:CGRectMake(43, 133, 53, 8)];
        _q72.alpha=0;
        
        UIImageView *q731=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"banggua"]];
        q731.bounds=_q72.bounds;
        [_q72 addSubview:q731];
        [self addSubview:_q72];
        
        _q73=[[UIView alloc]initWithFrame:CGRectMake(52, 182, 53, 8)];
        _q73.backgroundColor=[UIColor blackColor];
        _q73.alpha=0;
        [self addSubview:_q73];
        _q71.transform=CGAffineTransformMakeRotation(1.5708);
        _q72.transform=CGAffineTransformMakeRotation(1.5708);
        _q73.transform=CGAffineTransformMakeRotation(1.5708);
    }
    return _q7;
}
-(UIView*)q8{
    if (!_q8) {
        _q8=[[UIView alloc]initWithFrame:CGRectMake(50, 85, 70, 70)];
        _q8.backgroundColor=[UIColor colorWithRed:0.887 green:1.000 blue:0.436 alpha:0];
        _q81=[[UIView alloc]initWithFrame:CGRectMake(46, 105, 53, 8)];
        _q81.backgroundColor=[UIColor blackColor];
        _q81.alpha=0;
        [self addSubview:_q81];
        _q82=[[UIView alloc]initWithFrame:CGRectMake(59, 113, 53, 8)];
        _q82.backgroundColor=[UIColor blackColor];
        _q82.alpha=0;
        [self addSubview:_q82];
        
        _q83=[[UIView alloc]initWithFrame:CGRectMake(105, 87, 53, 8)];
        UIImageView *q831=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"banggua"]];
        q831.bounds=_q83.bounds;
        [_q83 addSubview:q831];
        _q83.alpha=0;
        
        [self addSubview:_q83];
        _q81.transform=CGAffineTransformMakeRotation(2.2);
        _q82.transform=CGAffineTransformMakeRotation(2.2);
        _q83.transform=CGAffineTransformMakeRotation(2.2);
    }
    return _q8;
}






//拖动实现
-(void)stay:(UIImageView*)line1 :(UIImageView*)line2{
    //Create can drag lines and binding method
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    line2.userInteractionEnabled = YES;
    [line2 addGestureRecognizer:pan];
    self.line2initalCenter = line2.center;
    UIPanGestureRecognizer * pan1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan1:)];
    line1.userInteractionEnabled = YES;
    [line1 addGestureRecognizer:pan1];
    self.line1initalCenter = line1.center;
    
    
}
-(void)pan:(UIPanGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateBegan)
    { }else if(sender.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [sender translationInView:self.w];
        self.w.center = CGPointMake(self.line2initalCenter.x + translation.x,self.line2initalCenter.y + translation.y);
    }else{
        if (i==2) {
            
            if (self.q23.alpha==0) {
                self.q23.alpha=1;
                [Gossip insertObject:@"0"atIndex:1];}
        }
        if (i==8) {
            
            if (self.q83.alpha==0) {
                self.q83.alpha=1;
                [Gossip insertObject:@"0"atIndex:2];}
        }
        if (i==7) {
            
            if (self.q72.alpha==0) {
                self.q72.alpha=1;
                [Gossip insertObject:@"0"atIndex:3];}
        }
        if (i==5) {
            j5++;
            switch (j5) {
                case 1:
                    if (self.q53.alpha==0) {
                        self.q53.alpha=1;
                        [Gossip insertObject:@"0"atIndex:4];}
                    break;
                case 2:
                    if (self.q52.alpha==0) {
                        self.q52.alpha=1;
                        [Gossip insertObject:@"0"atIndex:5];}
                    break;
                case 3:
                    if (self.q51.alpha==0) {
                        self.q51.alpha=1;
                        [Gossip insertObject:@"0"atIndex:6];}
                    break;
            }
            i=0;
        }
        if (i==3) {
            j3++;
            switch (j3) {
                case 1:
                    if (self.q31.alpha==0) {
                        self.q31.alpha=1;
                        [Gossip insertObject:@"0"atIndex:7];}
                    break;
                case 2:
                    if (self.q33.alpha==0) {
                        self.q33.alpha=1;
                        [Gossip insertObject:@"0"atIndex:8];}
                    break;
            }
            i=0;
        }
        if (i==4) {
            j4++;
            switch (j4) {
                case 1:
                    if (self.q42.alpha==0) {
                        self.q42.alpha=1;
                        [Gossip insertObject:@"0"atIndex:9];}
                    break;
                case 2:
                    if (self.q43.alpha==0) {
                        self.q43.alpha=1;
                        [Gossip insertObject:@"0"atIndex:10];}
                    break;
            }
            i=0;
        }
        if (i==6) {
            j6++;
            switch (j6) {
                case 1:
                    if (self.q63.alpha==0) {
                        self.q63.alpha=1;
                        [Gossip insertObject:@"0"atIndex:11];}
                    break;
                case 2:
                    if (self.q62.alpha==0) {
                        self.q62.alpha=1;
                        [Gossip insertObject:@"0"atIndex:12];}
                    break;
            }
            i=0;
        }
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{ self.w.center = self.line2initalCenter; } completion:^(BOOL finished) { }];
        NSString *aa=@"";
        for (NSString *aaa in Gossip) {
            aa=[aa stringByAppendingString:aaa];
        }
        if (mima == aa) {
            NSLog(@"密码正确");
        }
        if (Gossip.count==48) {
            NSLog(@"密码正确");
            [self startAnimation];
            [self disappear];
        }
        
        
    }
    [self criticalPoint:_w];
}
-(void)pan1:(UIPanGestureRecognizer *)sender{
    
    if (sender.state == UIGestureRecognizerStateBegan)
    {}else if(sender.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [sender translationInView:self.q];
        self.q.center = CGPointMake(self.line1initalCenter.x + translation.x,self.line1initalCenter.y + translation.y);
    }else{
        if (i==1) {
            j1++;
            switch (j1) {
                case 1:
                    if (self.q13.alpha==0) {
                        self.q13.alpha=1;
                        [Gossip insertObject:@"1"atIndex:13];
                    }
                    
                    
                    break;
                case 2:
                    if (self.q12.alpha==0) {
                        self.q12.alpha=1;
                        [Gossip insertObject:@"1"atIndex:14];
                    }
                    break;
                case 3:
                    if (self.q11.alpha==0) {
                        self.q11.alpha=1;
                        [Gossip insertObject:@"1"atIndex:15];
                    }
                    
                    break;
            }
            i=0;
        }
        if (i==2) {
            j2++;
            switch (j2) {
                case 1:
                    if (self.q22.alpha==0) {
                        self.q22.alpha=1;
                        [Gossip insertObject:@"1"atIndex:16];}
                    break;
                case 2:
                    if (self.q21.alpha==0) {
                        self.q21.alpha=1;
                        [Gossip insertObject:@"1"atIndex:17];}
                    break;
            }
            i=0;
        }
        if (i==8) {
            j8++;
            switch (j8) {
                case 1:
                    if (self.q81.alpha==0) {
                        self.q81.alpha=1;
                        [Gossip insertObject:@"1"atIndex:18];}
                    break;
                case 2:
                    if (self.q82.alpha==0) {
                        self.q82.alpha=1;
                        [Gossip insertObject:@"1"atIndex:19];}
                    break;
            }
            i=0;
        }
        if (i==7) {
            j7++;
            switch (j7) {
                case 1:
                    if (self.q71.alpha==0) {
                        self.q71.alpha=1;
                        [Gossip insertObject:@"1"atIndex:20];}
                    break;
                case 2:
                    if (self.q73.alpha==0) {
                        self.q73.alpha=1;
                        [Gossip insertObject:@"1"atIndex:21];}
                    break;
            }
            i=0;
        }
        
        if (i==3) {
            
            if (self.q32.alpha==0) {
                self.q32.alpha=1;
                [Gossip insertObject:@"1"atIndex:22];}
        }
        if (i==4) {
            
            if (self.q41.alpha==0) {
                self.q41.alpha=1;
                [Gossip insertObject:@"1"atIndex:23];}
        }
        if (i==6) {
            
            if (self.q61.alpha==0) {
                self.q61.alpha=1;
                [Gossip insertObject:@"1"atIndex:24];}
        }
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.q.center = self.line1initalCenter;
            //self.q.alpha=0;
        } completion:^(BOOL finished) {
            //self.q.center=self.line1initalCenter;
            //self.q.alpha=1;
        }];
        
        NSString *aa=@"";
        for (NSString *aaa in Gossip) {
            aa=[aa stringByAppendingString:aaa];
        }
        if (mima == aa) {
            NSLog(@"密码正确");
        }
        if (Gossip.count==48) {
            NSLog(@"密码正确");
            [self startAnimation];
            [self disappear];
        }
    }
    [self criticalPoint:_q];
    
}
-(void)disappear{
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _Quangua.alpha=0;
        _q11.alpha=0;
        _q12.alpha=0;
        _q13.alpha=0;
        _q21.alpha=0;
        _q22.alpha=0;
        _q23.alpha=0;
        _q31.alpha=0;
        _q32.alpha=0;
        _q33.alpha=0;
        _q41.alpha=0;
        _q42.alpha=0;
        _q43.alpha=0;
        _q51.alpha=0;
        _q52.alpha=0;
        _q53.alpha=0;
        _q61.alpha=0;
        _q62.alpha=0;
        _q63.alpha=0;
        _q71.alpha=0;
        _q72.alpha=0;
        _q73.alpha=0;
        _q81.alpha=0;
        _q82.alpha=0;
        _q83.alpha=0;
    } completion:^(BOOL finished) {
        
    }];
}
-(void)criticalPoint:(UIImageView*)aaa{
    //NSLog(@"***********%d",Gossip.count);
    //    PeopleView *pv=[[PeopleView alloc]initWithFrame:self.bounds];
    //    [self addSubview:pv];
    CGFloat x=aaa.center.x;
    CGFloat y=aaa.center.y;
    if (fabs(x-_q1.center.x)<20&&fabs(y-_q1.center.y)<20) {
        i=1;
    }
    if (fabs(x-_q2.center.x)<20&&fabs(y-_q2.center.y)<20) {
        i=2;
        
    }
    if (fabs(x-_q3.center.x)<20&&fabs(y-_q3.center.y)<20) {
        i=3;
        
    }
    if (fabs(x-_q4.center.x)<20&&fabs(y-_q4.center.y)<20) {
        i=4;
    }
    if (fabs(x-_q5.center.x)<20&&fabs(y-_q5.center.y)<20) {
        i=5;
    }
    if (fabs(x-_q6.center.x)<20&&fabs(y-_q6.center.y)<20) {
        i=6;
    }
    if (fabs(x-_q7.center.x)<20&&fabs(y-_q7.center.y)<20) {
        i=7;
    }
    if (fabs(x-_q8.center.x)<20&&fabs(y-_q8.center.y)<20) {
        i=8;
        
    }
}


@end

















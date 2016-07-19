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
@property (nonatomic,strong)UIScrollView *bamboo;
@property (nonatomic,strong)UIButton *classButton;
@property (nonatomic,strong)UIImageView *touXiang;
@property (nonatomic,strong)UIView *beijing;
@property (nonatomic,strong)UILabel *jianjie;
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UIScrollView *bottomScrollView;
@property (nonatomic, strong) UIView *beiJingTouMing;
@end

@implementation KJ_BookTableViewController
int a;
- (void)viewDidLoad{
    [super viewDidLoad];
    [self falseData];
    a=100;
    [self.view addSubview:self.topImageView];
    [self.view addSubview:self.bottomScrollView];
    // 创建button
    [self establishButton];
    [self.view addSubview:self.beiJingTouMing];
    [self.view addSubview:self.beijing];
    //添加手势
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event:)];
    
    
    
    //将手势添加到需要相应的view中去
    
    [_beiJingTouMing addGestureRecognizer:tapGesture];
    

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
    _beiJingTouMing.alpha=0.8;
    _beijing.alpha=1;
}
//点击
-(UIView*)beijing{
    if (!_beijing) {
        _beijing=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-100, SCREEN_HEIGHT/3)];
        _beijing.center=self.view.center;
        _beijing.backgroundColor=[UIColor brownColor];
        [_beijing addSubview:self.bamboo];
        [_beijing addSubview:self.touXiang];
        [_beijing addSubview:self.jianjie];
        _beijing.alpha=0;
    }
    return _beijing;
}
-(UILabel*)jianjie{
    if (!_jianjie) {
        _jianjie=[[UILabel alloc]initWithFrame:CGRectMake( self.beijing.bounds.size.width/4+10, 5, self.beijing.bounds.size.width/4*3-10,self.beijing.bounds.size.height/3)];
        _jianjie.text=@"阿斯达山东区发生的空间很大开始就带回去看见就卡死都不肯去空间会卡死的会计法就开始的不客气白金卡SD卡";
        NSLog(@"-------------%f",SCREEN_HEIGHT);
        if (SCREEN_HEIGHT==736) {
                    _jianjie.font = [UIFont fontWithName:@"Helvetica" size:18];
        }
        // 6
        if (SCREEN_HEIGHT==667){
        
                _jianjie.font = [UIFont fontWithName:@"Helvetica" size:15];
        }
        // 5S
        if (SCREEN_HEIGHT==568) {
                _jianjie.font = [UIFont fontWithName:@"Helvetica" size:12];
        }



        _jianjie.numberOfLines = 0;
    }
    return _jianjie;
}

-(UIButton *)classButton{
    _classButton=[[UIButton alloc]init];
    UIImage *bambooImage=[UIImage imageNamed:@"20090202235300316"];
    [_classButton setImage:[self OriginImage:bambooImage scaleToSize:CGSizeMake(self.beijing.bounds.size.width/8, self.beijing.bounds.size.height/7*4)] forState:UIControlStateNormal];
    [_classButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside]; // 绑定点击事件
    // 创建label
    
    return _classButton;
}

-(IBAction)buttonClick:(UIButton*)sender{
    NSLog(@"点击了%ld",(long)sender.tag);
}
-(UIScrollView *)bamboo{
    if (!_bamboo) {
        _bamboo=[[UIScrollView alloc]initWithFrame:CGRectMake(5, self.beijing.bounds.size.width/4+10, self.beijing.bounds.size.width-10,self.beijing.bounds.size.height-self.beijing.bounds.size.width/4)];
        for (int i=0; i<a; i++) {
            _classButton.tag=i;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8,10,100,100)];
            [label setText:[NSString stringWithFormat:@"第\n %d\n课",i]];
            label.numberOfLines = [label.text length];
            label.font = [UIFont fontWithName:@"Helvetica" size:15];
            // 添加到button中
            [_classButton addSubview:label];
            
            if (i==1) {
                _classButton.frame=CGRectMake(0, 0, self.beijing.bounds.size.width/8, self.beijing.bounds.size.height/3*2);
                [_bamboo addSubview:self.classButton];
                continue;
            }
            _classButton.frame=CGRectMake(i*self.beijing.bounds.size.width/8-self.beijing.bounds.size.width/8, 0, self.beijing.bounds.size.width/8, self.beijing.bounds.size.height/3*2);
            [_bamboo addSubview:self.classButton];
        }
        // 设置UIScrollView的滚动范围（内容大小）
        _bamboo.contentSize =CGSizeMake(a*self.beijing.bounds.size.width/8, 0);
        // 隐藏水平滚动条
        _bamboo.showsHorizontalScrollIndicator = NO;
        _bamboo.showsVerticalScrollIndicator = NO;
    }
    return _bamboo;
}
-(UIImageView *)touXiang{
    if (!_touXiang) {
        _touXiang=[[UIImageView alloc]initWithFrame:CGRectMake(5,5, self.beijing.bounds.size.width/4, self.beijing.bounds.size.height/3)];
        _touXiang.image=[UIImage imageNamed:@"20141111171218_zhYFC.jpg"];
    }
    return _touXiang;
}
-(UIImage*) OriginImage:(UIImage*)image scaleToSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);//size为CGSize类型，即你所需要的图片尺寸
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
    
}
-(UIView *)beiJingTouMing{
    if (!_beiJingTouMing) {
        _beiJingTouMing=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _beiJingTouMing.backgroundColor=[UIColor whiteColor];
        _beiJingTouMing.alpha=0;
    }
    return _beiJingTouMing;
}
-(IBAction)event:(id)sender{
    _beiJingTouMing.alpha=0;
    _beijing.alpha=0;

}
@end


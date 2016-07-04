//
//  ADViewController.m
//  XinMinClub
//
//  Created by yangkejun on 16/3/22.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "ADViewController.h"

@interface ADViewController ()

@property(nonatomic, copy) UIImageView *adImageView;
@property (nonatomic, strong) UIButton *goBackButton;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation ADViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    [self.view addSubview:self.adImageView];
    //    [self.view addSubview:self.goBackButton];
    
    self.title=_name;
    
    [self.view addSubview:self.webView];
}

- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
        NSURL *u;
        if (self.kk%2) {
            u = [NSURL URLWithString:@"https://mp.weixin.qq.com/s?__biz=MjM5NjY0NTQ3Mw==&mid=10000152&idx=1&sn=b99aba196800270039de54b1dcfd32bb&scene=1&srcid=1102bJH8qb7GiiH6JQBY8d0x&key=f5c31ae61525f82edf173171de59c943a4a88b99028e3a5856316a7e22250f7851f168201b142dc771b9e362873bfbfc&ascene=0&uin=ODU1NTc0NDU%3D&devicetype=iMac+MacBookPro12%2C1+OSX+OSX+10.11.5+build(15F34)&version=11020201&pass_ticket=C4xXnlmjv6rKq0sFeM0vPBkmrPO85TTG43QVXVBSD4E%3D"];
        }else{
            u = [NSURL URLWithString:@"http://mp.weixin.qq.com/s?__biz=MzI5NzI3Njc0MA==&mid=2247483680&idx=1&sn=7c3ada356bb961db3c95ad4fc20c5f11&scene=23&srcid=0523rdZNrexz9JryBAwejuDc#rd"];
        }
        NSURLRequest *aa = [[NSURLRequest alloc]initWithURL:u];
        [_webView loadRequest:aa];
    }
    return _webView;
}

- (UIButton *)goBackButton{
    if (!_goBackButton) {
        CGFloat x = 10;
        CGFloat y = 30;
        CGFloat w = 50;
        CGFloat h = 30;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(x, y, w, h);
        [button setTitle:@"返回" forState:UIControlStateNormal];//正常
        [button setTitleColor:[UIColor colorWithWhite:0.481 alpha:1.000] forState:UIControlStateNormal]; // 字体颜色
        [button addTarget:self action:@selector(gobackButton:) forControlEvents:UIControlEventTouchUpInside]; // 绑定点击事件
        button.showsTouchWhenHighlighted = YES; // 设置按钮按下会发光
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//文字左对齐
        _goBackButton = button;
    }
    return _goBackButton;
}

- (UIImageView *)adImageView{
    if (_adImageView == nil) {
        _adImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _adImageView.image = self.adImage;
    }
    return _adImageView;
}

#pragma mark Action
// 返回按钮
- (void)gobackButton:(UIButton *)sender{
    // 设置切换动画
    CATransition *animation = [CATransition animation];
    animation.duration = 0.4;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"cube";
    animation.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end



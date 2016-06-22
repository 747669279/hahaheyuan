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

@end

@implementation ADViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.adImageView];
    [self.view addSubview:self.goBackButton];
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



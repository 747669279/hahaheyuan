//
//  KJ_DDViewController.m
//  XinMinClub
//
//  Created by 杨科军 on 16/7/20.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "KJ_DDViewController.h"

@interface KJ_DDViewController ()

@property (nonatomic, strong) UIView *navigationView;

@end

@implementation KJ_DDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView=self.navigationView;
}

- (UIView *)navigationView{
    if (!_navigationView) {
        _navigationView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-100, 44)];
        _navigationView.backgroundColor=[UIColor greenColor];
        UILabel *l1=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, _navigationView.bounds.size.width, 24)];
        UILabel *l2=[[UILabel alloc]initWithFrame:CGRectMake(0, 24, _navigationView.bounds.size.width, 20)];
        
        l1.text=@"作者名字";
        l2.text=@"这是第几课";
        l1.textAlignment=NSTextAlignmentCenter;
        l2.textAlignment=NSTextAlignmentCenter;
        l1.font=[UIFont systemFontOfSize:16];
        l2.font=[UIFont systemFontOfSize:14];
        
        [_navigationView addSubview:l1];
        [_navigationView addSubview:l2];
    }
    return _navigationView;
}


@end

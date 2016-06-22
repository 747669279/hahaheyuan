//
//  Share.m
//  player
//
//  Created by 贺军 on 16/3/30.
//  Copyright © 2016年 Admin. All rights reserved.
//

#import "ShareViewController.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"

@interface ShareViewController ()

@property(nonatomic,strong)UIButton *weixing;
@property(nonatomic,strong)UILabel *weixingLabel;
@property(nonatomic,strong)UIButton *peiyouquan;
@property(nonatomic,strong)UILabel *peiyouquanLabel;
@property(nonatomic,strong)UIButton *TXqq;
@property(nonatomic,strong)UILabel *TXqqLabel;
@property(nonatomic,strong)UIButton *qqkongjian;
@property(nonatomic,strong)UILabel *qqkongjianLabel;
@property(nonatomic,strong)UIButton *xingnan;
@property(nonatomic,strong)UILabel *xingnanLabel;
@property(nonatomic,strong)UIButton *TXweibo;
@property(nonatomic,strong)UILabel *TXweiLabel;

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.weixing];
    [self.view addSubview:self.weixingLabel];
    [self.view addSubview:self.peiyouquan];
    [self.view addSubview:self.peiyouquanLabel];
    [self.view addSubview:self.TXqq];
    [self.view addSubview:self.TXqqLabel];
    [self.view addSubview:self.qqkongjian];
    [self.view addSubview:self.qqkongjianLabel];
    [self.view addSubview:self.xingnan];
    [self.view addSubview:self.xingnanLabel];
    [self.view addSubview:self.TXweibo];
    [self.view addSubview:self.TXweiLabel];
}

-(UIImage*)OriginImage:(UIImage*)image scaleToSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);//size为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

-(UIButton*)weixing{
    if (!_weixing) {
        _weixing=[[UIButton alloc]initWithFrame:CGRectMake(30, 10, (SCREEN_WIDTH-160)/4, (SCREEN_WIDTH-160)/4)];
        [_weixing setImage:[self OriginImage:[UIImage imageNamed:@"weixing"] scaleToSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
        [_weixing setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [_weixing addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _weixing.tag = 1;
    }
    return _weixing;
}
- (UILabel *)weixingLabel{
    if (_weixingLabel == nil) {
        _weixingLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, (SCREEN_WIDTH-160)/4+11, (SCREEN_WIDTH-160)/4, 10)];
        _weixingLabel.text = @"微信";
        _weixingLabel.font = [UIFont systemFontOfSize:13];
        _weixingLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _weixingLabel;
}
-(UIButton*)peiyouquan{
    if (!_peiyouquan) {
        _peiyouquan=[[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-20)/4+30, 10, (SCREEN_WIDTH-160)/4, (SCREEN_WIDTH-160)/4)];
        [_peiyouquan setImage:[self OriginImage:[UIImage imageNamed:@"weixingpyq"] scaleToSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
        [_peiyouquan setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [_peiyouquan addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _peiyouquan.tag = 2;
    }
    return _peiyouquan;
}
- (UILabel *)peiyouquanLabel{
    if (_peiyouquanLabel == nil) {
        _peiyouquanLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-20)/4+30, (SCREEN_WIDTH-160)/4+11, (SCREEN_WIDTH-160)/4, 10)];
        _peiyouquanLabel.text = @"朋友圈";
        _peiyouquanLabel.font = [UIFont systemFontOfSize:13];
        _peiyouquanLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _peiyouquanLabel;
}

-(UIButton*)TXqq{
    if (!_TXqq) {
        _TXqq=[[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-20)/2+30, 10, (SCREEN_WIDTH-160)/4, (SCREEN_WIDTH-160)/4)];
        [_TXqq setImage:[self OriginImage:[UIImage imageNamed:@"qq"] scaleToSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
        [_TXqq addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _TXqq.tag = 3;
    }
    return _TXqq;
}
- (UILabel *)TXqqLabel{
    if (_TXqqLabel == nil) {
        _TXqqLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-20)/2+25, (SCREEN_WIDTH-160)/4+11, (SCREEN_WIDTH-160)/4+10, 10)];
        _TXqqLabel.text = @"腾讯QQ";
        _TXqqLabel.font = [UIFont systemFontOfSize:13];
        _TXqqLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _TXqqLabel;
}

-(UIButton*)qqkongjian{
    if (!_qqkongjian) {
        _qqkongjian=[[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-20)*3/4+30, 10, (SCREEN_WIDTH-160)/4, (SCREEN_WIDTH-160)/4)];
        [_qqkongjian setImage:[self OriginImage:[UIImage imageNamed:@"qqkongjian"] scaleToSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
        [_qqkongjian setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [_qqkongjian addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _qqkongjian.tag = 4;
    }
    return _qqkongjian;
}
- (UILabel *)qqkongjianLabel{
    if (_qqkongjianLabel == nil) {
        _qqkongjianLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-20)*3/4+25, (SCREEN_WIDTH-160)/4+11, (SCREEN_WIDTH-160)/4+10, 10)];
        _qqkongjianLabel.text = @"QQ空间";
        _qqkongjianLabel.font = [UIFont systemFontOfSize:13];
        _qqkongjianLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _qqkongjianLabel;
}

-(UIButton*)xingnan{
    if (!_xingnan) {
        _xingnan=[[UIButton alloc]initWithFrame:CGRectMake(30, (SCREEN_WIDTH-160)/4+40, (SCREEN_WIDTH-160)/4, (SCREEN_WIDTH-160)/4)];
        [_xingnan setImage:[self OriginImage:[UIImage imageNamed:@"xingnanweibo"] scaleToSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
        [_xingnan setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [_xingnan addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _xingnan.tag = 5;
    }
    
    return _xingnan;
}
- (UILabel *)xingnanLabel{
    if (_xingnanLabel == nil) {
        _xingnanLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, (SCREEN_WIDTH-160)*2/4+42, (SCREEN_WIDTH-160)/4+20, 10)];
        _xingnanLabel.text = @"新浪微博";
        _xingnanLabel.font = [UIFont systemFontOfSize:13];
        _xingnanLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _xingnanLabel;
}

-(UIButton*)TXweibo{
    if (!_TXweibo) {
        _TXweibo=[[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-20)/4+30, (SCREEN_WIDTH-160)/4+40, (SCREEN_WIDTH-160)/4, (SCREEN_WIDTH-160)/4)];
        [_TXweibo setImage:[self OriginImage:[UIImage imageNamed:@"qqweibo"] scaleToSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
        [_TXweibo setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [_TXweibo addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _TXweibo.tag = 6;
    }
    return _TXweibo;
}
- (UILabel *)TXweiLabel{
    if (_TXweiLabel == nil) {
        _TXweiLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-20)/4+20, (SCREEN_WIDTH-160)*2/4+42, (SCREEN_WIDTH-160)/4+20, 10)];
        _TXweiLabel.text = @"腾讯微博";
        _TXweiLabel.font = [UIFont systemFontOfSize:13];
        _TXweiLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _TXweiLabel;
}

#pragma mark ButtonActions
-(IBAction)buttonAction:(UIButton *)sender{
    if (sender.tag == 1) {
        [self fenxiang:1];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:self.Content image:self.Image location:self.Location urlResource:self.UrlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
    }
    if (sender.tag == 2) {
        [self fenxiang:2];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:self.Content image:self.Image location:self.Location urlResource:self.UrlResource  presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
    }
    if (sender.tag == 3) {
        [self fenxiang:3];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:self.Content image:self.Image location:self.Location urlResource:self.UrlResource  presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
    }
    if (sender.tag == 4) {
        [self fenxiang:4];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:self.Content image:self.Image location:self.Location urlResource:self.UrlResource  presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
    }
    if (sender.tag == 5) {
        [self fenxiang:5];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:self.Content image:self.Image location:self.Location urlResource:self.UrlResource  presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
        
    }
    if (sender.tag == 6) {
        [self fenxiang:6];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToTencent] content:self.Content image:self.Image location:self.Location urlResource:self.UrlResource  presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeShare" object:nil userInfo:nil];
}

- (void)fenxiang:(NSInteger)aaa{
    NSDictionary *aa=@{@"fenxiang111":@(1)};
    if (aaa==6) {
        aa=@{@"tenxunweibo":@(0)};
    }else
        aa=@{@"tenxunweibo":@(1)};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"fenxiang111" object:nil userInfo:aa];
    
}

@end

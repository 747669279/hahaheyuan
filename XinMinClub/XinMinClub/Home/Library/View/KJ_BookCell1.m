//
//  KJ_BookCell1.m
//  XinMinClub
//
//  Created by 杨科军 on 16/5/23.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "KJ_BookCell1.h"
#import "MJBannnerPlayer.h"

@interface KJ_BookCell1()<MJBannnerPlayerDeledage>

@end

@implementation KJ_BookCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   
}

- (void)setKj_adImageArray:(NSArray *)kj_adImageArray{
    _kj_adImageArray=kj_adImageArray;
   
    [self adPlayer];
}

// 初始化一个本地图片的滚动广告
- (void)adPlayer{
    [MJBannnerPlayer initWithSourceArray:_kj_adImageArray addTarget:self delegate:self withSize:self.bounds withTimeInterval:2.f];
}
#pragma mark MJBannnerPlayerDeledage
-(void)MJBannnerPlayer:(UIView *)bannerPlayer didSelectedIndex:(NSInteger)index{
    // TODO: 点击了滚动广告未完成
    NSLog(@"点击了Ad图片%d",index);
    //    ADViewController *advc = [[ADViewController alloc] init];
    //    advc.adImage = adArray[index];
    //    [self presentViewController:advc animated:NO completion:nil];
}


@end

//
//  SectionOperation.m
//  XinMinClub
//
//  Created by 赵劲松 on 16/4/28.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "SectionOperation.h"

@implementation SectionOperation

+ (void)sectionManage:(UIView *)backView StatusView:(UIView *)statusview andViewController:(UIViewController *)controller {
    
    backView.hidden = NO;
    [UIView animateWithDuration:0.15 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        backView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.354];
        statusview.frame = CGRectMake(0, SCREEN_HEIGHT / 6 * 5 - 5, SCREEN_WIDTH, SCREEN_HEIGHT / 6 + 5);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            statusview.frame = CGRectMake(0, SCREEN_HEIGHT / 6 * 5, SCREEN_WIDTH, SCREEN_HEIGHT / 6);
        }completion:nil];
    }];
}

@end

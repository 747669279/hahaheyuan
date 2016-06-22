//
//  PlayAllCell.m
//  XinMinClub
//
//  Created by yangkejun on 16/3/22.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "PlayAllCell.h"

@implementation PlayAllCell


- (IBAction)playAllButton:(UIButton *)sender {
    NSLog(@"点击了播放全部");
    
}

- (IBAction)downButton:(UIButton *)sender {
    NSLog(@"点击了下载");
}

- (IBAction)selectButton:(UIButton *)sender {
    NSLog(@"点击了多选");
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  SetCell.m
//  XinMinClub
//
//  Created by Jason_zzzz on 16/3/24.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "SetCell.h"

@interface SetCell () {
    
}


@end

@implementation SetCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setColor:(UIColor *)color {
    _topView.backgroundColor = color;
    _footView.backgroundColor = color;
    _middleView.backgroundColor = color;
    _topCoverView.backgroundColor = color;
    _footCoverView.backgroundColor = color;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

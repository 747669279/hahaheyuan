//
//  SeeThinkCell.m
//  XinMinClub
//
//  Created by 赵劲松 on 16/7/19.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "SeeThinkCell.h"

@implementation SeeThinkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat cellHeight  = 0;
    cellHeight += [self.peopleText sizeThatFits:size].height;
    cellHeight += 40;
    return CGSizeMake(size.width, size.height);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

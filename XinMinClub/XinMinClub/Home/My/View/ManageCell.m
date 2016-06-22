//
//  ManageCell.m
//  XinMinClub
//
//  Created by Jason_zzzz on 16/3/25.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "ManageCell.h"

@implementation ManageCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        // 去掉点击动画
        self.playLabel.adjustsImageWhenHighlighted = NO;
        self.playImage.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)playAll:(id)sender {
    [_manageDelegate playAll];
}
- (IBAction)manageAll:(id)sender {
    [_manageDelegate manageAll];
}

@end

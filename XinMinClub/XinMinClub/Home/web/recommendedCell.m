//
//  recommendedCell.m
//  qweqwe
//
//  Created by 贺军 on 16/7/27.
//  Copyright © 2016年 贺军. All rights reserved.
//

#import "recommendedCell.h"
@interface recommendedCell (){
    __weak IBOutlet UIButton *recommendedClack;
}
@end
@implementation recommendedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
-(void)setRecommended:(NewsMode *)Recommended{
   [recommendedClack setTitle:Recommended.recommendedText forState:UIControlStateNormal];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (IBAction)Clack:(UIButton *)sender {
    NSLog(@"点击了相关推荐！！");
}

@end

//
//  DetailsCell3.m
//  XinMinClub
//
//  Created by 杨科军 on 16/4/22.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "DetailsCell3.h"
#import "UIImageView+WebCache.h"

@interface DetailsCell3()

@property (weak, nonatomic) IBOutlet UIImageView *details3ImageView;
@property (weak, nonatomic) IBOutlet UILabel *details3Label;

@end

@implementation DetailsCell3

- (void)setImageUrl:(NSString *)imageUrl{
    self.details3ImageView.layer.masksToBounds = YES;
    self.details3ImageView.layer.cornerRadius = self.details3ImageView.frame.size.height/2;
    [self.details3ImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}

- (void)setLibraryName:(NSString *)libraryName{
    NSString *s = [NSString stringWithFormat:@": %@",libraryName];
    self.details3Label.text = s;
}

@end

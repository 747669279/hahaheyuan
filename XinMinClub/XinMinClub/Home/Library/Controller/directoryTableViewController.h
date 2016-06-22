//
//  directoryTableViewController.h
//  XinMinClub
//
//  Created by 贺军 on 16/5/5.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface directoryTableViewController : UIViewController

@property(nonatomic)BOOL hasBeenTo;//到了顶部
@property(nonatomic)BOOL whenTheTop;//自己时候到了顶部
@property(nonatomic)CGFloat SlidingPosition;//滑动的位置
// 区分不同文集的编号
@property(nonatomic,copy) NSString *kj_libraryNum;
@property (nonatomic, strong) NSString *kj_imageUrll;

@end


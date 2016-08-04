//
//  CommentTableViewController.h
//  XinMinClub
//
//  Created by 赵劲松 on 16/8/2.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommentDelegate <NSObject>

- (void)content: (NSString *)string;

@end

@interface CommentTableViewController : UITableViewController

@property (nonatomic, weak) id<CommentDelegate> delegate;

@end

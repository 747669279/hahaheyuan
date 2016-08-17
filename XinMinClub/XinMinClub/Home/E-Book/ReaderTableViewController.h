//
//  ReaderTableViewController.h
//  XinMinClub
//
//  Created by 贺军 on 16/4/7.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "theIncomingDataModel.h"
@interface ReaderTableViewController : UIViewController

+ (instancetype)shareObject;
-(void)setSectionArray:(NSMutableArray<theIncomingDataModel*>*)DataModel WhetherTheAudio:(NSMutableArray*)Audio data:(NSArray *)dataArray;
@property(nonatomic)NSInteger readTag;
@end

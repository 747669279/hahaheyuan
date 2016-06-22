//
//  LyricsView.h
//  player
//
//  Created by Admin on 16/3/25.
//  Copyright © 2016年 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LyricsViewController : UITableViewController

// 单例
+ (instancetype)shareObject;

@property(nonatomic,strong)NSMutableArray *Lyr;//歌词
@property(nonatomic)NSInteger LyrTamin;//当前歌词滚动位子
-(NSInteger)getLyrTamin;//获得歌词当前的位子
@end

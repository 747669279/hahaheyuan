//
//  PalyerView.h
//  player
//
//  Created by Admin on 16/3/22.
//  Copyright © 2016年 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KJ_BackTableViewController.h"
#import "FivePointsToTheInterface/theIncomingDataModel.h"
@interface PalyerViewController : UIViewController
@property (nonatomic, strong) NSString *mp3Url;  // 传入的一首MP3
@property (nonatomic, strong) NSArray *libraryNameArray; // 传入全部的名字
@property (nonatomic, strong) NSString *lyric; // 歌词
@property (nonatomic, strong) NSString *clickNum; // 点击的是哪个cell
@property (nonatomic) BOOL isPlayEnd; // 判断是否播放结束
@property (nonatomic) int PalyerState;//播放按钮的状态
@property (nonatomic, strong) NSString *PalyerLyr;//播放的歌词
@property (nonatomic, strong) NSString *PalyerName;//播放的名字
@property (nonatomic, strong) NSString *PalyerImage;//播放的头像
@property(nonatomic,strong)KJ_BackTableViewController *myClickLibraryViewController;
// 单例
+ (instancetype)shareObject;
-(void)PalyerMusicURL:(NSMutableArray<theIncomingDataModel*>*)DataModel WhetherTheAudio:(NSMutableArray*)Audio;
-(void)MusicURL:(NSMutableArray<theIncomingDataModel*>*)DataModel WhetherTheAudio:(NSMutableArray*)Audio;
-(int)ClickPalyer;
@end

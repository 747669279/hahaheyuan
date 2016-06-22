//
//  PlayerSupport.h
//  player
//
//  Created by Admin on 16/3/22.
//  Copyright © 2016年 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
@protocol PlayerSupportDelegate;
@interface PlayerSupport : NSObject
@property(nonatomic, assign) id<PlayerSupportDelegate> delegate;
@property(nonatomic,strong)NSString *status;//播放状态，通过监听可以判是否播放
@property(nonatomic,strong)NSString *playerURLMusic;//传入网络地址播放网络歌曲
@property(nonatomic,strong)NSString *playerLocalMusic;//存入音乐名播放本地歌曲
@property (nonatomic ,strong) AVPlayerItem *playerItem;
-(CGFloat)getPlayProgress;//获得当前播放的进度
-(CGFloat)getDownloadProgress;//获得当前缓存的进度
-(NSString*)getAllMusicTime;//返回当前播放的时间
-(NSString*)getNowMisocTime;//返回总时间
-(NSInteger)getAllIntMusicTime;//返回当前播放的时间(数字)
-(NSInteger)getNowIntMisocTime;//返回总时间(数字)
-(CGFloat)getPlayTime;//获得总时间的数字
-(void)Suspended;//暂停当前音乐
-(void)Myplay;//播放音乐
-(void)nowToTime:(CMTime)time;//设置当前播放时间
-(void)DownloadMusic:(NSString *)url DownName:(NSString*)name;//根据URL下载歌曲到本地
@end

@protocol PlayerSupportDelegate <NSObject>
-(void)DownloadComplete:(NSString*)name;//下载完成返回歌曲名
-(void)JudgePlayer:(BOOL)State;//判断歌曲是否已经播放完成
@end







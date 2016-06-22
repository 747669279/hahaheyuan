//
//  PlayerSupport.m
//  player
//
//  Created by Admin on 16/3/22.
//  Copyright © 2016年 Admin. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "PlayerSupport.h"
#import <UIKit/UIKit.h>

@interface PlayerSupport(){
   AVPlayer *Player;
   NSTimer *playProgresTimer;
   CGFloat cache;
    BOOL off;
}
@end
    
@implementation PlayerSupport

-(id)init{
    if (self=[super init]) {
         playProgresTimer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(PlayProgressTimer) userInfo:nil repeats:YES];
        off=NO;
        

    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSTimeInterval timeInterval = [self availableDuration];// 计算缓冲进度
        CMTime duration = self.playerItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        cache=timeInterval/totalDuration;
    }
}
- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[Player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

-(void)PlayProgressTimer{
    if (Player.status==1) {
        self.status=[NSString stringWithFormat:@"%d",Player.status];
        [playProgresTimer invalidate];
    }
    if (Player.status==2) {
        self.status=[NSString stringWithFormat:@"%d",Player.status];
        [playProgresTimer invalidate];
    }
}
-(void)Suspended{//暂停当前音乐
    [Player pause];
}
-(void)Myplay{//播放音乐
    if (!off) {
        [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        off=YES;
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:Player.currentItem];
    [Player play];
}

-(void)moviePlayDidEnd{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_delegate JudgePlayer:YES];
    
}

-(void)setPlayerURLMusic:(NSString *)playerURLMusic{//播放网络音乐
    if (off) {
        [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
        off=NO;
    }
    NSURL *audioUrl = [NSURL URLWithString:playerURLMusic];
    self.playerItem = [AVPlayerItem playerItemWithURL:audioUrl];
        Player = [AVPlayer playerWithPlayerItem:self.playerItem];
    
}
-(void)setPlayerLocalMusic:(NSString *)playerLocalMusic{//播放本地音乐
    if (off) {
        [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
        off=NO;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@.mp3", docDirPath ,playerLocalMusic];
         NSURL *fileURL = [NSURL fileURLWithPath:filePath];
        self.playerItem = [AVPlayerItem playerItemWithURL:fileURL];
        Player = [AVPlayer playerWithPlayerItem:self.playerItem];
        [Player play];
    });
}
-(CGFloat)getPlayProgress{//返回当前进度条
    return CMTimeGetSeconds(Player.currentItem.currentTime) / CMTimeGetSeconds(Player.currentItem.duration);
}
-(NSString*)getAllMusicTime{//返回当前时间
    CGFloat time=CMTimeGetSeconds(Player.currentItem.currentTime);
    NSInteger a=(NSInteger)time/60;
    NSInteger b=(NSInteger)time%60;
    NSString *A;
    NSString *B;
    if (a<10)
          A= [NSString stringWithFormat:@"0%d:",a];
    else
          A= [NSString stringWithFormat:@"%d:",a];
    if (b<10)
        B= [NSString stringWithFormat:@"0%d",b];
    else
        B= [NSString stringWithFormat:@"%d",b];
    NSString *Tami=[A stringByAppendingString:B];
    return Tami;
}
-(NSInteger)getAllIntMusicTime{
    return CMTimeGetSeconds(Player.currentItem.currentTime);
}
-(NSInteger)getNowIntMisocTime{
    return CMTimeGetSeconds(Player.currentItem.duration);
}

-(CGFloat)getPlayTime{
    return CMTimeGetSeconds(Player.currentItem.duration);
}
-(NSString*)getNowMisocTime{//返回总时间
    CGFloat time=CMTimeGetSeconds(Player.currentItem.duration);
    NSInteger a=(NSInteger)time/60;
    NSInteger b=(NSInteger)time%60;
    NSString *A;
    if (a<10) {
            A= [NSString stringWithFormat:@"0%d:",a];
    }else{
            A= [NSString stringWithFormat:@"%d:",a];
    }
    NSString *B= [NSString stringWithFormat:@"%d",b];
    NSString *Tami=[A stringByAppendingString:B];
    return Tami;
}
-(CGFloat)getDownloadProgress{
    return cache;
}

-(void)DownloadMusic:(NSString *)url DownName:(NSString*)name{//网络下载
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url1 = [[NSURL alloc]initWithString:url];
        NSData * audioData = [NSData dataWithContentsOfURL:url1];
        // 将数据保存到本地指定位置
        NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@.mp3", docDirPath ,name];
        [audioData writeToFile:filePath atomically:YES];
        [_delegate DownloadComplete:name];
    });
}

-(void)nowToTime:(CMTime)time{
    [Player seekToTime:time];
};

@end






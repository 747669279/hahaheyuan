//
//  PlayerView.h
//  player
//
//  Created by Admin on 16/3/22.
//  Copyright © 2016年 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayerView : NSObject
-(NSMutableArray *)getLocalMusic;//得到本地下载好的音乐
-(BOOL)setLocelMusic:(NSString*)name lyrics:(NSString*)lyr;//保存本地下载好的音乐
-(BOOL)deleteMusic:(NSString*)name;//根据歌名撤除指定的音乐
@end

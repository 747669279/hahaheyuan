//
//  PlayerView.m
//  player
//
//  Created by Admin on 16/3/22.
//  Copyright © 2016年 Admin. All rights reserved.
//

#import "PlayerView.h"

@interface PlayerView(){
    NSMutableArray *LocalMusic;
    NSUserDefaults *userDefaultes;//本地歌曲
}

@end

@implementation PlayerView

-(id)init{
    if (self=[super init]) {
        userDefaultes=[[NSUserDefaults alloc]init];
    }
    return self;
}
-(BOOL)deleteMusic:(NSString*)name{
    NSArray *mp3 = [userDefaultes arrayForKey:@"Mp3"];
    NSMutableArray *NowMp3=[NSMutableArray array];
    for (int i=0;i<mp3.count;i++) {
        if ([mp3[i] isEqualToString:name]) {
            i++;
        }else{
            [NowMp3 addObject:mp3[i]];
        }
    }
    [userDefaultes setObject:NowMp3 forKey:@"Mp3"];
    [userDefaultes synchronize];
    return YES;
}
-(NSMutableArray *)getLocalMusic{
    NSArray *mp3 = [userDefaultes arrayForKey:@"Mp3"];
    NSMutableArray *NsmMp3=[mp3 mutableCopy];
    return NsmMp3;
}
-(BOOL)setLocelMusic:(NSString*)name lyrics:(NSString*)lyr{
     NSArray *mp31 = [userDefaultes arrayForKey:@"Mp3"];
    for (NSString *name1 in mp31) {
        if ([name1 isEqualToString:name]) {
            return NO;
        }
    }
    NSMutableArray *myMutableArray =[NSMutableArray array];
    NSArray *mp3 = [userDefaultes arrayForKey:@"Mp3"];
    NSMutableArray *NsmMp3=[mp3 mutableCopy];
    if (mp3==nil) {
        [myMutableArray addObject:@"Mp3Name"];
    }
    else{
        myMutableArray= NsmMp3;
    }
    [myMutableArray addObject:name];
    [myMutableArray addObject:lyr];
    [userDefaultes setObject:myMutableArray forKey:@"Mp3"];
    [userDefaultes synchronize];
    return YES;
}
@end










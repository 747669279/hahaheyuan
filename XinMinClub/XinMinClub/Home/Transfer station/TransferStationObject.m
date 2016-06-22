//
//  TransferStationObject.m
//  XinMinClub
//
//  Created by 杨科军 on 16/4/26.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "TransferStationObject.h"
#import "PalyerViewController.h"
#import "theIncomingDataModel.h"
#import "ReaderTableViewController.h"
#import "HomeViewController.h"

@interface TransferStationObject(){
    NSMutableArray *mp3Version; // MP3的数据数组
    NSMutableArray *eBookVersion; // 电子书的数据数组
    NSMutableArray <theIncomingDataModel*> *allDataArray; // 所有数据数组
}

@property (nonatomic, strong) NSString *libraryName;   // 书集名字
@property (nonatomic, strong) NSString *kj_imageUrl;   // 头像url
@property (nonatomic, strong) NSArray *kj_autorName;  // 作者名字
@property (nonatomic, assign) NSInteger clickCellNum;  // 点击的是那个cell
@property (nonatomic, strong) NSArray *sectionName;   // 章节名字
@property (nonatomic, strong) NSArray *sectionMp3;    // 章节Mp3
@property (nonatomic, strong) NSArray *sectionID;     // 章节ID
@property (nonatomic, strong) NSArray *sectionText;   // 章节内容


@end

@implementation TransferStationObject

+(instancetype)shareObject{
    static TransferStationObject *model = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        model = [[super allocWithZone:NULL] init];
    });
    return model;
}

#pragma mark Block回调函数
// 回调函数实现
-(void)IncomingDataLibraryName:(NSString *)libraryName ImageUrl:(NSString*)imageUrl AuthorName:(NSArray*)name ClickCellNum:(NSInteger)clickCellNum SectionName:(NSArray *)sectionName SectionMp3:(NSArray *)sectionMp3 SectionID:(NSArray *)sectionID SectionText:(NSArray *)sectionText block:(void (^)(BOOL))Block{
    
    if (!clickCellNum) {
        return;
    }
    
    self.libraryName = libraryName;
    self.clickCellNum = clickCellNum;
    self.sectionName = sectionName;
    self.sectionMp3 = sectionMp3;
    self.sectionID = sectionID;
    self.sectionText = sectionText;
    self.kj_imageUrl=imageUrl;
    self.kj_autorName=name;
    
    allDataArray=[NSMutableArray array];
    [self returnAllArray];
    mp3Version = [NSMutableArray array];
    eBookVersion = [NSMutableArray array];
    
    
    //获取一部分字符串，从开始取到指定的结束，不包含指定的字符
    NSString *s13 = @"http://218.240.52.135";
    NSInteger c=foo1m([s13 cStringUsingEncoding:NSUTF8StringEncoding]);

    // objectEnumerator 返回一个枚举器对象允许您访问数组中的每个对象。
    NSEnumerator *enumerator = [self.sectionMp3 objectEnumerator];
    NSNumber *num;
    NSInteger k = 0;
    while (num = [enumerator nextObject] ) {  //nextObject下一个对象
        NSString *abc = [(NSString*)num substringFromIndex:c];
        if ([num isEqual:@""]||[abc isEqualToString:@""]) {
            [eBookVersion addObject:@(k)];
        }else
            [mp3Version addObject:@(k)];
        k++;
    }
    
//    NSString *kkk=[self.sectionMp3[clickCellNum-1] substringFromIndex:c];//取出第c个以前的字符串
    // 判断是电子书版本还是音频版本
    if ([[self.sectionMp3[clickCellNum-1] substringFromIndex:c] isEqual:@""]) {
        Block([self EBookDatas]);
        [[PalyerViewController shareObject] MusicURL:allDataArray WhetherTheAudio:eBookVersion];
    }else{
        Block([self PlayerData]);
        [[ReaderTableViewController shareObject] setSectionArray:allDataArray WhetherTheAudio:mp3Version];
    }
}

- (void)returnAllArray{
    for (int i=0; i<self.sectionID.count; i++) {
        theIncomingDataModel *model=[[theIncomingDataModel alloc]init];
        model.chapterUrl = _sectionMp3[i];
        model.chapterName = _sectionName[i];
        model.bookName = _libraryName;
        model.chapterID = _sectionID[i];
        model.ClackTag = _clickCellNum-1;
        model.chapterLrc = _sectionText[i];
        model.kj_imageUrl=_kj_imageUrl;
        model.kj_autorName=_kj_autorName[i];
        [allDataArray addObject:model];
    }
}
- (BOOL)PlayerData{
    [[PalyerViewController shareObject] PalyerMusicURL:allDataArray WhetherTheAudio:eBookVersion];
    return YES;
}

- (BOOL)EBookDatas{
    [[ReaderTableViewController shareObject] setSectionArray:allDataArray WhetherTheAudio:mp3Version];
    return NO;
}

// 判断字符串长度
int foo1m(const char *p){
    if (*p == '\0')    //指针偏移，偏移到\0的时候结束
        return 0;   //如果取出来的值是\0的话就直接返回一个0
    else    //否则就返回下面的foo1
        return foo1m(p + 1) + 1;//递归一直掉用函数foo1，直到最后一位\0，开始return 0；
    //  p+1先偏移到下一个位置，然后长度加1,得到字符串长度
}

@end

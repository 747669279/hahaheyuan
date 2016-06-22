//
//  DataModel.m
//  XinMinClub
//
//  Created by 赵劲松 on 16/3/31.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "DataModel.h"
#import "UIImageView+WebCache.h"
#import "DownloadModule.h"
#import "SaveModule.h"

@interface DataModel() {
    DownloadModule *download;
    SaveModule *saveModule;
    NSString *filePath;
    NSFileManager *fileManager;
}

@end

@implementation DataModel

+ (instancetype)defaultDataModel {
    
    static DataModel *dataModel;
    if (!dataModel) {
        dataModel = [[super allocWithZone:NULL] init];
        [dataModel initData];
    }
    
    return dataModel;
}

- (void)initData {
    
    download = [[DownloadModule alloc] init];
    saveModule = [SaveModule defaultObject];
    fileManager = [NSFileManager defaultManager];
    
    _addBook = NO;
    _playTimeOn = NO;
    
    _allSection = [NSMutableArray array];
    _allSectionAndID = [NSMutableDictionary dictionaryWithCapacity:10];
    
    _myBook = [NSMutableArray array];
    _myBookAndID = [NSMutableDictionary dictionaryWithCapacity:10];
    
    _allBook = [NSMutableArray array];
    _allBookAndID = [NSMutableDictionary dictionaryWithCapacity:10];
    
    _deleteSection = [NSMutableArray array];
    
    _downloadingSections = [NSMutableArray array];
    _downloadSection = [NSMutableArray array];
    
    _recentPlay = [NSMutableArray array];
    _recentPlayIDAndCount = [NSMutableDictionary dictionaryWithCapacity:10];
    _recentPlayIDAndCount = [UserDataModel defaultDataModel].userRecentPlayIDAndCount;
    
    _userLikeBook = [NSMutableArray array];
    _recommandBook = [NSMutableArray array];
    _recommandBookID = [NSMutableArray array];
    
    _userLikeSection = [NSMutableArray array];
    _userLikeSectionID = [UserDataModel defaultDataModel].userLikeSectionID;
    
//    _playTime = 60;
//    if ([UserDataModel defaultDataModel].playTime) {
//        _playTime = [[UserDataModel defaultDataModel].playTime intValue];
//    }
    
    [UserDataModel defaultDataModel].userLikeSection = _userLikeSection;
    
    for (NSInteger i = 0; i < 7; i++) {
        for (NSInteger j = 0; j < 1; j++) {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSString stringWithFormat:@"第%@章",[NSNumber numberWithInteger:i]] , @"sectionName",
                                 [NSString stringWithFormat:@"第%@个作者",[NSNumber numberWithInteger:i]] , @"author",
                                 [NSString stringWithFormat:@"第%@号文集",[NSNumber numberWithInteger:i]] , @"bookName",
                                 [NSNumber numberWithInteger:0], @"playCount",
                                 [NSNumber numberWithInteger:i + j / 10], @"sectionID",
                                 nil];
            SectionData *sec = [[SectionData alloc] initWithDic:dic];
            [_allSection addObject:sec];
            [_allSectionAndID setObject:sec forKey:[NSString stringWithFormat:@"%@",sec.sectionID]];
        }
    }
    
    // 判断是否喜欢
    for (NSInteger i = 0; i < [UserDataModel defaultDataModel].userLikeSectionID.count; i++) {
        NSString *s = [NSString stringWithFormat:@"%@",[UserDataModel defaultDataModel].userLikeSectionID[i]];
        if ([[_allSectionAndID allKeys] containsObject:s]) {
            ((SectionData*)[_allSectionAndID objectForKey:s]).isLike = YES;
            [_userLikeSection addObject:[_allSectionAndID objectForKey:s]];
        }
    }
    // 判断最近播放
    NSArray *recentPlayID = [[UserDataModel defaultDataModel].userRecentPlayIDAndCount allKeys];
    for (NSString *s in recentPlayID) {
        if ([[_allSectionAndID allKeys] containsObject:[NSString stringWithFormat:@"%@", s]]) {
            SectionData *sd = nil;
            sd = [_allSectionAndID objectForKey:[NSString stringWithFormat:@"%@", s]];
            sd.isAddRecent = YES;
            sd.playCount = [[UserDataModel defaultDataModel].userRecentPlayIDAndCount objectForKey:s];
            [_recentPlay addObject:sd];
        }
    }
    
    _downloadSection = _allSection;
    [self getAllLocalBook];
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self defaultDataModel];
}

- (NSArray *)getBookSecondLevelWithFirstLevel:(NSString *)firtLevelString andBookID:(NSString *)bookID{
    
    filePath = [NSString stringWithFormat:@"%@/Documents/bookFile/%@.plist", NSHomeDirectory(), bookID];
    if (![self createBookFile:filePath]) {
        return nil;
    }
    NSMutableDictionary *listDic;
    if (![[[NSMutableDictionary alloc]initWithContentsOfFile:filePath] objectForKey:@"list"]) {
        return nil;
    }
    else {
        listDic = [[[NSMutableDictionary alloc]initWithContentsOfFile:filePath] objectForKey:@"list"];
    }
    if (((NSArray *)[listDic objectForKey:firtLevelString]).count) {
        return nil;
    }
    return [listDic objectForKey:firtLevelString];
}

- (BOOL)createBookFile:(NSString *)path {
    if(![fileManager fileExistsAtPath:path]) {
        [fileManager createFileAtPath:path contents:nil attributes:nil];
        //设置属性值,没有的数据就新建，已有的数据就修改。
        NSMutableDictionary *usersDic = [NSMutableDictionary dictionaryWithCapacity:10];
        //        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"",nil];
        [usersDic setObject:[NSMutableDictionary dictionary] forKey:@"list"];
        [usersDic writeToFile:filePath atomically:YES];
        return YES;
    }
    return NO;
}

- (void)getAllLocalBook {
    
    filePath = [NSString stringWithFormat:@"%@/Documents/bookFile", NSHomeDirectory()];
    NSMutableArray *arr = (NSMutableArray *)[[NSFileManager defaultManager] contentsOfDirectoryAtPath:filePath error:nil];
//    if (arr.count) [arr removeObjectAtIndex:0];
 
    for (NSString *s in arr) {
        filePath = [NSString stringWithFormat:@"%@/Documents/bookFile/%@", NSHomeDirectory(), s];
        
        NSMutableDictionary *usersDic;
        usersDic = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        
        NSMutableDictionary *listDic;
        listDic = [[[NSMutableDictionary alloc]initWithContentsOfFile:filePath] objectForKey:@"list"];
        
        NSMutableDictionary *bookDic;
        bookDic = [[[NSMutableDictionary alloc]initWithContentsOfFile:filePath] objectForKey:@"book"];
        
        NSArray *sArr = [s componentsSeparatedByString:@"."];
        
        if ([sArr[0] isEqualToString:@""]) {
            continue;
        }
        
        NSMutableDictionary *secondLevelList = [NSMutableDictionary dictionaryWithCapacity:10];
        for ( NSString *s in listDic[sArr[0]]) {
            NSArray *secondListDic = listDic[s];
            if (!secondListDic) {
                break;
            }
            [secondLevelList  setObject:secondListDic forKey:s];
        };
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             bookDic[@"bookName"],@"bookName",
                             bookDic[@"authorName"],@"authorName",
                             bookDic[@"imagePath"],@"imagePath",
                             listDic[sArr[0]],@"firstLevelList",
                             secondLevelList,@"firstLevelListWithSecondLevelList",
                             nil];
        BookData *bookData = [[BookData alloc] initWithDic:dic];
        [_allBook addObject:bookData];
        [_allBookAndID setObject:bookData forKey:[NSString stringWithFormat:@"%d",_allBookAndID.count / 2]];
        [_allBookAndID setObject:[NSNull null] forKey:sArr[0]];
    }
    DataModel *d = [DataModel defaultDataModel];
}

// 添加到我的文集
- (BOOL)addMyLibrary:(NSString *)libraryID ImageUrl:(NSString *)url BookName:(NSString *)bookName AuthorName:(NSString *)authorName {
    
    if ([[_myBookAndID allKeys] containsObject:libraryID]) {
        return NO;
    }
    
    NSLog(@"%@%@%@",url,authorName,libraryID);
    UIImageView *imageView = [[UIImageView alloc] init];
    NSURL *urlString = [NSURL URLWithString:url];
    
    [imageView sd_setImageWithURL:urlString completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (![[_myBookAndID allKeys] containsObject:libraryID]) {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 libraryID,@"bookID",
                                 image, @"bookImage",
                                 url, @"imagePath",
                                 authorName, @"authorName",
                                 bookName, @"bookName",
                                 nil];
            BookData *data = [[BookData alloc] initWithDic:dic];
            [_myBook addObject:data];
            [_myBookAndID setObject:[NSNull null] forKey:data.bookID];
            [_myBookAndID setObject:data forKey:[NSString stringWithFormat:@"%d",_myBookAndID.count / 2]];
            _addBook = YES;
            NSLog(@"____%@+++++",_myBookAndID);
        }
        
    }];
    return YES;
}

// 添加到全部文集
- (BOOL)addAllLibrary:(NSString *)libraryID ImageUrl:(NSString *)url BookName:(NSString *)bookName AuthorName:(NSString *)authorName {
    
    if ([[_allBookAndID allKeys] containsObject:libraryID]) {
        return NO;
    }
    
    [saveModule saveBookDataWithBookID:libraryID bookData:[[BookData alloc] initWithDic:[NSDictionary dictionaryWithObjectsAndKeys:bookName,@"bookName",authorName,@"authorName",url,@"imagePath",                                   nil]]];
    
    NSLog(@"%@%@%@",url,authorName,libraryID);
    UIImageView *imageView = [[UIImageView alloc] init];
    NSURL *urlString = [NSURL URLWithString:url];
    
    [imageView sd_setImageWithURL:urlString completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (![[_allBookAndID allKeys] containsObject:libraryID]) {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 libraryID,@"bookID",
                                 image, @"bookImage",
                                 bookName, @"bookName",
                                 url, @"imagePath",
                                 authorName, @"authorName",
                                 nil];
            BookData *data = [[BookData alloc] initWithDic:dic];
            [_allBookAndID setObject:[NSNull null] forKey:data.bookID];
            [_allBookAndID setObject:data forKey:[NSString stringWithFormat:@"%d",_allBookAndID.count / 2]];
            _addAllBook = YES;
            NSLog(@"____%@+++++",_allBookAndID);
        }
        
    }];
    return YES;
}

@end

//
//  SaveModule.m
//  XinMinClub
//
//  Created by 赵劲松 on 16/5/10.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "SaveModule.h"

@interface SaveModule() {
    NSFileManager *fileManager;
    NSString *filePath;
}

@end

@implementation SaveModule

+ (instancetype)defaultObject {
    static SaveModule *saveModule;
    if (!saveModule) {
        saveModule = [[super allocWithZone:nil] init];
        [saveModule initData];
    }
    return saveModule;
}

- (void)initData {
    fileManager = [NSFileManager defaultManager];
    [self createBookDirectory];
}

- (void)createBookDirectory {
    //  如果不存在就创建文件夹
    filePath = [NSString stringWithFormat:@"%@/Library/Caches/%@", NSHomeDirectory(), @"bookFile"];
    BOOL isDir = NO;
    BOOL existed = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
    if (!(isDir == YES && existed == YES))
    {
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
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

- (void)saveBookDataWithBookID:(NSString *)bookID bookData:(BookData *)book {
    filePath = [NSString stringWithFormat:@"%@/Library/Caches/bookFile/%@.plist", NSHomeDirectory(), bookID];
    [self createBookFile:filePath];
    
    NSMutableDictionary *usersDic;
    if (![[NSMutableDictionary alloc]initWithContentsOfFile:filePath].count) {
        usersDic = [[NSMutableDictionary alloc]init ];
    }
    else {
        usersDic = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    }
    
    NSMutableDictionary *bookDic;
    if (![[[NSMutableDictionary alloc]initWithContentsOfFile:filePath] objectForKey:@"book"]) {
        bookDic = [[NSMutableDictionary alloc] initWithCapacity:10];
    }
    else {
        bookDic = [[[NSMutableDictionary alloc]initWithContentsOfFile:filePath] objectForKey:@"book"];
    }
    
    NSArray *arr = @[@"bookName",@"authorName",@"imagePath"];
    //设置属性值,没有的数据就新建，已有的数据就修改。
    [bookDic setObject:book.bookName forKey:arr[0]];
    [bookDic setObject:book.authorName forKey:arr[1]];
    [bookDic setObject:book.imagePath forKey:arr[2]];
    //写入文件
    [usersDic setObject:bookDic forKey:@"book"];
    [usersDic writeToFile:filePath atomically:YES];
}

// 设置一级目录
- (void)saveSectionListWithBookID:(NSString *)bookID firstLevel:(NSArray *)firstLevel {
    
    NSLog(@"%@",filePath);
    filePath = [NSString stringWithFormat:@"%@/Library/Caches/bookFile/%@.plist", NSHomeDirectory(), bookID];
    [self setSectionListWithBookID:bookID firstLevel:firstLevel secondLevel:nil];
}

- (void)setSectionListWithBookID:(NSString *)bookID firstLevel:(NSArray *)firstLevel secondLevel:(NSArray *)secondLevel {
    
    filePath = [NSString stringWithFormat:@"%@/Library/Caches/bookFile/%@.plist", NSHomeDirectory(), bookID];
    NSLog(@"%@",filePath);
    if (![self createBookFile:filePath]) {
//        return;
    }
    
    NSLog(@"%@",filePath);
    
    NSMutableDictionary *usersDic;
    if (![[NSMutableDictionary alloc]initWithContentsOfFile:filePath].count) {
        usersDic = [[NSMutableDictionary alloc]init ];
    }
    else {
        usersDic = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    }
    
    NSMutableDictionary *listDic;
    if (![[[NSMutableDictionary alloc]initWithContentsOfFile:filePath] objectForKey:@"list"]) {
        listDic = [[NSMutableDictionary alloc] initWithCapacity:10];
    }
    else {
        listDic = [[[NSMutableDictionary alloc]initWithContentsOfFile:filePath] objectForKey:@"list"];
    }
    
    // 如果二级列表为空
    if (!secondLevel) {
        //设置属性值,没有的数据就新建，已有的数据就修改。
        [listDic setObject:firstLevel forKey:bookID];
        // 设置属性值，是否有二级目录
        [listDic setObject:@(NO) forKey:@"secondLevel"];
        //写入文件
        [usersDic setObject:listDic forKey:@"list"];
        [usersDic writeToFile:filePath atomically:YES];
        return;
    }
    
    //设置属性值,没有的数据就新建，已有的数据就修改。
//    [listDic setObject:firstLevel forKey:bookID];
    [listDic setObject:secondLevel forKey:firstLevel[0]];
    // 设置属性值，是否有二级目录
    [listDic setObject:@(YES) forKey:@"secondLevel"];
    //写入文件
    [usersDic setObject:listDic forKey:@"list"];
    [usersDic writeToFile:filePath atomically:YES];
}

@end

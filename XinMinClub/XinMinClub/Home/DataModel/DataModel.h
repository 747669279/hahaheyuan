//
//  DataModel.h
//  XinMinClub
//
//  Created by 赵劲松 on 16/3/31.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SectionData.h"
#import "BookData.h"
#import "SectionOperation.h"

// navigation及其他相关控件颜色
#define DEFAULT_COLOR [UIColor colorWithRed:0.594 green:0.205 blue:0.170 alpha:1.000]
// picker的颜色
#define DEFAULT_LISTCOLOR [UIColor colorWithWhite:0.976 alpha:1.000]
// 背景色
#define DEFAULT_BACKGROUNDCOLOR [UIColor colorWithWhite:0.953 alpha:1.000]
// 二级字体颜色
#define DEFAULT_TINTCOLOR [UIColor colorWithWhite:0.418 alpha:1.000]
#define LINE_WIDTH (SCREEN_WIDTH / 2 - 10)
// 选择语言
typedef NS_ENUM(NSInteger, SelectedDefaultLanguage) {
    ChineseFamiliar = 0,
    ChineseTraditional = 1,
    EnglishLanguage = 2
};

@interface DataModel : NSObject

// 默认语言
@property (nonatomic, assign) SelectedDefaultLanguage setDefaultLanguage;

// 所有章节
@property (nonatomic, strong) NSMutableArray <SectionData *> *allSection;
// 所有章节ID
@property (nonatomic, strong) NSMutableArray *allSectionID;
// 所有章节及对应ID
@property (nonatomic, strong) NSMutableDictionary *allSectionAndID;

// 所有文集
@property (nonatomic, strong) NSMutableArray <BookData *> *allBook;
// 所有文集及其ID
@property (nonatomic, strong) NSMutableDictionary *allBookAndID;
// 是否添加了所有文集
@property (nonatomic, assign) BOOL addAllBook;

// 我的文集
@property (nonatomic, strong) NSMutableArray <BookData *> *myBook;
// 我的文集及其ID
@property (nonatomic, strong) NSMutableDictionary *myBookAndID;
// 是否添加了我的文集
@property (nonatomic, assign) BOOL addBook;

// 收藏章节
@property (nonatomic, strong) NSMutableArray <SectionData *> *userLikeSection;
// 收藏章节ID
@property (nonatomic, strong) NSMutableArray *userLikeSectionID;

// 收藏文集
@property (nonatomic, strong) NSMutableArray <BookData *> *userLikeBook;
// 收藏文集ID
@property (nonatomic, strong) NSMutableArray *userLikeBookID;

// 推荐文集
@property (nonatomic, strong) NSMutableArray <BookData *> *recommandBook;
@property (nonatomic, strong) NSMutableArray *recommandBookID;

// 删除章节
@property (nonatomic, strong) NSMutableArray <SectionData *> * deleteSection;

// 最近播放章节
@property (nonatomic, strong) NSMutableArray <SectionData *> * recentPlay;
// 最近播放章节数目
@property (nonatomic, assign) NSInteger playAmount;
// 最近播放章节ID及其播放次数
@property (nonatomic, strong) NSMutableDictionary *recentPlayIDAndCount;

// 正在下载章节列表
@property (nonatomic, strong) NSMutableArray <SectionData *> *downloadingSections;
// 正在下载章节
@property (nonatomic, strong) SectionData *downloadingSection;
// 下载完成章节
@property (nonatomic, strong) NSMutableArray <SectionData *> *downloadSection;
// 下载完成章节列表
@property (nonatomic, strong) NSMutableArray *downloadSectionList;
// 下载章节ID
@property (nonatomic, strong) NSMutableArray *downloadSectionID;
// 是否正在下载
@property (nonatomic, assign) BOOL isDownloading;

// 正在播放章节
@property (nonatomic, strong) SectionData *playingSection;

// 播放定时
@property (nonatomic, assign) NSInteger playTime;
// 播放定时开关
@property (nonatomic, assign) BOOL playTimeOn;
// 活动的播放器
@property (nonatomic, assign) NSInteger activityPlayer;

+ (instancetype)defaultDataModel;

// 加入我的文集
- (BOOL)addMyLibrary:(NSString *)libraryID ImageUrl:(NSString *)url BookName:(NSString *)bookName AuthorName:(NSString *)authorName Type:(NSString *)type Language:(NSString *)language Detail:(NSString *)details;
// 加入全部文集
- (BOOL)addAllLibrary:(NSString *)libraryID ImageUrl:(NSString *)url BookName:(NSString *)bookName AuthorName:(NSString *)authorName Type:(NSString *)type Language:(NSString *)language Detail:(NSString *)details;
// 取得本地文集
- (void)getAllLocalBook;
// 取得最近播放章节
- (void)getAllRecentPlaySection;
// 取得所有章节
- (void)getAllLocalSection;

// 取得二级章节
- (NSArray *)getBookSecondLevelWithFirstLevel:(NSString *)firtLevelString andBookID:(NSString *)bookID;


@end

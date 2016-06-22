//
//  SongModel.h
//  KJ5sing2
//
//  Created by yangkejun on 16/3/12.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LibraryModelDelegata;

@interface BookModel : NSObject

// 单例
+ (instancetype)shareObject;

@property(nonatomic, assign) id<LibraryModelDelegata> libraryModelDelegate;

// 开始获取分类列表
- (void)startGetList:(NSString *)userID;

// 开始获取文库数据下面collectionView图片请求
- (void)startGetLibraryModelDataUserID:(NSString *)userID Type:(NSString *)type PageIndex:(NSInteger)pageIndex;

- (void)kj_startGetLibraryModelDataUserID:(NSString *)userID Type:(NSString *)type PageIndex:(NSInteger)pageIndex;

@end

@protocol LibraryModelDelegata <NSObject>

- (void)getLibrartList:(NSArray*)listDatas;
- (void)getLibraryModelDataComplete:(NSArray *)libraryDatas ReturnType:(NSString *)typee;
- (void)getLibraryModelDataComplete:(NSArray *)libraryDatas LibraryCount:(NSInteger)libCount;

@end

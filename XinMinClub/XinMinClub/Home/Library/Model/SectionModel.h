//
//  ClickModel.h
//  XinMinClub
//
//  Created by yangkejun on 16/3/30.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ClickModelDelegate;
@protocol ListModelDelegate;
@protocol ReadListModelDelegate;

@interface SectionModel : NSObject

// 单例
+ (instancetype)shareObject;
@property(nonatomic,assign) id<ClickModelDelegate> clickDelegate;
@property(nonatomic,assign) id<ListModelDelegate> listDelegate;
@property(nonatomic,assign) id<ReadListModelDelegate> readListDelegate;

// 获取章节分类
- (void)startSectionType:(NSString *)bookID;

// 获取章节列表
- (void)startSectionList:(NSString *)sectionTypeID IsSectionList:(BOOL)list;

@end

@protocol ClickModelDelegate <NSObject>

- (void)getSectionType:(NSArray *)type;

@end

@protocol ListModelDelegate <NSObject>

- (void)getSectionList:(NSArray *)list;

@end

@protocol ReadListModelDelegate <NSObject>

- (void)getSectionReadList:(NSArray *)list;

@end
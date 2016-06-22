//
//  SaveModule.h
//  XinMinClub
//
//  Created by 赵劲松 on 16/5/10.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookData.h"

@interface SaveModule : NSObject

// 按文集分级结构保存章节列表
- (void)saveSectionListWithBookID:(NSString *)bookID firstLevel:(NSArray *)firstLevel;

// 修改分级列表,需要修改的firstLevel传入形式如：@[@"19482432"],并传入相应的二级目录列表.不能为空
- (void)setSectionListWithBookID:(NSString *)bookID firstLevel:(NSArray *)firstLevel secondLevel:(NSArray *)secondLevel;

// 存储书籍信息
- (void)saveBookDataWithBookID:(NSString *)bookID bookData:(BookData *)book;

// 创建文件
- (BOOL)createBookFile:(NSString *)path;

+ (instancetype)defaultObject;

@end

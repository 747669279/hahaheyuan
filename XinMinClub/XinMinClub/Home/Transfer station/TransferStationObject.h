//
//  TransferStationObject.h
//  XinMinClub
//
//  Created by 杨科军 on 16/4/26.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransferStationObject : UIViewController

// 单例
+ (instancetype)shareObject;

// 回调函数声明
-(void)IncomingDataLibraryName:(NSString*)libraryName ImageUrl:(NSString*)imageUrl AuthorName:(NSArray*)name ClickCellNum:(NSInteger)clickCellNum SectionName:(NSArray*)sectionName SectionMp3:(NSArray*)sectionMp3 SectionID:(NSArray*)sectionID SectionText:(NSArray*)sectionText block:(void(^)(BOOL successful))Block;

@end

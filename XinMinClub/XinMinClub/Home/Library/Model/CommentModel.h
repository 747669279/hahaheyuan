//
//  CommentModel.h
//  XinMinClub
//
//  Created by 杨科军 on 16/4/20.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CommentModelDelegate <NSObject>

- (void)getComment:(NSArray *)comment;
- (void)updateUserAppraiseIsSucceed:(NSString *)kkkk;

@end

@interface CommentModel : NSObject

+ (instancetype)shareObject;
@property(nonatomic,assign) id<CommentModelDelegate> commentDelegate;

- (void)startGetComment:(NSString *)libraryID;
- (void)updateUserAppraise:(NSString *)libraryID LibraryContent:(NSString *)libraryContent;

@end

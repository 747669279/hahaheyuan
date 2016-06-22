//
//  theIncomingDataModel.h
//  XinMinClub
//
//  Created by 贺军 on 16/4/26.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface theIncomingDataModel : NSObject

@property(nonatomic)NSInteger ClackTag; // 点击的cell
@property(nonatomic,strong)NSString *bookName;
@property(nonatomic,strong)NSString *chapterID;
@property(nonatomic,strong)NSString *chapterName;
@property(nonatomic,strong)NSString *chapterUrl;
@property(nonatomic,strong)NSString *chapterLrc;
@property (nonatomic, strong) NSString *kj_imageUrl;
@property (nonatomic, strong) NSString *kj_autorName;

@end

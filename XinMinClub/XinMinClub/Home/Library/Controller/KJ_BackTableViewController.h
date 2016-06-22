//
//  KJ_BackTableViewController.h
//  XinMinClub
//
//  Created by 杨科军 on 16/5/8.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface KJ_BackTableViewController : UIViewController

// 作者的名字
@property(nonatomic,copy) NSString *libraryAuthorName;
// 文集简介
@property (nonatomic, strong) NSString *libraryDetails;
// 文集封面
@property(nonatomic,copy) NSString *libraryImageUrl;
// 区分不同文集的编号
@property(nonatomic,copy) NSString *libraryNum;
// 文集的标题
@property(nonatomic,copy) NSString *libraryTitle;
// 文集分类
@property (nonatomic, strong) NSString *libraryType;
// 文集时间
@property (nonatomic, strong) NSString *libraryTime;
// 文集语言
@property (nonatomic, strong) NSString *libraryLanguage;
// 作者的头像
@property(nonatomic,copy) NSString *libraryAuthorImageUrl;

@end

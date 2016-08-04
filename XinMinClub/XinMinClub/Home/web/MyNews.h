//
//  MyNews.h
//  qweqwe
//
//  Created by 贺军 on 16/7/26.
//  Copyright © 2016年 贺军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsMode.h"
@interface MyNews : UIViewController
@property(nonatomic,strong)NSString *TheTitle;
@property(nonatomic,strong)NSString *URL;
@property(nonatomic,strong)NSMutableArray<NewsMode*> *recommended;
@end

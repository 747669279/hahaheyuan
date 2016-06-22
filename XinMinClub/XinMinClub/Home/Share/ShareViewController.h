//
//  Share.h
//  player
//
//  Created by 贺军 on 16/3/30.
//  Copyright © 2016年 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "UMSocialSnsData.h"

@interface ShareViewController : UIViewController

@property(nonatomic,strong)NSString *Content; //分享文字内容
@property(nonatomic,strong)UIImage *Image; //分享图片
@property(nonatomic,strong)CLLocation *Location; //分享地理位置
@property(nonatomic)UMSocialUrlResource *UrlResource; // 网址

@end

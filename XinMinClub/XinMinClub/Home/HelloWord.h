//
//  HelloWord.h
//  XinMinClub
//
//  Created by 贺军 on 16/4/13.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelloWord : UIViewController

@property(nonatomic,strong)UIImage *advertisementImage;
@property(nonatomic)BOOL ThereAreNoPassword;
-(void)setAccount:(NSString*)account Password:(NSString*)password;
-(void)getAccount;
-(BOOL)deleteAccount;
@end

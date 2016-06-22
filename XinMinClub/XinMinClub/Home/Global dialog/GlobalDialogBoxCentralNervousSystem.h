//
//  GlobalDialogBoxCentralNervousSystem.h
//  XinMinClub
//
//  Created by 贺军 on 16/4/26.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GlobalDialogBoxCentralNervousSystemDelegate <NSObject>

@optional
- (void)pushAlertView:(NSInteger)judge;

@end

@interface GlobalDialogBoxCentralNervousSystem : UIViewController

+ (instancetype)shareObject;
//@property (nonatomic, assign) id <GlobalDialogBoxCentralNervousSystemDelegate> windowDelegate;
@property (nonatomic, assign) id <GlobalDialogBoxCentralNervousSystemDelegate> homeDelegate;

@end


//
//  DetailsTable.h
//  XinMinClub
//
//  Created by 杨科军 on 16/5/6.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsTableViewController : UIViewController

@property(nonatomic)BOOL kj_hasBeenTo;//到了顶部
@property(nonatomic)BOOL kj_whenTheTop;//自己时候到了顶部

@property (nonatomic, strong) NSString *libraryID;
@property (nonatomic, copy) NSArray *detailsTextArray;

// 取消第一响应的属性
@property(nonatomic, copy) UITextField *detailsTextField;

@end

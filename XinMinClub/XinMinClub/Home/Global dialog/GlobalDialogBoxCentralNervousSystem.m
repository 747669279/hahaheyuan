//
//  GlobalDialogBoxCentralNervousSystem.m
//  XinMinClub
//
//  Created by 贺军 on 16/4/26.
//  Copyright © 2016年 yangkejun. All rights reserved.

#import "GlobalDialogBoxCentralNervousSystem.h"
#import "ReaderTableViewController.h"
@implementation GlobalDialogBoxCentralNervousSystem

+(instancetype)shareObject{
    static GlobalDialogBoxCentralNervousSystem *model = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        model = [[super allocWithZone:NULL] init];
    });
    return model;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(foundThatSectionChange:) name:@"ChaptersState" object:nil];
}
-(IBAction)foundThatSectionChange:(NSNotification*)sender{
    //发现章节变化
    NSString *ChangeState=[sender.userInfo valueForKey:@"ChangeState"];
    int mp3Tag=[[sender.userInfo valueForKey:@"ChangeName"] intValue];
    NSString *ChangeName=[sender.userInfo valueForKey:@"ChangeName"];
    NSLog(@"------------%@------------%@",ChangeState,ChangeName);
    if ([ChangeState isEqualToString:@"silent"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_homeDelegate pushAlertView:1];
            [ReaderTableViewController shareObject].readTag=mp3Tag;
        });
    }
    if ([ChangeState isEqualToString:@"complete"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_homeDelegate pushAlertView:2];
         });
    }
}

@end

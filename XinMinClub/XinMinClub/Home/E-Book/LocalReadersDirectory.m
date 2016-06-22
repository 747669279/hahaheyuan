//
//  LocalReadersDirectory.m
//  XinMinClub
//
//  Created by 贺军 on 16/4/9.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "LocalReadersDirectory.h"

@interface LocalReadersDirectory (){
    NSArray *MyTitle;
}

@end

@implementation LocalReadersDirectory
//+(instancetype)shareObject{
//    static LocalReadersDirectory *model = nil;
//    static dispatch_once_t predicate;
//    dispatch_once(&predicate, ^{
//        model = [[super allocWithZone:NULL] init];
//    });
//    return model;
//}

- (void)viewDidLoad {
    [super viewDidLoad];

    MyTitle=[NSArray array];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}
-(void)setMyTitle:(NSArray *)myTitle{
    MyTitle=myTitle;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  MyTitle.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.backgroundColor = [UIColor colorWithWhite:0.603 alpha:0];
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.textLabel.text =MyTitle[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *infoDic = @{@"buttonTag":@(indexPath.row)};
    NSNotification * notice = [NSNotification notificationWithName:@"spread" object:nil userInfo:infoDic];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
}

@end









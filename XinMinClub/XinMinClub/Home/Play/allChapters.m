//
//  allChapters.m
//  XinMinClub
//
//  Created by 贺军 on 16/4/25.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "allChapters.h"

@interface allChapters (){
    NSMutableArray *Mp3Mame;
}

@end

@implementation allChapters

- (void)viewDidLoad {
    [super viewDidLoad];
    Mp3Mame=[NSMutableArray array];
    self.view.backgroundColor=[UIColor colorWithWhite:0.014 alpha:0.700];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return Mp3Mame.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.backgroundColor=[UIColor colorWithWhite:0.014 alpha:0.00];
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.textLabel.text=Mp3Mame[indexPath.row];
    return cell;
}
-(void)setSectionName:(NSMutableArray *)sectionName{
     Mp3Mame=sectionName;
    [self.tableView reloadData];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *ClackTag= @{@"buttonTag":@(indexPath.row)};
    //创建一个消息对象
    NSNotification * notice = [NSNotification notificationWithName:@"ClackTag" object:nil userInfo:ClackTag];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];

}


@end


















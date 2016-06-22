//
//  LyricsView.m
//  player
//
//  Created by Admin on 16/3/25.
//  Copyright © 2016年 Admin. All rights reserved.
//

#import "LyricsViewController.h"

@interface LyricsViewController(){
    NSMutableArray *myLyr;
    UITableViewCell *cell;
}

@end

@implementation LyricsViewController

+(instancetype)shareObject{
    static LyricsViewController *model = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        model = [[super allocWithZone:NULL] init];
    });
    return model;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    myLyr=[[NSMutableArray alloc]init];
    self.tableView.backgroundColor=[UIColor colorWithRed:0.961 green:1.000 blue:0.984 alpha:0.0];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)setLyr:(NSMutableArray *)Lyr{
    myLyr=Lyr;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _LyrTamin=0;
    [self.tableView reloadData];
    
}
-(void)setLyrTamin:(NSInteger)LyrTamin{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:LyrTamin  inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    _LyrTamin=LyrTamin;
    [self.tableView reloadData];
}
-(NSInteger)getLyrTamin{
    return self.LyrTamin;
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return myLyr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithWhite:0.603 alpha:0];
    cell.textLabel.textColor=[UIColor blackColor];
    UIFont *newFont = [UIFont fontWithName:@"AppleGothic" size:13.0];
    //创建完字体格式之后就告诉cell
    cell.textLabel.font = newFont;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
    cell.textLabel.numberOfLines = 0;
    if (indexPath.row == self.LyrTamin) {
       cell.textLabel.textColor=[UIColor redColor];
    }
    cell.textLabel.text=myLyr[indexPath.row];
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger c=(((foo1q([myLyr[indexPath.row] cStringUsingEncoding:NSUTF8StringEncoding])*6)/SCREEN_WIDTH)*44);
    return c+10;
}
// 判断字符串长度
int foo1q(const char *p){
    if (*p == '\0')
        return 0;
    else
        return foo1q(p + 1) + 1;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
@end

//
//  CLassTableViewController.m
//  XinMinClub
//
//  Created by 赵劲松 on 16/7/19.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "CLassTableViewController.h"
#import "SeeThinkCell.h"

@interface CLassTableViewController ()

@property(nonatomic,strong)UIImageView *headImageView;//头部图片
@property(nonatomic,strong)NSMutableArray *infoArray;//数据源数组

@end
//屏幕宽、高 宏定义
#define IPHONE_W ([UIScreen mainScreen].bounds.size.width)
#define IPHONE_H ([UIScreen mainScreen].bounds.size.height)

@implementation CLassTableViewController

static CGFloat kImageOriginHight =300;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    //将视图添加到界面上
//    [self.tableView.tableHeaderView addSubview:self.headImageView];
}

static NSString *seeCell = @"SeeCell";

- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
        UINib *nib = [UINib nibWithNibName:@"SeeThinkCell" bundle:nil];
        [self.tableView registerNib:nib forCellReuseIdentifier:seeCell];
    }
    return self;
}

#pragma mark -- 滚动视图的代理方法
- (void)scrollViewDidScroll:(UIScrollView*)scrollView{
    /**
     *  关键处理：通过滚动视图获取到滚动偏移量从而去改变图片的变化
     */
    //获取滚动视图y值的偏移量
    CGFloat yOffset  = scrollView.contentOffset.y;
    
    CGFloat xOffset = (yOffset +kImageOriginHight)/2;
    
    if(yOffset < -kImageOriginHight) {
        CGRect f =self.headImageView.frame;
        f.origin.y= yOffset ;
        f.size.height=  -yOffset;
        f.origin.x= xOffset;
        //int abs(int i); // 处理int类型的取绝对值
        //double fabs(double i); //处理double类型的取绝对值
        //float fabsf(float i); //处理float类型的取绝对值
        f.size.width=IPHONE_W + fabs(xOffset)*2;
        
        self.headImageView.frame= f;
    }
}
#pragma mark -- 表视图代理

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.headImageView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return IPHONE_W * 0.618;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    return 44;
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return self.infoArray.count;
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath{
    
    static NSString *identify =@"MyCellIndifer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.textLabel.text= [self.infoArray objectAtIndex:indexPath.row];

    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:seeCell forIndexPath:indexPath];
    }
    
    return cell;
}

#pragma mark -- get 初始化操作

-(NSMutableArray *)infoArray
{
    if (_infoArray == nil)
    {
        _infoArray = [[NSMutableArray alloc]init];
        for (int i=0; i<40; i++)
        {
            [_infoArray addObject:@"这是一个测试！"];
        }
    }
    return _infoArray;
}

-(UIImageView *)headImageView
{
    if (_headImageView == nil)
    {
        _headImageView= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"10.jpg"]];
        _headImageView.frame=CGRectMake(0, 0, IPHONE_W,kImageOriginHight);
    }
    return _headImageView;
}

@end
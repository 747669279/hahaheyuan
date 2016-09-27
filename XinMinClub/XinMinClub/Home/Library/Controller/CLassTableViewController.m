//
//  CLassTableViewController.m
//  XinMinClub
//
//  Created by 赵劲松 on 16/7/19.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "CLassTableViewController.h"
#import "SVProgressHUD.h"
#import "SeeThinkCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "ShareViewController.h"
#import "CommentTableViewController.h"
#import "WBStatusComposeViewController.h"
#import "YYKit.h"

@interface CLassTableViewController () <CommentDelegate> {
    int k; // 控制点击右边按钮的次数的开关
    
    NSInteger shareClickNum; // 监听分享button在点击了腾讯微博分享的状态
    
    NSInteger kj_sharekaiguan;// 分享开关
}

@property(nonatomic,strong)ShareViewController *share;//分享

// 右边的按钮弹出的界面
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *navigationView;
@property(nonatomic,strong)UIImageView *headImageView;//头部图片
@property(nonatomic,strong)NSMutableArray *infoArray;//数据源数组

@end
//屏幕宽、高 宏定义
#define IPHONE_W ([UIScreen mainScreen].bounds.size.width)
#define IPHONE_H ([UIScreen mainScreen].bounds.size.height)

@implementation CLassTableViewController

static CGFloat kImageOriginHight =300;

- (void)viewDidLoad{
    [super viewDidLoad];
    k=0;
    self.navigationItem.titleView=self.navigationView;
    //将视图添加到界面上
//    [self.tableView.tableHeaderView addSubview:self.headImageView];
    
    shareClickNum = 0;
    kj_sharekaiguan=0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareButClick1:) name:@"closeShare" object:nil];
    [self.view addSubview:self.share.view];
    
    // 右侧消息按钮
    UIImage *leftImage = [[UIImage imageNamed:@"player"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(leftAction:)];
    self.navigationItem.rightBarButtonItem = leftButtonItem;
    
    [self bott];
}

- (void)bott{
    for (NSInteger i=0; i<4; i++) {
        CGFloat x=SCREEN_WIDTH/20;
        CGFloat y=(SCREEN_HEIGHT*2/5)/13*(i+1)+(SCREEN_HEIGHT*2/5)*2/13*(i);
        CGFloat w=SCREEN_WIDTH/10;
        CGFloat h=(SCREEN_HEIGHT*2/5)*2/13;
        UIButton *b1=[UIButton buttonWithType:UIButtonTypeCustom];
        b1.frame=CGRectMake(x, y, w, h);
        b1.backgroundColor=[UIColor orangeColor];
        [self.leftView addSubview:b1];
        if (i == 0) {
            [b1 setTitle:@"分享" forState:UIControlStateNormal];
            [b1 addTarget:self action:@selector(b0Touch) forControlEvents:UIControlEventTouchUpInside];
        }
        if (i == 1) {
            [b1 setTitle:@"收藏" forState:UIControlStateNormal];
            [b1 addTarget:self action:@selector(b1Touch) forControlEvents:UIControlEventTouchUpInside];
        }
        if (i == 2) {
            [b1 setTitle:@"评论" forState:UIControlStateNormal];
            [b1 addTarget:self action:@selector(b2Touch) forControlEvents:UIControlEventTouchUpInside];
        }
        if (i == 3) {
            [b1 setTitle:@"下载" forState:UIControlStateNormal];
            [b1 addTarget:self action:@selector(b3Touch) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)b0Touch {
//    [self.view.superview.window bringSubviewToFront:_share.view];
    if (shareClickNum != 0) {
        _share.view.center = CGPointMake(SCREEN_WIDTH/2,2*SCREEN_HEIGHT - 60);
    }
    [UIView transitionWithView:self.share.view duration:0.5 options:0 animations:^{
        _share.view.alpha = 1.0;
        [self.view bringSubviewToFront:_share.view];
        CGFloat yOffset  = self.tableView.contentOffset.y;
        _share.view.center = CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT*5/6 + yOffset);
    } completion:nil];
}
- (void)b1Touch {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    [self performSelector:@selector(success) withObject:nil afterDelay:0.6f];
}
- (void)b2Touch {
    // 点击了评论
    CommentTableViewController *cc = [[CommentTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    cc.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cc];
    [self.navigationController presentViewController:nav animated:YES completion:^{
        
    }];
}
- (void)b3Touch {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    [self performSelector:@selector(dowloadSuccess) withObject:nil afterDelay:0.6f];
}

#pragma mark CommentDelegate 

- (void)content:(NSString *)string {
    [_infoArray addObject:string];
}

#pragma mark ProgressMethods

- (void)dismiss {
    [SVProgressHUD dismiss];
}

- (void)dowloadSuccess {
    [SVProgressHUD showSuccessWithStatus:@"添加任务成功"];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.5f];
}

- (void)success {
    [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.5f];
}

#pragma mark 点击分享按钮的通知
-(void)fenxiang111:(NSNotification*)not{
    NSInteger abc=[[not.userInfo valueForKey:@"fenxiang111"] integerValue];
    NSInteger abcd=[[not.userInfo valueForKey:@"tenxunweibo"] integerValue];
    if (abc) {
        shareClickNum=0;
        if (abcd) {
            kj_sharekaiguan=1;
        }
    }
}


#pragma mark 分享
-(UIViewController*)share{
    if (!_share) {
        _share=[[ShareViewController alloc]init];
        _share.view.backgroundColor=[UIColor colorWithRed:0.8367 green:0.749 blue:0.4784 alpha:0.93];
        UILabel *rank=[[UILabel alloc] init];
        rank.text=@"———————————————————————————————————————————————";
        rank.textColor=[UIColor colorWithRed:0.539 green:0.378 blue:0.150 alpha:0.809];
        UIButton *button=[UIButton buttonWithType:UIButtonTypeSystem];
        
        [button setTitle:@"取消" forState:UIControlStateNormal];
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [button addTarget:self action:@selector(shareButClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (SCREEN_HEIGHT<667&&SCREEN_HEIGHT >=568) {
            _share.view.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/3);
            rank.frame=CGRectMake(0,140, _share.view.frame.size.width*2, 20);
            button.frame=CGRectMake(0,rank.frame.origin.y+20,SCREEN_WIDTH, 20);
        }
        else if (SCREEN_HEIGHT<736&&SCREEN_HEIGHT >=667) {
            _share.view.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/3);
            rank.frame=CGRectMake(0,170, _share.view.frame.size.width*2, 20);
            button.frame=CGRectMake(0,rank.frame.origin.y+20,SCREEN_WIDTH, 20);
        }
        else if (SCREEN_HEIGHT>=736) {
            _share.view.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/3);
            rank.frame=CGRectMake(0,195, _share.view.frame.size.width*2, 20);
            button.frame=CGRectMake(0,rank.frame.origin.y+20,SCREEN_WIDTH, 20);
        }
        
        [_share.view addSubview:rank];
        [_share.view addSubview:button];
    }
    return _share;
}

// 通知中心
- (void)shareButClick1:(NSNotification *)not{
    NSLog(@"收起来!!!");
    _share.view.alpha = 0;
    if (!kj_sharekaiguan) {
        shareClickNum = 1;
    }
}

-(IBAction)shareButClick:(id)sender{
    if (shareClickNum != 0) {
        _share.view.center = CGPointMake(SCREEN_WIDTH/2,2*SCREEN_HEIGHT);
        [self.view sendSubviewToBack:_share.view];
    }
    [UIView transitionWithView:self.share.view duration:0.5 options:0 animations:^{
        _share.view.center = CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT+SCREEN_HEIGHT/4);
    } completion:nil];
}

- (IBAction)Share:(UIButton *)sender {
    if (shareClickNum != 0) {
        _share.view.center = CGPointMake(SCREEN_WIDTH/2,2*SCREEN_HEIGHT);
    }
    [UIView transitionWithView:self.share.view duration:0.5 options:0 animations:^{
        _share.view.alpha = 1.0;
        [self.view bringSubviewToFront:_share.view];
        if (shareClickNum != 0) {
            _share.view.center = CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT+SCREEN_HEIGHT/6);
            NSLog(@"%d",shareClickNum);
        }else {
            _share.view.center = CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT*5/6);
            shareClickNum = 0;
        }
    } completion:nil];
}

- (UIView *)leftView{
    if (!_leftView) {
        _leftView=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH/5, 0, SCREEN_WIDTH/5, SCREEN_HEIGHT*2/5)];
        _leftView.backgroundColor=[UIColor greenColor];
    }
    return _leftView;
}

- (void)leftAction:(UIButton *)button {
    NSLog(@"点击了右边的按钮");
    if (k==0) {
        k=1;
        CATransition *animation = [CATransition animation];
        animation.duration = 1.0;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromBottom;
        [self.leftView.layer addAnimation:animation forKey:nil];
        [self.view addSubview:self.leftView];
        return;
    }
    if (k==1) {
        k=0;
        CATransition *animation = [CATransition animation];
        animation.duration = 1.0;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromTop;
        [self.leftView.layer addAnimation:animation forKey:nil];
        [self.leftView removeFromSuperview];
        return;
    }
}

- (UIView *)navigationView{
    if (!_navigationView) {
        _navigationView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-100, 44)];
//        _navigationView.backgroundColor=[UIColor greenColor];
        UILabel *l1=[[UILabel alloc]initWithFrame:CGRectMake(-20, 0, _navigationView.bounds.size.width, 24)];
        UILabel *l2=[[UILabel alloc]initWithFrame:CGRectMake(-20, 24, _navigationView.bounds.size.width, 20)];
        
        l1.text=@"作者名字";
        l2.text=@"这是第几课";
        l1.textAlignment=NSTextAlignmentCenter;
        l2.textAlignment=NSTextAlignmentCenter;
        l1.font=[UIFont systemFontOfSize:16];
        l2.font=[UIFont systemFontOfSize:14];
        
        [_navigationView addSubview:l1];
        [_navigationView addSubview:l2];
    }
    return _navigationView;
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
    
    _share.view.alpha = 0;
    k=0;
    CATransition *animation = [CATransition animation];
    animation.duration = 1.0;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    [self.leftView.layer addAnimation:animation forKey:nil];
    [self.leftView removeFromSuperview];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return [self.tableView fd_heightForCellWithIdentifier:@"SeeCell" cacheByIndexPath:indexPath configuration:^(SeeThinkCell *cell) {
            ((SeeThinkCell*)cell).peopleText.text = @"在iOS开发中,cell高度的适应始终是一件比较麻烦的事情.        在我做过的项目中,比较好的方法是让一个类专门通过数据模型来计算cell的高度,然后在tableView代理里面返回算好的高度,这样做耦合度低,利于复用,而且思路非常清晰,但缺点是使用稍显复杂.      now福利来了,我们有了UITableView+FDTemplateLayoutCell这个开源类,让cel高度的自适应变得格外容易";
        }];
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return IPHONE_W * 0.618;
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
        ((SeeThinkCell*)cell).peopleText.text = @"在iOS开发中,cell高度的适应始终是一件比较麻烦的事情.        在我做过的项目中,比较好的方法是让一个类专门通过数据模型来计算cell的高度,然后在tableView代理里面返回算好的高度,这样做耦合度低,利于复用,而且思路非常清晰,但缺点是使用稍显复杂.      now福利来了,我们有了UITableView+FDTemplateLayoutCell这个开源类,让cel高度的自适应变得格外容易";
    }
    
    return cell;
}

#pragma mark -- get 初始化操作

-(NSMutableArray *)infoArray
{
    if (_infoArray == nil)
    {
        _infoArray = [[NSMutableArray alloc]init];
        for (int i=0; i<4; i++)
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
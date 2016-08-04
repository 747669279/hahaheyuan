//
//  MyNews.m
//  qweqwe
//
//  Created by 贺军 on 16/7/26.
//  Copyright © 2016年 贺军. All rights reserved.
//

#import "MyNews.h"
#import "recommendedCell.h"
@interface MyNews ()<UITableViewDelegate,UITableViewDataSource>{
    NSString *Title;
    NSInteger webViewHeight;
}
@property(nonatomic,strong)UIView *lowView;
@property(nonatomic,strong)UITableView *theFramework;
@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,strong)NSMutableArray<NewsMode*>*myNewsMode;
@end
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@implementation MyNews

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.lowView];
    _theFramework=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_HEIGHT/11)];
    _theFramework.delegate=self;
    _theFramework.dataSource=self;
    [self.view addSubview:_theFramework];
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    UINib *nib=[UINib nibWithNibName:@"recommendedCell" bundle:nil];
    [self.theFramework registerNib:nib forCellReuseIdentifier:@"recommended"];

}
-(void)viewWillDisappear:(BOOL)antimated{
    [super viewWillDisappear:antimated];
    [self.webView.scrollView removeObserver:self
                                    forKeyPath:@"contentSize" context:nil];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.backgroundColor=[UIColor whiteColor];
    if (indexPath.row==0) {
        cell.textLabel.text =Title;
        UIFont *myFont = [ UIFont fontWithName: @"Arial" size: 25.0 ];
        cell.textLabel.font  = myFont;
        cell.textLabel.numberOfLines = 0;
    }else
    if (indexPath.row==1) {
        [cell addSubview:self.webView];
    }else
    if (indexPath.row==2) {
        cell.textLabel.text=@"相关推荐";
        cell.backgroundColor=[UIColor colorWithWhite:0.548 alpha:1.000];
        UIFont *myFont = [ UIFont fontWithName: @"Arial" size: 15.0 ];
        cell.textLabel.font  = myFont;
        cell.textLabel.numberOfLines = 0;
    }else
    if (indexPath.row>=3&&indexPath.row<=5) {
        cell=[tableView dequeueReusableCellWithIdentifier:@"recommended" forIndexPath:indexPath];
        NewsMode *mode=[[NewsMode alloc]init];
        mode=_myNewsMode[indexPath.row-3];
        ((recommendedCell*)cell).Recommended=mode;
    }else
        cell.textLabel.text=@"";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return UITableViewAutomaticDimension;
    }else
    if (indexPath.row==1) {
        return webViewHeight;
    }else
    if (indexPath.row==2) {
        return UITableViewAutomaticDimension;
    }else
    if (indexPath.row>=3&&indexPath.row<=5) {
            return 30;
    }else

    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIView*)lowView{
    if (!_lowView) {
        _lowView=[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-SCREEN_HEIGHT/11, SCREEN_WIDTH, SCREEN_HEIGHT/11)];
        _lowView.backgroundColor=[UIColor colorWithRed:0.883 green:0.851 blue:0.885 alpha:1.000];
        UIButton *button1=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        [button1 setTitle:@"返回" forState:UIControlStateNormal];
        UIButton *button2=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, 50, 50)];
        [button2 setTitle:@"评论" forState:UIControlStateNormal];
        UIButton *button3=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2+50, 0, 50, 50)];
        [button3 setTitle:@"评价" forState:UIControlStateNormal];
        UIButton *button4=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2+100, 0, 50, 50)];
        [button4 setTitle:@"分享" forState:UIControlStateNormal];
        [_lowView addSubview:button1];
        [_lowView addSubview:button2];
        [_lowView addSubview:button3];
        [_lowView addSubview:button4];
  
    }
    return _lowView;
}
-(UIWebView*)webView{
    if (!_webView) {
        _webView= [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
       _webView.scrollView.bounces=NO;
    }
    return _webView;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    webViewHeight = [[_webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue]+100;
    CGRect newFrame    = _webView.frame;
    newFrame.size.height  = webViewHeight;
    _webView.frame = newFrame;
    [_theFramework reloadData];
}
-(void)setTheTitle:(NSString *)TheTitle{
    Title=TheTitle;
    [_theFramework reloadData];
}
-(void)setURL:(NSString *)URL{
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    [_webView loadRequest:request];
    [_theFramework reloadData];
}
-(void)setRecommended:(NSMutableArray<NewsMode *> *)recommended{
    _myNewsMode=recommended;
    [_theFramework reloadData];
}
@end

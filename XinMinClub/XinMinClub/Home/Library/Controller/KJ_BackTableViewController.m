//
//  KJ_BackTableViewController.m
//  XinMinClub
//
//  Created by 杨科军 on 16/5/8.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "KJ_BackTableViewController.h"
#import "SVProgressHUD.h"
#import "directoryTableViewController.h"
#import "DetailsTableViewController.h"
#import "ShareViewController.h"
#import "UIImageView+WebCache.h"
#import "ReadTableViewController.h"
#import "subcatalogCell.h"
#import "PalyerViewController.h"
#import "ReaderTableViewController.h"

@interface KJ_BackTableViewController ()<UITableViewDelegate,UITableViewDataSource>{
    CGFloat topData; // formation（底层的tableView）距离头顶的距离
    UITableViewCell *kj_cell;
    
    NSInteger kj_clickButtonNum; // 区分点击的button是章节还是详情或者阅读
    
    UIButton *shareCloseButton;
    NSInteger shareClickNum; // 监听分享button在点击了腾讯微博分享的状态
    
    NSInteger likeButton; // 点击我喜欢的按钮次数。
    // 头像那块的视图
    UIImageView *kj_imageView;
    UILabel *kj_nameLabel;
    UIButton *kj_likeButton;
    UIButton *kj_shareButton;
    
    // header上面的章节、详情、阅读3个按钮
    UIButton *sectionButton;
    UIButton *detailsButton;
    UIButton *readButton;
    
    NSInteger kj_sharekaiguan;
}

@property (nonatomic, strong) UITableView *formation;  // 底层的试图，是一个支持滑动的TABLE
@property (nonatomic, strong) UIImageView *advertising;// 广告
@property (nonatomic, strong) directoryTableViewController *directory; // 章节Table
@property (nonatomic, strong) DetailsTableViewController *detailsTable;
@property (nonatomic, strong) ReadTableViewController *readTable;
@property (nonatomic, strong) UIView *kj_backView; // 头像后面的视图
@property (nonatomic, strong) UIView *kj_listBackView; // 章节，详情，阅读后面的视图
@property (nonatomic, strong) ShareViewController *share; // 分享

@end

@implementation KJ_BackTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.advertising];
    [self.view addSubview:self.formation];
    
    self.title = _libraryTitle; // 标题
    
    kj_sharekaiguan=0;
    topData = 0;
    kj_clickButtonNum=1;
    self.view.backgroundColor = [UIColor blackColor];
    
    // 右侧消息按钮
    UIImage *leftImage = [[UIImage imageNamed:@"Join_the_corpus"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(leftAction)];
    self.navigationItem.rightBarButtonItem = leftButtonItem;
    
    // 分享的UIView
    shareClickNum = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareButClick1:) name:@"closeShare" object:nil];
    [self.view addSubview:self.share.view];
    
    // 观察push到的播放器是电子书还是音频的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kj_pushIsPlayer:) name:@"kj_pushIsPlayerOrEBook" object:nil];
    
    // 分享开关
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fenxiang111:) name:@"fenxiang111" object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    // 设置navigationBar背景透明
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 三个分栏界面是否隐藏
    i = 0;
    j = 0;
    k = 0;
    
    // 只修改这个navigationBar的样式和颜色
    [self.navigationController.navigationBar lt_reset];
}

#pragma mark 重写dealloc(销毁方法)
-(void)dealloc{
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kj_pushIsPlayerOrEBook" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"fenxiang111" object:nil];

    // 移除监听
    [_directory removeObserver:self forKeyPath:@"whenTheTop"];
    [_detailsTable removeObserver:self forKeyPath:@"kj_whenTheTop"];
}

#pragma mark 键值监听(监听是否滚动到顶部)
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
//    NSLog(@"------%@,zzz%@,xxxx%@,kkk%@",change,object,context,keyPath);
    if ([keyPath isEqualToString:@"whenTheTop"]) {
        _directory.hasBeenTo = NO;
        topData -= 100;
    }
    if ([keyPath isEqualToString:@"kj_whenTheTop"]) {
        _detailsTable.kj_hasBeenTo = NO;
        topData -= 100;
    }
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
- (void)shareButtonAction:(UIButton *)sender{
    NSLog(@"点击了分享！！！");
    if (sender.tag==1) {
        if (shareClickNum != 0) {
            _share.view.center = CGPointMake(SCREEN_WIDTH/2,2*SCREEN_HEIGHT);
        }
        [UIView transitionWithView:self.share.view duration:0.5 options:0 animations:^{
            _share.view.alpha = 1.0;
            [self.view bringSubviewToFront:_share.view];
            if (shareClickNum != 0) {
                _share.view.center = CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT+SCREEN_HEIGHT/6);
            }else {
                _share.view.center = CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT*5/6);
                shareClickNum = 0;
            }
        } completion:nil];
    }
}
-(UIViewController*)share{
    if (!_share) {
        _share=[[ShareViewController alloc]init];
        NSString *shareText = [NSString stringWithFormat:@"%@--%@",_libraryTitle,_libraryAuthorName];
        _share.Content = shareText; // 分享内容（详情）
        UMSocialUrlResource *aa = [[UMSocialUrlResource alloc]initWithSnsResourceType:UMSocialUrlResourceTypeImage url:_libraryImageUrl]; // 图片
        _share.UrlResource = aa; // 分享网址
        _share.view.backgroundColor=[UIColor colorWithRed:0.960 green:0.960 blue:0.960 alpha:0.850];
        UILabel *rank=[[UILabel alloc] init];
        rank.text=@"—————————————————————————————————";
        rank.textColor=[UIColor colorWithWhite:0.283 alpha:0.500];
        shareCloseButton=[UIButton buttonWithType:UIButtonTypeSystem];
        
        [shareCloseButton setTitle:@"取消" forState:UIControlStateNormal];
        [shareCloseButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [shareCloseButton addTarget:self action:@selector(shareButClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (SCREEN_HEIGHT==568) {
            _share.view.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/3);
            rank.frame=CGRectMake(0,140, _share.view.frame.size.width*2, 20);
            shareCloseButton.frame=CGRectMake(0,rank.frame.origin.y+20,SCREEN_WIDTH, 20);
        }
        else if (SCREEN_HEIGHT==667) {
            _share.view.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/3);
            rank.frame=CGRectMake(0,170, _share.view.frame.size.width*2, 20);
            shareCloseButton.frame=CGRectMake(0,rank.frame.origin.y+20,SCREEN_WIDTH, 20);
        }
        else if (SCREEN_HEIGHT==736) {
            _share.view.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/3);
            rank.frame=CGRectMake(0,195, _share.view.frame.size.width*2, 20);
            shareCloseButton.frame=CGRectMake(0,rank.frame.origin.y+20,SCREEN_WIDTH, 20);
        }
        
        [_share.view addSubview:rank];
        [_share.view addSubview:shareCloseButton];
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
-(IBAction)shareButClick:(UIButton *)sender{
    if (shareClickNum != 0) {
        _share.view.center = CGPointMake(SCREEN_WIDTH/2,2*SCREEN_HEIGHT);
        [self.view sendSubviewToBack:_share.view];
    }
    [UIView transitionWithView:self.view duration:0.5 options:0 animations:^{
        _share.view.center = CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT+SCREEN_HEIGHT/4);
    } completion:nil];
}

#pragma mark 视图布局
- (directoryTableViewController *)directory{
    if (!_directory) {
        _directory = [[directoryTableViewController alloc] init];
        _directory.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _directory.hasBeenTo = NO;
        _directory.view.backgroundColor = [UIColor whiteColor];
        [_directory addObserver:self forKeyPath:@"whenTheTop" options:NSKeyValueObservingOptionNew context:nil];//监听滚动状态
        
        // 传递数据
        _directory.kj_libraryNum = _libraryNum;
        _directory.kj_imageUrll = _libraryImageUrl;
    }
    return _directory;
}
- (DetailsTableViewController*)detailsTable{
    if (!_detailsTable) {
        _detailsTable = [[DetailsTableViewController alloc] init];
        _detailsTable.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _detailsTable.kj_hasBeenTo = NO;
        _detailsTable.view.backgroundColor = [UIColor whiteColor];
        [_detailsTable addObserver:self forKeyPath:@"kj_whenTheTop" options:NSKeyValueObservingOptionNew context:nil];//监听滚动状态
        
        // 传递数据
        _detailsTable.detailsTextArray = @[_libraryImageUrl,_libraryTitle,_libraryAuthorName,_libraryType,_libraryLanguage,_libraryDetails];
        _detailsTable.libraryID = _libraryNum;
    }
    return _detailsTable;
}
- (ReadTableViewController*)readTable{
    if (!_readTable) {
        _readTable = [[ReadTableViewController alloc] init];
        _readTable.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        _readTable.kj_bookID = self.libraryNum;
    }
    return _readTable;
}

-(UITableView *)formation{
    if (!_formation) {
        _formation = [[UITableView alloc]initWithFrame:CGRectMake(0, 64,SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _formation.dataSource = self;
        _formation.delegate = self;
        _formation.separatorStyle = UITableViewCellSelectionStyleNone;
        _formation.backgroundColor=[UIColor clearColor];
    }
    return _formation;
}
-(UIImageView*)advertising{
    if (!_advertising) {
        UIImage *MyAdvertising = [UIImage imageNamed:@"1false.jpg"];
        _advertising = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/4+64)];
        _advertising.image = MyAdvertising;
        NSURL *url = [NSURL URLWithString:_libraryImageUrl];
        [_advertising sd_setImageWithURL:url];
    }
    return _advertising;
}
- (UIView *)kj_backView{
    if (!_kj_backView) {
        CGFloat x = 0;
        CGFloat y = 0;
        CGFloat w = [UIScreen mainScreen].bounds.size.width;
        CGFloat h = 60;
        _kj_backView = [[UIView alloc] init];
        _kj_backView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.4];
        _kj_backView.frame = CGRectMake(x,y,w,h);
        
        kj_imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, h-10, h-10)];
        kj_imageView.image = [UIImage imageNamed:@"1false.jpg"];
        NSURL *url = [NSURL URLWithString:_libraryImageUrl];
        [kj_imageView sd_setImageWithURL:url];
        kj_imageView.layer.masksToBounds = YES;
        kj_imageView.layer.cornerRadius = (h-10)/2;
        
        kj_nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(kj_imageView.frame.origin.x+h, 10, 3*h, h-20)];
        kj_nameLabel.text = @"这只是一个名字";
        kj_nameLabel.text = _libraryAuthorName;
        kj_nameLabel.textColor = [UIColor whiteColor];
        
        kj_likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        kj_likeButton.frame = CGRectMake(SCREEN_WIDTH-2*h+20, 15, h-30, h-30);
        [kj_likeButton addTarget:self action:@selector(likeTap) forControlEvents:UIControlEventTouchUpInside];
        // 是否添加到收藏(喜欢)里面
        if ([[UserDataModel defaultDataModel].userLikeBookID containsObject:_libraryNum]) {
            UIImage *likeImage = [UIImage imageNamed:@"001_0000s_0002_102-副本"];
            [kj_likeButton setImage:likeImage forState:UIControlStateNormal];
            likeButton = 1;
        }
        else{
            UIImage *likeImage = [UIImage imageNamed:@"001_0000s_0003_102"];
            [kj_likeButton setImage:likeImage forState:UIControlStateNormal];
            likeButton = 0;
        }
        
        kj_shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        kj_shareButton.frame = CGRectMake(SCREEN_WIDTH-h+10, 15, h-30, h-30);
        UIImage *shareImage = [UIImage imageNamed:@"001_0000s_0000_share"];
        [kj_shareButton setImage:shareImage forState:UIControlStateNormal];
        [kj_shareButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        kj_shareButton.tag = 1;
        
        [_kj_backView addSubview:kj_imageView];
        [_kj_backView addSubview:kj_nameLabel];
        [_kj_backView addSubview:kj_likeButton];
        [_kj_backView addSubview:kj_shareButton];
    }
    return _kj_backView;
}
- (UIView *)kj_listBackView{
    if (!_kj_listBackView) {
        CGFloat x = 0;
        CGFloat y = 0;
        CGFloat w = [UIScreen mainScreen].bounds.size.width;
        CGFloat h = 44;
        _kj_listBackView = [UIView new];
        _kj_listBackView.backgroundColor = [UIColor colorWithRed:0.7182 green:0.139 blue:0.1463 alpha:1.0];
        _kj_listBackView.frame = CGRectMake(x,y,w,h);
        
        sectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sectionButton.frame = CGRectMake(0, 0, w/3, h);
        sectionButton.tag = 1;
        sectionButton.userInteractionEnabled = YES;
        [sectionButton setTitle:@"章节" forState:UIControlStateNormal];
        [sectionButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        detailsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        detailsButton.frame = CGRectMake(w/3, 0, w/3, h);
        detailsButton.tag = 2;
        detailsButton.userInteractionEnabled = YES;
        [detailsButton setTitle:@"详情" forState:UIControlStateNormal];
        [detailsButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        readButton = [UIButton buttonWithType:UIButtonTypeCustom];
        readButton.frame = CGRectMake(w*2/3, 0, w/3, h);
        readButton.tag = 3;
        readButton.userInteractionEnabled = YES;
        [readButton setTitle:@"阅读" forState:UIControlStateNormal];
        [readButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _kj_listBackView.userInteractionEnabled = YES;
        [_kj_listBackView addSubview:sectionButton];
        [_kj_listBackView addSubview:detailsButton];
        [_kj_listBackView addSubview:readButton];
        
        [self ButtonState:1];
    }
    return _kj_listBackView;
}
#pragma mark ButtonAction
- (void)leftAction{
    if ([[DataModel defaultDataModel] addMyLibrary:_libraryNum ImageUrl:_libraryImageUrl BookName:_libraryTitle AuthorName:_libraryAuthorName Type:(NSString *)_libraryType Language:(NSString *)_libraryLanguage Detail:(NSString *)_libraryDetails]) {
        // 提示成功
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD show];
        [self performSelector:@selector(success) withObject:nil afterDelay:0.6f];
    }else{
        // 提示已经有了
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD show];
        [self performSelector:@selector(success11) withObject:nil afterDelay:0.6f];
    }
}
- (void)success {
    [SVProgressHUD showSuccessWithStatus:@"加入文集成功!"];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.5f];
}
- (void)success11 {
    [SVProgressHUD showSuccessWithStatus:@"文集已存在!"];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.5f];
}
- (void)dismiss {
    [SVProgressHUD dismiss];
}

-(void)likeTap {
    NSLog(@"点击了我喜欢");
    // 提示成功
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    if (likeButton == 1) {
        likeButton=0;
        [[UserDataModel defaultDataModel] deleteLikeBookID:_libraryNum];
        [self performSelector:@selector(closeLikeSuccess) withObject:nil afterDelay:0.3f];
    }else if (likeButton==0){
        likeButton=1;
        [[UserDataModel defaultDataModel] addLikeBookID:_libraryNum];
        [self performSelector:@selector(likeSuccess) withObject:nil afterDelay:0.3f];
    }
}
- (void)closeLikeSuccess {
    [SVProgressHUD showSuccessWithStatus:@"取消喜欢!"];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.5f];
    UIImage *image = [UIImage imageNamed:@"001_0000s_0003_102"];
    [kj_likeButton setImage:image forState:UIControlStateNormal];
}
- (void)likeSuccess {
    [SVProgressHUD showSuccessWithStatus:@"加入我喜欢成功!"];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.5f];
    UIImage *image = [UIImage imageNamed:@"001_0000s_0002_102-副本"];
    [kj_likeButton setImage:image forState:UIControlStateNormal];
}

#pragma mark 点击button高亮
-(void)ButtonState:(NSInteger)state{
    //显示选中按钮为高亮
    [sectionButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [detailsButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [readButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    switch (state) {
        case 1:
            [sectionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        case 2:
            [detailsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        case 3:
            [readButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
    }
}

- (IBAction)buttonAction:(UIButton *)sender{
    if (sender.tag == 1) {
        kj_clickButtonNum=1;
        _formation.scrollEnabled=YES;
        [_formation setContentOffset:CGPointMake(0,0) animated:NO];
        [self ButtonState:1];
        [self.formation reloadData];
    }
    if (sender.tag == 2) {
        [self ButtonState:2];
        kj_clickButtonNum=2;
        [_formation setContentOffset:CGPointMake(0,0) animated:NO];
        _formation.scrollEnabled=YES;
        [self.formation reloadData];
    }
    if (sender.tag == 3) {
        [self ButtonState:3];
        kj_clickButtonNum=3;
        NSInteger aa=146;
        if (SCREEN_HEIGHT==568) {
            aa=180;
        }else if (SCREEN_HEIGHT==667) {
            aa=230;
        }else if (SCREEN_HEIGHT==736) {
            aa=236;
        }
        
        [_formation setContentOffset:CGPointMake(0,aa) animated:NO];
        topData=aa-77;
        _formation.scrollEnabled=NO;
        [self.formation reloadData];
    }
}

#pragma mark 通知中心(观察push到的界面是电子书还是音频)
- (void)kj_pushIsPlayer:(NSNotification *)notification{
    NSInteger kj_integer = [[notification.userInfo valueForKey:@"kj_pushIsPlayerOrEBook"] integerValue];
    if (kj_integer==1) {
        [self.navigationController pushViewController:[PalyerViewController shareObject] animated:NO];
    }
    if (kj_integer==2) {
        [self.navigationController pushViewController:[ReaderTableViewController shareObject] animated:NO];
    }
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if(topData > 0){
        topData = 0;
        _directory.hasBeenTo = YES;
        _detailsTable.kj_hasBeenTo = YES;
    }
    // 下拉的时候
    if (topData<0) {
        _advertising.frame = CGRectMake(0+(scrollView.bounds.origin.y/2), 0+(scrollView.bounds.origin.y/2), SCREEN_WIDTH-scrollView.bounds.origin.y, (SCREEN_HEIGHT/4+64)-scrollView.bounds.origin.y-(scrollView.bounds.origin.y/2));
    }
    
    // 调整navigationBar的颜色透明度
    CGFloat a = scrollView.bounds.origin.y/148.33;
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor  colorWithRed:0.594 green:0.205 blue:0.170 alpha:a]];
    _advertising.alpha = 1-a;
    
    topData = scrollView.bounds.origin.y;
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 3;
    }
    return 1;
}

static BOOL i = 0;
static BOOL j = 0;
static BOOL k = 0;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    kj_cell = [tableView dequeueReusableCellWithIdentifier:@"aacell"];
    if (!kj_cell) {
        kj_cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"aacell"];
    }
    kj_cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 2&&indexPath.section == 0) {
        [kj_cell addSubview:self.kj_backView];
        kj_cell.backgroundColor = [UIColor clearColor];
    }
    if (i) self.readTable.view.hidden = YES;
    if (indexPath.section==1) {
        switch (kj_clickButtonNum) {
            case 1:
                if (j) self.detailsTable.view.hidden = YES;
                k = 1;
                self.directory.view.hidden = NO;
                [kj_cell addSubview:self.directory.view];
                break;
                
            case 2:
                if (k) self.directory.view.hidden = YES;
                j = 1;
                self.detailsTable.view.hidden = NO;
                [kj_cell addSubview:self.detailsTable.view];
                break;
                
            case 3:
                i = 1;
                self.readTable.view.hidden = NO;
                [kj_cell addSubview:self.readTable.view];
                break;
        }
    }
    else
        kj_cell.backgroundColor=[UIColor clearColor];
    
    return kj_cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0&&indexPath.row == 2) {
        return 60;
    }
    if (indexPath.section==1&&indexPath.row==0) {
        return SCREEN_HEIGHT;
    }
    
    if (SCREEN_HEIGHT==568) {
        return 30;
    }
    else if (SCREEN_HEIGHT==667) {
        return 40;
    }
    return 44; // 点击之后宽度根据显示的东西自适应
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return 44;
    }
    return 0.1;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return nil;
    }
    return self.kj_listBackView;
}

@end

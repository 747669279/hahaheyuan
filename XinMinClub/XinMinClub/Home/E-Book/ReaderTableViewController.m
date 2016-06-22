//
//  ReaderTableViewController.m
//  XinMinClub
//
//  Created by 贺军 on 16/4/7.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "ReaderTableViewController.h"
#import "UINavigationBar+Awesome.h"
#import "LocalReadersDirectory.h"
#import "DataModel.h"
#import "UIView+Draw.h"

#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height) // 屏幕高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width) // 屏幕宽度

@interface ReaderTableViewController ()<UITableViewDelegate,UITableViewDataSource>{
    CGFloat fontSize;
    NSMutableArray *text;
    UIColor *myTextColer;
    NSMutableArray *myContent;
    NSMutableArray *myName;
    NSMutableArray *myID;
    int off;
    NSInteger ChapterNumber;//标记当前是那章
    CGFloat R;
    CGFloat G;
    CGFloat B;
    float textColorValue[3];
    float backdropColorValue[3];
    int myOffColor;
    UITableViewCell *cell;
    CGFloat nowPlace; // 滚动条目前的位置
}

@property(nonatomic,strong)LocalReadersDirectory *localReadersDirectory;
@property(nonatomic,strong)UIView *menuView; // 点击屏幕弹出的上一章下一章等等
@property(nonatomic,strong)UIView *MyBackground;
@property(nonatomic,strong)UIImageView *BackgroundPicture;
@property(nonatomic,strong)UIView *moreView;//更多界面
@property(nonatomic,strong)UISlider *progress;//进度
@property(nonatomic,strong)UIButton *PreviousChapter;//上一章
@property(nonatomic,strong)UIButton *NextChapter;//下一章
@property(nonatomic,strong)UIButton *Color1;
@property(nonatomic,strong)UIButton *Color2;
@property(nonatomic,strong)UIButton *Color3;
@property(nonatomic,strong)UIButton *Color4;
@property(nonatomic,strong)UIButton *Color5;
@property(nonatomic,strong)UIButton* nightMode;//夜间模式
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)UIButton* textColor;
@property(nonatomic,strong)UIButton* backdropColor;
@property(nonatomic,strong)UILabel* myR;
@property(nonatomic,strong)UILabel* myG;
@property(nonatomic,strong)UILabel* myB;
@property(nonatomic,strong)UISlider *rColor;//R颜色
@property(nonatomic,strong)UISlider *gColir;//G颜色
@property(nonatomic,strong)UISlider *bColir;//B颜色


@end

@implementation ReaderTableViewController
+(instancetype)shareObject{
    static ReaderTableViewController *model = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        model = [[super allocWithZone:NULL] init];
    });
    return model;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //背景颜色
    _MyBackground=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.view.backgroundColor = [UIColor whiteColor];
    textColorValue[0]=0;
    textColorValue[1]=0;
    textColorValue[2]=0;
    backdropColorValue[0]=0;
    backdropColorValue[1]=0;
    backdropColorValue[2]=0;
    off = 1;
    myOffColor=1;
    R=0;G=0;B=0;
    myTextColer=[UIColor blackColor];
    fontSize=20;//---------
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notice:) name:@"spread" object:nil];
    _tableview.delegate=self;
    _tableview.dataSource=self;
    [self.view addSubview:self.BackgroundPicture];
    [self.view addSubview:_MyBackground];
    [self.view addSubview:self.tableview];
    UITapGestureRecognizer *GestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickScreen:)];
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(LocalMusic:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(LeftSwipe:)];
    [leftSwipe setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self getBook:myContent[0]];
    ChapterNumber=0;
    [self.view addSubview:self.localReadersDirectory.view];
    [self.view addGestureRecognizer:leftSwipe];
    [self.view addGestureRecognizer:recognizer];
    [self.tableview addGestureRecognizer:GestureRecognizer];
    [self.view addSubview:self.menuView];
    [self.view addSubview:self.moreView];
    [self.menuView addSubview:self.nightMode];
    [self.menuView addSubview:self.progress];
    [self.menuView addSubview:self.PreviousChapter];
    [self.menuView addSubview:self.NextChapter];
    [self.menuView addSubview:self.Color1];
    [self.menuView addSubview:self.Color2];
    [self.menuView addSubview:self.Color3];
    [self.menuView addSubview:self.Color4];
    [self.menuView addSubview:self.Color5];
    [self.moreView addSubview:self.myR];
    [self.moreView addSubview:self.myG];
    [self.moreView addSubview:self.myB];
    [self.moreView addSubview:self.rColor];
    [self.moreView addSubview:self.gColir];
    [self.moreView addSubview:self.bColir];
    [self.moreView addSubview:self.textColor];
    [self.moreView addSubview:self.backdropColor];
}

-(UITableView*)tableview{
    if (!    _tableview) {
        _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _tableview.backgroundColor=[UIColor colorWithWhite:0.603 alpha:0.000];
    }
    return _tableview;
}
-(void)setSectionArray:(NSMutableArray<theIncomingDataModel*>*)DataModel WhetherTheAudio:(NSMutableArray*)Audio{
    myID=[NSMutableArray array];
    myName=[NSMutableArray array];
    myContent=[NSMutableArray array];
    for (theIncomingDataModel *Model in DataModel) {
        [myID addObject:Model.chapterID];
        [myName addObject:Model.chapterName];
        [myContent addObject:Model.chapterLrc];
        ChapterNumber=Model.ClackTag;
    }
    _tableview.separatorStyle = NO;
    [self getBook:myContent[ChapterNumber]];
    _localReadersDirectory.myTitle=myName;
    [_tableview reloadData];
}
-(void)setReadTag:(NSInteger)readTag{//对话框调转过来时候对应的章节
    [self getBook:myContent[readTag]];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [_tableview reloadData];
    [self.navigationController.navigationBar lt_setTranslationY:(-65)];
    // 如何在IOS设备中去掉屏幕上的statusbar
    _menuView.center=CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT+self.menuView.frame.size.height/2);
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor colorWithRed:0.048 green:0.115 blue:0.112 alpha:0.900]];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_tableview reloadData];
    [DataModel defaultDataModel].activityPlayer=1;
    [self.navigationController.navigationBar lt_setTranslationY:(1)];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    self.localReadersDirectory.view.alpha = 0;
    [self.navigationController.navigationBar lt_reset];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    nowPlace =self.tableview.bounds.origin.y/(self.tableview.contentSize.height-SCREEN_HEIGHT);
    self.progress.value = nowPlace;
}

-(void)getBook:(NSString *)Book{
    //分割歌词
    text=[NSMutableArray array];
        NSArray *sepArray=[Book componentsSeparatedByString:@"["];
        NSArray *lineArray;
        for(int i=0;i<sepArray.count;i++){
            if([sepArray[i] length]>0){
                lineArray=[sepArray[i] componentsSeparatedByString:@"]"];
                if(![lineArray[0] isEqualToString:@"\n"]){
                    [text addObject:lineArray.count>1?lineArray[1]:@""];
                }
              }
            }
    [_tableview reloadData];
}

#pragma mark 章节目录
-(LocalReadersDirectory *)localReadersDirectory{
    if (!_localReadersDirectory) {
        _localReadersDirectory=[[LocalReadersDirectory alloc]initWithStyle:UITableViewStylePlain];
        _localReadersDirectory.view.frame=CGRectMake(-SCREEN_WIDTH, 0, SCREEN_WIDTH-SCREEN_WIDTH/3, SCREEN_HEIGHT);
        _localReadersDirectory.view.backgroundColor=[UIColor colorWithRed:0.048 green:0.115 blue:0.112 alpha:0.900];
        _localReadersDirectory.myTitle=myName;
    }
    return _localReadersDirectory;
}

#pragma mark 界面布局
-(UIImageView*)BackgroundPicture{
    if (!_BackgroundPicture) {
        _BackgroundPicture=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"001_0000_7675119_085617932000_2"]];
        _BackgroundPicture.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    return _BackgroundPicture;
}
-(UIView*)menuView{
    if (!_menuView) {
        _menuView=[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.NextChapter.frame.size.height*2+60)];
        _menuView.backgroundColor=[UIColor colorWithRed:0.048 green:0.115 blue:0.112 alpha:0.900];
    }
    return _menuView;
}
-(UIView*)moreView{
    if (!_moreView) {
        _moreView=[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.NextChapter.frame.size.height*2+60)];
        _moreView.backgroundColor=[UIColor colorWithRed:0.048 green:0.115 blue:0.112 alpha:0.900];
    }
    return _moreView;
}
-(UISlider*)progress{
    if (!_progress) {
        _progress = [[UISlider alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-140)/6+30,20, SCREEN_WIDTH-(SCREEN_WIDTH-140)/3 - 60, (SCREEN_WIDTH-140)/6)];
        UIImage *thumbImage = [UIImage imageNamed:@"001_0002_Inner"];
        UIImage *thumbImage1 = [UIImage imageNamed:@"001_0003_Rail"];
        _progress.backgroundColor = [UIColor clearColor];
        [_progress setThumbImage:thumbImage forState:UIControlStateNormal];
        [_progress setMinimumTrackImage:thumbImage1 forState:UIControlStateNormal];
        [_progress setMaximumTrackImage:thumbImage1 forState:UIControlStateNormal];
        _progress.value=0;
        _progress.minimumValue=0;
        _progress.maximumValue=1;
        [_progress addTarget:self action:@selector(setMyProgress:) forControlEvents:UIControlEventValueChanged];
    }
    return _progress;
}
-(UIButton*)PreviousChapter{
    if (!_PreviousChapter){
        _PreviousChapter=[[UIButton alloc]initWithFrame:CGRectMake(10,20,  (SCREEN_WIDTH-140)/4, (SCREEN_WIDTH-140)/6)];
        [_PreviousChapter setTitle:@"上一章" forState:UIControlStateNormal];
        [_PreviousChapter addTarget:self action:@selector(setMyPreviousChapter:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _PreviousChapter;
}
-(UIButton*)NextChapter{
    if (!_NextChapter) {
        _NextChapter=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-(SCREEN_WIDTH-140)/6-30,20,(SCREEN_WIDTH-140)/4,(SCREEN_WIDTH-140)/6)];
        [_NextChapter setTitle:@"下一章" forState:UIControlStateNormal];
        [_NextChapter addTarget:self action:@selector(setMyNextChapter:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _NextChapter;
}
-(UIButton*)Color1{
    if (!_Color1) {
        _Color1=[[UIButton alloc]initWithFrame:CGRectMake(20,self.NextChapter.frame.origin.y+self.NextChapter.frame.size.height+20,(SCREEN_WIDTH-140)/6,(SCREEN_WIDTH-140)/6)];
        _Color1.backgroundColor=[UIColor brownColor];
        [_Color1 addTarget:self action:@selector(setMyColor1:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _Color1;
}
-(UIButton*)Color2{
    if (!_Color2) {
        _Color2=[[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-140)/6+20+20,self.NextChapter.frame.origin.y+self.NextChapter.frame.size.height+20,(SCREEN_WIDTH-140)/6,(SCREEN_WIDTH-140)/6)];
        _Color2.backgroundColor=[UIColor colorWithRed:0.087 green:0.042 blue:0.600 alpha:1.000];
        [_Color2 addTarget:self action:@selector(setMyColor2:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _Color2;
}
-(UIButton*)Color3{
    if (!_Color3) {
        _Color3=[[UIButton alloc]initWithFrame:CGRectMake(((SCREEN_WIDTH-140)/6+20)*2+20,self.NextChapter.frame.origin.y+self.NextChapter.frame.size.height+20,(SCREEN_WIDTH-140)/6,(SCREEN_WIDTH-140)/6)];
        _Color3.backgroundColor=[UIColor colorWithRed:0.600 green:0.067 blue:0.478 alpha:1.000];
        [_Color3 addTarget:self action:@selector(setMyColor3:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _Color3;
}
-(UIButton*)Color4{
    if (!_Color4) {
        _Color4=[[UIButton alloc]initWithFrame:CGRectMake(((SCREEN_WIDTH-140)/6+20)*3+20,self.NextChapter.frame.origin.y+self.NextChapter.frame.size.height+20,(SCREEN_WIDTH-140)/6,(SCREEN_WIDTH-140)/6)];
        _Color4.backgroundColor=[UIColor colorWithRed:0.229 green:0.600 blue:0.099 alpha:1.000];
        [_Color4 addTarget:self action:@selector(setMyColor4:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _Color4;
}
-(UIButton*)Color5{
    if (!_Color5) {
        _Color5=[[UIButton alloc]initWithFrame:CGRectMake(((SCREEN_WIDTH-140)/6+20)*4+20,self.NextChapter.frame.origin.y+self.NextChapter.frame.size.height+20,(SCREEN_WIDTH-140)/6,(SCREEN_WIDTH-140)/6)];
        UIImage *image = [[UIImage imageNamed:@"001_0000_更多"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_Color5 setImage:image forState:UIControlStateNormal];
        [_Color5 addTarget:self action:@selector(setMyColor5:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _Color5;
}
-(UIButton*)nightMode{
    if (!_nightMode) {
        _nightMode=[[UIButton alloc]initWithFrame:CGRectMake(((SCREEN_WIDTH-140)/6+20)*5+20,self.NextChapter.frame.origin.y+self.NextChapter.frame.size.height+20,(SCREEN_WIDTH-140)/6,(SCREEN_WIDTH-140)/6)];
        UIImage *image = [[UIImage imageNamed:@"001_0001_日间"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_nightMode setImage:image forState:UIControlStateNormal];
         _nightMode.tag=1;
         [_nightMode addTarget:self action:@selector(setMyNightMode:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nightMode;
}
-(UIButton*)textColor{
    if (!_textColor) {
        _textColor = [UIButton buttonWithType:UIButtonTypeCustom];
        _textColor.frame = CGRectMake(0, 25, 100, 20);
        [_textColor setTitle:@"字体>" forState:UIControlStateNormal];
        [_textColor addTarget:self action:@selector(myTextColor:) forControlEvents:UIControlEventTouchUpInside];
        }
    return _textColor;
}
-(UIButton*)backdropColor{
    if (!_backdropColor) {
        _backdropColor=[[UIButton alloc]initWithFrame:CGRectMake(0, 75, 100, 20)];
        [_backdropColor setTitle:@"背景  " forState:UIControlStateNormal];
        [_backdropColor addTarget:self action:@selector(myBackdropColorColor:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backdropColor;
}
-(UILabel*)myR{
    if(!_myR){
        _myR=[[UILabel alloc]initWithFrame:CGRectMake(90, 25, 20, 20)];
        _myR.text=@"R";
        _myR.textColor=[UIColor whiteColor];
    }
    return _myR;
}
-(UILabel*)myG{
    if(!_myG){
        _myG=[[UILabel alloc]initWithFrame:CGRectMake(90, 50, 20, 20)];
        _myG.text=@"G";
        _myG.textColor=[UIColor whiteColor];
    }
    return _myG;
}
-(UILabel*)myB{
    if(!_myB){
        _myB=[[UILabel alloc]initWithFrame:CGRectMake(90, 75, 20, 20)];
        _myB.text=@"B";
        _myB.textColor=[UIColor whiteColor];
    }
    return _myB;
}

-(UISlider*)rColor{
    if (!_rColor) {
        _rColor = [[UISlider alloc]initWithFrame:CGRectMake(105,30,SCREEN_WIDTH-120,10)];
        UIImage *thumbImage = [UIImage imageNamed:@"Player_progress_bar"];
        _rColor.backgroundColor = [UIColor clearColor];
        [_rColor setThumbImage:[self OriginImage:thumbImage scaleToSize:CGSizeMake(15, 15)]  forState:UIControlStateNormal];
        UIImage *thumbImage1 = [UIImage imageNamed:@"001_0002_R"];
        [_rColor setMinimumTrackImage:thumbImage1 forState:UIControlStateNormal];
        _rColor.value=0;
        _rColor.minimumValue=0;
        [_rColor addTarget:self action:@selector(MyrColor:) forControlEvents:UIControlEventValueChanged];
    }
    return _rColor;
}
-(UISlider*)gColir{
    if (!_gColir) {
        _gColir = [[UISlider alloc]initWithFrame:CGRectMake(105,55,SCREEN_WIDTH-120,10)];
        UIImage *thumbImage = [UIImage imageNamed:@"Player_progress_bar"];
        _gColir.backgroundColor = [UIColor clearColor];
        [_gColir setThumbImage:[self OriginImage:thumbImage scaleToSize:CGSizeMake(15, 15)]  forState:UIControlStateNormal];
        UIImage *thumbImage1 = [UIImage imageNamed:@"001_0001_G"];
        [_gColir setMinimumTrackImage:thumbImage1 forState:UIControlStateNormal];
        _gColir.value=0;
        _gColir.maximumValue=1;
        [_gColir addTarget:self action:@selector(MygColor:) forControlEvents:UIControlEventValueChanged];
    }
    return _gColir;
}
-(UISlider*)bColir{
    if (!_bColir) {
        _bColir = [[UISlider alloc]initWithFrame:CGRectMake(105,80,SCREEN_WIDTH-120,10)];
        UIImage *thumbImage = [UIImage imageNamed:@"Player_progress_bar"];
        UIImage *thumbImage1 = [UIImage imageNamed:@"001_0000_B"];
        _bColir.backgroundColor = [UIColor clearColor];
        [_bColir setThumbImage:[self OriginImage:thumbImage scaleToSize:CGSizeMake(15, 15)] forState:UIControlStateNormal];
        [_bColir setMinimumTrackImage:thumbImage1 forState:UIControlStateNormal];
        _bColir.value=0;
        _bColir.maximumValue=1;
        [_bColir addTarget:self action:@selector(MybColor:) forControlEvents:UIControlEventValueChanged];
    }
    return _bColir;
}

-(UIImage*) OriginImage:(UIImage*)image scaleToSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);//size为CGSize类型，即你所需要的图片尺寸
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

#pragma mark 点击了按钮的操作
-(IBAction)myTextColor:(id)sender{
    [_backdropColor setTitle:@"背景  " forState:UIControlStateNormal];
    [_textColor setTitle:@"字体>" forState:UIControlStateNormal];
    _rColor.value=backdropColorValue[0];
    _bColir.value=backdropColorValue[2];
    _gColir.value=backdropColorValue[1];
    myOffColor=1;

}
-(IBAction)myBackdropColorColor:(id)sender{
    [_textColor setTitle:@"字体  " forState:UIControlStateNormal];
    [_backdropColor setTitle:@"背景>" forState:UIControlStateNormal];
    _rColor.value=textColorValue[0];
    _bColir.value=textColorValue[2];
    _gColir.value=textColorValue[1];
    myOffColor=0;
}
-(IBAction)MyrColor:(UISlider*)sender{
    R=sender.value;
    if (myOffColor==0) {
        _MyBackground.backgroundColor=[UIColor colorWithRed:R green:G blue:B alpha:1.000];
        textColorValue[0]=sender.value;
    }else{
        myTextColer=[UIColor colorWithRed:R green:G blue:B alpha:1.000];
        backdropColorValue[0]=sender.value;
        [_tableview reloadData];
    }
    
}
-(IBAction)MygColor:(UISlider*)sender{
    G=sender.value;
    if (myOffColor==0) {
        _MyBackground.backgroundColor=[UIColor colorWithRed:R green:G blue:B alpha:1.000];
        textColorValue[1]=sender.value;
    }else{
        myTextColer=[UIColor colorWithRed:R green:G blue:B alpha:1.000];
        backdropColorValue[1]=sender.value;
        [_tableview reloadData];
    }
}
-(IBAction)MybColor:(UISlider*)sender{
    B=sender.value;
    if (myOffColor==0) {
        _MyBackground.backgroundColor=[UIColor colorWithRed:R green:G blue:B alpha:1.000];
        textColorValue[2]=sender.value;
       
    }else{
        myTextColer=[UIColor colorWithRed:R green:G blue:B alpha:1.000];
        backdropColorValue[2]=sender.value;
        [_tableview reloadData];
    }
}
-(IBAction)setMyColor1:(id)sender{
    _MyBackground.backgroundColor=[UIColor brownColor];
    myTextColer=[UIColor whiteColor];
    [_tableview reloadData];
}
-(IBAction)setMyColor2:(id)sender{
    _MyBackground.backgroundColor=[UIColor colorWithRed:0.087 green:0.042 blue:0.600 alpha:1.000];
    myTextColer=[UIColor whiteColor];
    [_tableview reloadData];

}

-(IBAction)setMyColor3:(id)sender{
    _MyBackground.backgroundColor=[UIColor colorWithRed:0.600 green:0.067 blue:0.478 alpha:1.000];
    myTextColer=[UIColor whiteColor];
    [_tableview reloadData];
}

-(IBAction)setMyColor4:(id)sender{
    _MyBackground.backgroundColor=[UIColor colorWithRed:0.229 green:0.600 blue:0.099 alpha:1.000];
    myTextColer=[UIColor whiteColor];
    [_tableview reloadData];
}

-(IBAction)setMyColor5:(id)sender{
        [UIView transitionWithView:_menuView duration:0.5 options:0 animations:^{
        self.localReadersDirectory.view.alpha = 0;
        _menuView.center=CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT+self.menuView.frame.size.height/2);
        [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor colorWithRed:0.048 green:0.115 blue:0.112 alpha:0.900]];
        [self.navigationController.navigationBar lt_setTranslationY:(-65)];
    } completion:nil];
    off=1;
    [UIView transitionWithView:_moreView duration:0.5 options:0 animations:^{
        self.localReadersDirectory.view.alpha = 0;
        _moreView.center=CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT-self.menuView.frame.size.height/2);
    } completion:nil];
    
}

-(IBAction)setMyNextChapter:(id)sender{
    NSLog(@"下一章");
    if (myName.count-1==ChapterNumber) {
        //章节播放完成，
        NSDictionary *ClackTag= @{@"ChangeState":@"complete",@"buttonTag":@(ChapterNumber)};
        //创建一个消息对象
        NSNotification * notice = [NSNotification notificationWithName:@"ChaptersState" object:nil userInfo:ClackTag];
        //发送消息
        [[NSNotificationCenter defaultCenter]postNotification:notice];
        return;
    }

    if (myName.count-1>ChapterNumber) {
        [self getBook:myContent[++ChapterNumber]];
    }
}
-(IBAction)setMyPreviousChapter:(id)sender{
    NSLog(@"上一章");
    if (ChapterNumber>0) {
        [self getBook:myContent[--ChapterNumber]];
    }
}
-(IBAction)setMyProgress:(UISlider*)sender{
    CGFloat a=sender.value *(self.tableview.contentSize.height-SCREEN_HEIGHT);
    self.tableview.bounds=CGRectMake(0, a, SCREEN_WIDTH, SCREEN_HEIGHT);
}
-(IBAction)setMyNightMode:(UIButton*)sender{
    if (sender.tag==1) {
        UIImage *image = [[UIImage imageNamed:@"001_0004_夜间"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_nightMode setImage:image forState:UIControlStateNormal];
        _MyBackground.backgroundColor=[UIColor blackColor];
        myTextColer=[UIColor colorWithRed:0.299 green:0.301 blue:0.291 alpha:1.000];
        [_tableview reloadData];
        sender.tag=0;
    }else{
    UIImage *image = [[UIImage imageNamed:@"001_0001_日间"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_nightMode setImage:image forState:UIControlStateNormal];
    _MyBackground.backgroundColor=[UIColor colorWithRed:1.000 green:0.581 blue:0.771 alpha:0.000];
    myTextColer=[UIColor blackColor];
    [_tableview reloadData];
        sender.tag=1;
    }
}

#pragma mark 手势操作

-(IBAction)LocalMusic:(id)sender{
    NSLog(@"向右滑动了");
    self.localReadersDirectory.view.alpha = 1;
    [UIView transitionWithView:_menuView duration:0.5 options:0 animations:^{
        if (off == 1) {
            self.localReadersDirectory.view.frame = CGRectMake(0, 0, self.localReadersDirectory.view.frame.size.width, SCREEN_HEIGHT);
            _localReadersDirectory.view.center=CGPointMake((SCREEN_WIDTH-SCREEN_WIDTH/3)/2,SCREEN_HEIGHT/2);
        }else{
            self.localReadersDirectory.view.frame = CGRectMake(0, 44,self.localReadersDirectory.view.frame.size.width, SCREEN_HEIGHT - 44 - self.menuView.frame.size.height);
            _localReadersDirectory.view.center=CGPointMake((SCREEN_WIDTH-SCREEN_WIDTH/3)/2,(SCREEN_HEIGHT-self.menuView.frame.size.height)/2+22);
        }
    } completion:nil];
    
}
-(IBAction)LeftSwipe:(id)sender{
    [_tableview reloadData];
    NSLog(@"向左滑动了");
    [UIView transitionWithView:_menuView duration:0.5 options:0 animations:^{
        if (off == 1) {
            _localReadersDirectory.view.center=CGPointMake(-SCREEN_WIDTH/2,SCREEN_HEIGHT/2);
        }else
            _localReadersDirectory.view.center=CGPointMake(-SCREEN_WIDTH/2,(SCREEN_HEIGHT-self.menuView.frame.size.height)/2+32);
    } completion:nil];
}

-(IBAction)ClickScreen:(id)sender{
    NSLog(@"单击了屏幕");
    [UIView transitionWithView:_moreView duration:0.5 options:0 animations:^{
        self.localReadersDirectory.view.alpha = 0;
        _moreView.center=CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT+self.menuView.frame.size.height/2);
    } completion:nil];

    if (off==1) {
        [UIView transitionWithView:_menuView duration:0.5 options:0 animations:^{
            self.localReadersDirectory.view.alpha = 0;
            _menuView.center=CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT-self.menuView.frame.size.height/2);
            [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor colorWithRed:0.048 green:0.115 blue:0.112 alpha:0.900]];
            [self.navigationController.navigationBar lt_setTranslationY:(0)];
        } completion:nil];
        off=0;
    }
    else{
        [UIView transitionWithView:_menuView duration:0.5 options:0 animations:^{
            self.localReadersDirectory.view.alpha = 0;
            _menuView.center=CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT+self.menuView.frame.size.height/2);
            [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor colorWithRed:0.048 green:0.115 blue:0.112 alpha:0.900]];
            [self.navigationController.navigationBar lt_setTranslationY:(-65)];
        } completion:nil];
        off=1;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return text.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        NSInteger c=(((foo1qw([text[indexPath.row] cStringUsingEncoding:NSUTF8StringEncoding])*6)/SCREEN_WIDTH)*45);
        return c+10;
}
//接收到通知
-(IBAction)notice:(NSNotification*)sender{
    NSInteger i=[[sender.userInfo valueForKey:@"buttonTag"] integerValue];
    ChapterNumber=i;
    [self getBook:myContent[i]];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    cell= [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
    cell.textLabel.textColor=myTextColer;
    cell.backgroundColor = [UIColor colorWithWhite:0.603 alpha:0];
    UIFont *newFont = [UIFont fontWithName:@"Arial" size:fontSize];
    cell.textLabel.backgroundColor=[UIColor colorWithWhite:0.603 alpha:0];
    cell.textLabel.font = newFont;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text =text[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0;
}
int foo1qw(const char *p){
    if (*p == '\0')
        return 0;
    else
        return foo1qw(p + 1) + 1;
}

@end

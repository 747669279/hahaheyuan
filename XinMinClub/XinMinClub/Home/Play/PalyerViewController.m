//
//  PalyerView.m
//  player
//
//  Created by Admin on 16/3/22.
//  Copyright © 2016年 Admin. All rights reserved.
#import "PalyerViewController.h"
#import "PlayerSupport.h"
#import "PlayerView.h"
#import "LyricsViewController.h"
#import "ShareViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UINavigationBar+Awesome.h"
#import "DataModel.h"
#import "LibraryViewController.h"
#import "allChapters.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height) // 屏幕高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width) // 屏幕宽度
#define X ([UIScreen mainScreen].bounds.size.width/16) // 宽度

@interface PalyerViewController ()<PlayerSupportDelegate,UITableViewDelegate,UITableViewDataSource>{
    PlayerSupport *play;//播放类
    NSTimer *playProgresTimer;//计时器
    NSMutableArray *LocalMusicName;//存储本地歌名
    NSMutableArray *LocalMusicLyr;//存储本地歌词
    NSMutableArray *VoicelessSoundMusic;//不带音乐的文集
    PlayerView *paly;//存储类
    NSMutableArray *LyrucsTima;//歌词时间数组
    NSMutableArray *LyrucsArray;//歌词数组
    CGPoint Origin;//起点坐标
    //----------------状态区-------------
    BOOL cacheCtateOfPlay;//因网络缓存暂停
    int statePlay1;
    int SongTags;//标记当前是哪首歌曲处于播放状态
    int StatePlay;//播放状态
    int StatePlayButton;//播放按钮状态
    int SongOrderStatus;//歌曲播放状态，单曲循环和顺序播放
    int PositionLyrics;//歌词位置
    //----------------------------------
    NSInteger shareClickNum; // 监听分享button在点击了腾讯微博分享的状态
    
    UIImage *pauseImage;
    UIImage *playImage;
    UIImage *authorPortraits;//作者头像
    NSInteger likeButton;
    
    NSInteger kj_sharekaiguan;// 分享开关
}

@property(nonatomic,strong)NSMutableArray *MusicURL;
@property(nonatomic,strong)NSMutableArray *MusicName1;
@property(nonatomic,strong)NSMutableArray *MusicLyr;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSMutableArray *autorName;
@property (nonatomic, strong) NSMutableArray *kj_IDArray;
@property(nonatomic,strong)NSString *localMusicLyr;
@property(nonatomic,strong)UIView   *LocalMusic;
@property(nonatomic,strong)UITableView *LocalMusicTable;
@property(nonatomic,strong)UIView *GestureSpecial;
@property(nonatomic,strong)UIView *LyricsInterface;
@property(nonatomic,strong)ShareViewController *share;//分享
@property(nonatomic,strong)UIProgressView *pro;//进度条
// 界面布局
@property (nonatomic, strong) UIView *backView;
@property(nonatomic, copy) UIImageView *playerImageView;
@property (nonatomic, strong) UIImageView *kj_imageView;
@property (nonatomic, strong) UILabel *kj_nameLabel;
@property(nonatomic, copy) UILabel *nowTimeLabel;
@property(nonatomic, copy) UILabel *allTimeLabel;
@property(nonatomic, copy) UISlider *playerSlider;
@property(nonatomic, copy) UIButton *upButton;
@property(nonatomic, copy) UIButton *playButton;
@property(nonatomic, copy) UIButton *downButton;
@property(nonatomic, copy) UIButton *likeButton;
@property(nonatomic, copy) UIButton *roundButton;
@property(nonatomic, copy) UIButton *downloadButton;
@property(nonatomic, copy) UIButton *shareButton;
@property(nonatomic, copy) UIButton *allButton;
@property (nonatomic, strong) UILabel *roundLoopLabel;
@property(nonatomic, copy) allChapters *myAllChapters;

@end

@implementation PalyerViewController

+ (instancetype)shareObject{
    static PalyerViewController *model = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        model = [[super allocWithZone:NULL] init];
    });
    return model;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    //接收allChapters通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clackAllChapters:) name:@"ClackTag" object:nil];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.500]];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ClackTag" object:nil];
    
    [DataModel defaultDataModel].activityPlayer=0;
    [self.navigationController.navigationBar lt_reset];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    cacheCtateOfPlay=NO;
    [self.view addSubview:self.playerImageView];
    [self.view addSubview:self.backView];
    pauseImage = [[UIImage imageNamed:@"001_0000s_0008_组-5-副本"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    playImage = [[UIImage imageNamed:@"001_0000s_0009_组-5"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    SongOrderStatus=1;//初始化播放顺序为列表
    VoicelessSoundMusic=[NSMutableArray array];
    //获取通知中心单例对象
    // 分享的UIView
    shareClickNum = 0;
    kj_sharekaiguan=0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fenxiang111:) name:@"fenxiang111" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareButClick1:) name:@"closeShare" object:nil];
    
    LyrucsArray = [NSMutableArray array];
    
    play=[[PlayerSupport alloc]init];//初始化播放器
    if (!_LocalMusicTable) {
        _LocalMusicTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2+SCREEN_WIDTH/4-20,[self modelHeight:1])];
    }
    _LocalMusicTable.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.500];
    play.delegate=self;
    _LocalMusicTable.delegate=self;
    _LocalMusicTable.dataSource=self;
    SongTags=0;
    StatePlay=2;
    statePlay1=1;
    //StatePlayButton=0;
    _GestureSpecial=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH)];
    [self.view addSubview:self.LyricsInterface];
    [self.view addSubview:_GestureSpecial];
    [self.view addSubview:self.LocalMusic];
    [self.LocalMusic addSubview:self.LocalMusicTable];
    [play addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];//监听播放状态
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(LocalMusic:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:recognizer];
    UITapGestureRecognizer *GestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleScreen:)];//检测发动手势
    [self.GestureSpecial addGestureRecognizer:GestureRecognizer];
    LocalMusicName=[NSMutableArray array];
    // LocalMusicName=nil;
    LocalMusicLyr=[NSMutableArray array];
    paly=[[PlayerView alloc]init];
    
    for (int i=1; i<[paly getLocalMusic].count; i++) {
        if (i%2!=0) {
            [LocalMusicName addObject:[paly getLocalMusic][i] ];
        }
        else
            [LocalMusicLyr addObject:[paly getLocalMusic][i] ];
    }
    
    // 右侧消息按钮
    UIImage *leftImage = [[UIImage imageNamed:@"diandian"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(PlayAction:)];
    self.navigationItem.rightBarButtonItem = leftButtonItem;
    self.navigationItem.title=self.MusicName1[SongTags];
    [self.view addSubview:self.share.view];
    [self.view addSubview:self.myAllChapters.view];
    self.myAllChapters.view.alpha=0;
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notice:) name:AVPlayerItemPlaybackStalledNotification object:play.playerItem];
    // 视图布局
    [self setBack];
}

#pragma mark 移除操作
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"fenxiang111" object:nil];
}

///////////
//获取通知中心单例对象
-(IBAction)notice:(id)sender{
    cacheCtateOfPlay=YES;
}

#pragma mark 界面布局
- (void)setBack{
    [self.view addSubview:self.kj_imageView];
    [self.view addSubview:self.kj_nameLabel];
    [self.view addSubview:self.likeButton];
    [self.view addSubview:self.downloadButton];
    [self.view addSubview:self.shareButton];
    [self.view addSubview:self.nowTimeLabel];
    [self.view addSubview:self.pro];
    [self.view addSubview:self.playerSlider];
    [self.view addSubview:self.allTimeLabel];
    [self.view addSubview:self.roundButton];
    [self.view addSubview:self.upButton];
    [self.view addSubview:self.playButton];
    [self.view addSubview:self.downButton];
    [self.view addSubview:self.allButton];
    [self.view addSubview:self.roundLoopLabel];
    
}

- (UIView *)backView{
    if (!_backView) {
        CGFloat x = 0;
        CGFloat y = [UIScreen mainScreen].bounds.size.height-6*X+X/2;
        CGFloat w = [UIScreen mainScreen].bounds.size.width;
        CGFloat h = 6*X-X/2;
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.560];
        view.frame = CGRectMake(x,y,w,h);
        _backView = view;
    }
    return _backView;
}

- (UIImageView *)playerImageView{
    if (_playerImageView == nil) {
        CGFloat x = 0;
        CGFloat y = 0;
        CGFloat w = SCREEN_WIDTH;
        CGFloat h = SCREEN_HEIGHT;
        _playerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        UIImage *image  = [UIImage imageNamed:@"001_0000_7675119_085617932000_2"];
        _playerImageView.image = image;
    }
    return _playerImageView;
}
- (UIImageView *)kj_imageView{
    if (!_kj_imageView) {
        CGFloat x = X/2;
        CGFloat y = self.shareButton.frame.origin.y-2*X+X/3;
        CGFloat w = 3*X;
        CGFloat h = 3*X;
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(x, y, w, h);
        
        imageView.image = [UIImage imageNamed:@"1false.jpg"];
        
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        imageView.layer.borderWidth = 2;
        imageView.layer.cornerRadius = w/2;
        imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        _kj_imageView = imageView;
    }
    return _kj_imageView;
}
- (UILabel *)kj_nameLabel{
    if (!_kj_nameLabel) {
        CGFloat x = 4*X;
        CGFloat y = self.shareButton.frame.origin.y;
        CGFloat w = 5*X;
        CGFloat h = X;
        UILabel* label = [[UILabel alloc] init];
        label.frame = CGRectMake(x, y, w, h);
        label.backgroundColor = [UIColor clearColor]; // 背景颜色
        
        if (![_autorName isEqual:@""]) {
            label.text=_autorName[SongTags];
        }else
            label.text = @"新民社"; // 显示内容
        
        label.textColor = [UIColor whiteColor]; // 文字颜色
        _kj_nameLabel = label;
    }
    return _kj_nameLabel;
}

- (UIButton *)shareButton{
    if (_shareButton == nil) {
        CGFloat x = SCREEN_WIDTH-X-X/2;
        CGFloat y = self.playerSlider.frame.origin.y-2*X+X/3;
        CGFloat w = X;
        CGFloat h = X;
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareButton.frame = CGRectMake(x, y, w, h);
        UIImage *image = [[UIImage imageNamed:@"001_0000s_0000_share"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_shareButton setImage:image forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(Share:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}
- (UIButton *)downloadButton{
    if (_downloadButton == nil) {
        _downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat x = SCREEN_WIDTH-3*X-X/2;
        CGFloat y = self.shareButton.frame.origin.y;
        CGFloat w = X;
        CGFloat h = X;
        _downloadButton.frame = CGRectMake(x, y, w, h);
        UIImage *image = [[UIImage imageNamed:@"001_0000s_0001_Player_download"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_downloadButton setImage:image forState:UIControlStateNormal];
        [_downloadButton addTarget:self action:@selector(Download:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downloadButton;
}
- (UIButton *)likeButton{
    if (_likeButton == nil) {
        _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat x = SCREEN_WIDTH-5*X-X/2;
        CGFloat y = self.shareButton.frame.origin.y;
        CGFloat w = X;
        CGFloat h = X;
        _likeButton.frame = CGRectMake(x, y, w, h);
        
        UIImage *image = [[UIImage imageNamed:@"001_0000s_0003_102"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *image2 = [[UIImage imageNamed:@"001_0000s_0002_102-副本"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        // 是否添加到收藏(喜欢)里面
        if ([[UserDataModel defaultDataModel].userLikeBookID containsObject:_kj_IDArray[SongTags]]) {
            [_likeButton setImage:image2 forState:UIControlStateNormal];
            likeButton = 1;
        }
        else{
            [_likeButton setImage:image forState:UIControlStateNormal];
            likeButton = 0;
        }
        [_likeButton addTarget:self action:@selector(collection:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _likeButton;
}

-(UIImage*) OriginImage:(UIImage*)image scaleToSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);//size为CGSize类型，即你所需要的图片尺寸
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
    
}
- (UISlider *)playerSlider{
    if (_playerSlider == nil) {
        CGFloat x = 70;
        CGFloat y = SCREEN_HEIGHT-4*X+X/2;
        CGFloat w = SCREEN_WIDTH-140;
        CGFloat h = 20;
        _playerSlider = [[UISlider alloc]initWithFrame:CGRectMake(x, y, w, h)];
        UIImage *thumbImage = [UIImage imageNamed:@"Player_progress_bar"];
        UIImage *thumbImage1 = [UIImage imageNamed:@"001_0000_B副本"];
        [_playerSlider setMaximumTrackImage:thumbImage1 forState:UIControlStateNormal];
        [_playerSlider setThumbImage:[self OriginImage:thumbImage scaleToSize:CGSizeMake(13, 13)] forState:UIControlStateNormal];
        _playerSlider.value=0;
        _playerSlider.minimumValue=0;
        [_playerSlider addTarget:self action:@selector(adiustTime:) forControlEvents:UIControlEventValueChanged];
    }
    return _playerSlider;
}
- (UIProgressView *)pro{
    if (_pro == nil) {
        CGFloat x = 80;
        CGFloat y = SCREEN_HEIGHT-4*X+X/2+9;
        CGFloat w = SCREEN_WIDTH-150;
        CGFloat h = 20;
        _pro = [[UIProgressView alloc]initWithFrame:CGRectMake(x, y, w, h)];
        _pro.progress=0;
        _pro.progressTintColor=[UIColor colorWithRed:0.000 green:0.003 blue:0.621 alpha:1.000];
        
    }
    return _pro;
}


- (UILabel *)nowTimeLabel{
    if (_nowTimeLabel == nil) {
        CGFloat x = 10;
        CGFloat y = self.playerSlider.frame.origin.y;
        CGFloat w = 50;
        CGFloat h = 20;
        _nowTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
        _nowTimeLabel.text=@"00:00";
        _nowTimeLabel.textColor = [UIColor colorWithWhite:0.651 alpha:1.000];
        _nowTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nowTimeLabel;
}
- (UILabel *)allTimeLabel{
    if (_allTimeLabel == nil) {
        CGFloat x = SCREEN_WIDTH-60;
        CGFloat y = self.playerSlider.frame.origin.y;
        CGFloat w = 50;
        CGFloat h = 20;
        _allTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
        _allTimeLabel.text = @"00:00";
        _allTimeLabel.textColor = [UIColor colorWithWhite:0.651 alpha:1.000];
        _allTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _allTimeLabel;
}

- (UIButton *)roundButton{
    if (_roundButton == nil) {
        _roundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat x = X;
        CGFloat y = SCREEN_HEIGHT-2*X;
        CGFloat w = X;
        CGFloat h = X;
        _roundButton.frame = CGRectMake(x, y, w, h);
        UIImage *image = [[UIImage imageNamed:@"001_0000s_0004_110"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_roundButton setImage:image forState:UIControlStateNormal];
        [_roundButton addTarget:self action:@selector(Circulation:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _roundButton;
}

- (UILabel*)roundLoopLabel{
    if (!_roundLoopLabel) {
        _roundLoopLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0, X/2, X/2)];
        _roundLoopLabel.center =_roundButton.center;
        _roundLoopLabel.text = @" 1";
        [_roundLoopLabel setFont:[UIFont systemFontOfSize:13]];
        _roundLoopLabel.textColor = [UIColor whiteColor];
        _roundLoopLabel.alpha = 0;
    }
    return _roundLoopLabel;
}
- (UIButton *)upButton{
    if (_upButton == nil) {
        _upButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat x = 4*X;
        CGFloat y = self.roundButton.frame.origin.y;
        CGFloat w = X;
        CGFloat h = X;
        _upButton.frame = CGRectMake(x, y, w, h);
        UIImage *image = [[UIImage imageNamed:@"001_0000s_0006_组-3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_upButton setImage:image forState:UIControlStateNormal];
        [_upButton setImage:[self OriginImage:image scaleToSize:CGSizeMake(60, 60)] forState:UIControlStateNormal];
        [_upButton addTarget:self action:@selector(On:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _upButton;
}
- (UIButton *)playButton{
    if (_playButton == nil) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat x = 7*X;
        CGFloat y = self.roundButton.frame.origin.y-X/2;
        CGFloat w = 2*X;
        CGFloat h = 2*X;
        _playButton.frame = CGRectMake(x, y, w, h);
        UIImage *image = [[UIImage imageNamed:@"001_0000s_0009_组-5"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_playButton setImage:image forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(Player:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

- (UIButton *)downButton{
    if (_downButton == nil) {
        _downButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat x = 11*X;
        CGFloat y = self.roundButton.frame.origin.y;
        CGFloat w = X;
        CGFloat h = X;
        _downButton.frame = CGRectMake(x, y, w, h);
        UIImage *image = [[UIImage imageNamed:@"001_0000s_0007_组-4"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_downButton setImage:[self OriginImage:image scaleToSize:CGSizeMake(60, 60)] forState:UIControlStateNormal];
        [_downButton addTarget:self action:@selector(Follow:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downButton;
}
- (UIButton *)allButton{
    if (_allButton == nil) {
        _allButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _allButton.tag=1;
        CGFloat x = 14*X;
        CGFloat y = self.roundButton.frame.origin.y;
        CGFloat w = X;
        CGFloat h = X;
        _allButton.frame = CGRectMake(x, y, w, h);
        UIImage *image = [[UIImage imageNamed:@"001_0000s_0005_组-2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_allButton setImage:image forState:UIControlStateNormal];
        [_allButton addTarget:self action:@selector(myAllButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allButton;
}

-(IBAction)PlayAction:(id)sender{
    
}
-(IBAction)clackAllChapters:(NSNotification*)sender{
    NSInteger i=[[sender.userInfo valueForKey:@"buttonTag"] integerValue];
    CATransition *animation = [CATransition animation];
    animation.duration = 1.0;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"oglFlip";
    animation.subtype = kCATransitionFromLeft;
    [self.myAllChapters.view.layer addAnimation:animation forKey:nil];
    self.myAllChapters.view.alpha=0;
    _allButton.tag=1;
    SongTags=i;
    [self MyTitle:self.MusicName1[i]];
    for (int i=0;i<VoicelessSoundMusic.count;i++) {
        NSInteger name=[VoicelessSoundMusic[i] integerValue];
        if (name==SongTags){
            //发现本书下一章节没有声音
            NSDictionary *ClackTag= @{@"ChangeState":@"silent",@"ChangeName":@(name)};
            //创建一个消息对象
            NSNotification * notice = [NSNotification notificationWithName:@"ChaptersState" object:nil userInfo:ClackTag];
            //发送消息
            [[NSNotificationCenter defaultCenter]postNotification:notice];
            return;
        };
    }
    [self plays];
    [self SplitLyrics];
}

-(UITableViewController*)myAllChapters{
    if (!_myAllChapters) {
        _myAllChapters=[[allChapters alloc]initWithStyle:UITableViewStylePlain];
        _myAllChapters.view.frame=CGRectMake(SCREEN_WIDTH/6, SCREEN_HEIGHT/5, SCREEN_WIDTH-SCREEN_WIDTH/3, SCREEN_HEIGHT/2);
    }
    return _myAllChapters;
}
#pragma mark 当前歌名
-(void)MyTitle:(NSString *)name{
    self.navigationItem.title=name;
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
        rank.text=@"—————————————————————————————————";
        rank.textColor=[UIColor colorWithWhite:0.283 alpha:0.500];
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
    [UIView transitionWithView:self.LocalMusic duration:0.5 options:0 animations:^{
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

#pragma mark 歌词部分
-(UIView*)LyricsInterface{
    if (!_LyricsInterface) {
        CGFloat x = 0;
        CGFloat y = 0;
        CGFloat w = SCREEN_WIDTH;
        _LyricsInterface=[[UIView alloc]initWithFrame:CGRectMake(x, y, w, [self modelHeight:3])];
        _LyricsInterface.backgroundColor=[UIColor colorWithRed:0.913 green:0.932 blue:0.683 alpha:0];
        [LyricsViewController shareObject].view.frame=CGRectMake(x, 64, w,[self modelHeight:3]-64);
        [_LyricsInterface addSubview:[LyricsViewController shareObject].view];
    }
    return _LyricsInterface;
}

-(void)SplitLyrics{
    //分割歌词
    LyrucsTima=[[NSMutableArray alloc]init];
    LyrucsArray=[[NSMutableArray alloc]init];
    if(![self.MusicLyr[SongTags] isEqual:nil]){
        NSArray *sepArray=[self.MusicLyr[SongTags] componentsSeparatedByString:@"["];
        NSArray *lineArray;
        for(int i=0;i<sepArray.count;i++){
            if([sepArray[i] length]>0){
                lineArray=[sepArray[i] componentsSeparatedByString:@"]"];
                if(![lineArray[0] isEqualToString:@"\n"]){
                    [LyrucsTima addObject:lineArray[0]];
                    [LyrucsArray addObject:lineArray.count>1?lineArray[1]:@""];
                }
            }
        }
    }
    [LyricsViewController shareObject].Lyr = LyrucsArray;
    self.PalyerLyr=LyrucsArray[0];
}
-(void)SplitLyricsLocal{
    //分割歌词
    LyrucsTima=[[NSMutableArray alloc]init];
    LyrucsArray=[[NSMutableArray alloc]init];
    if(![self.localMusicLyr isEqual:nil]){
        NSArray *sepArray=[self.localMusicLyr componentsSeparatedByString:@"["];
        NSArray *lineArray;
        for(int i=0;i<sepArray.count;i++){
            if([sepArray[i] length]>0){
                lineArray=[sepArray[i] componentsSeparatedByString:@"]"];
                if(![lineArray[0] isEqualToString:@"\n"]){
                    [LyrucsTima addObject:lineArray[0]];
                    [LyrucsArray addObject:lineArray.count>1?lineArray[1]:@""];
                }
            }
        }
    }
    [LyricsViewController shareObject].Lyr = LyrucsArray;
    self.PalyerLyr=LyrucsArray[0];
}

#pragma mark 划动显示歌单
-(IBAction)SingleScreen:(id)sender{
    NSLog(@"单击了屏幕");
    [UIView transitionWithView:self.LocalMusic duration:0.5 options:0 animations:^{
        self.LocalMusic.center=CGPointMake(SCREEN_WIDTH+SCREEN_WIDTH/2, [self modelHeight:2]);
    } completion:nil];
}
-(IBAction)LocalMusic:(UISwipeGestureRecognizer*)sender{
    [UIView transitionWithView:self.LocalMusic duration:0.5 options:0 animations:^{
        self.LocalMusic.center=CGPointMake(SCREEN_WIDTH/2+SCREEN_WIDTH/4,[self modelHeight:2]);
    } completion:nil];
}
-(CGFloat)modelHeight:(NSInteger)a{
    if (SCREEN_HEIGHT<667&&SCREEN_HEIGHT >=568) {
        switch (a) {
            case 1:
                return self.playerSlider.frame.origin.y-103;
                break;
            case 2:
                return (self.playerSlider.frame.origin.y+22)/2;
                break;
            case 3 :
                return self.playerSlider.frame.origin.y-40;
                break;
        }
    }
    else if (SCREEN_HEIGHT<736&&SCREEN_HEIGHT >=667) {
        switch (a) {
            case 1:
                return self.playerSlider.frame.origin.y-110;
                break;
            case 2:
                return (self.playerSlider.frame.origin.y+18)/2;
                break;
            case 3 :
                return self.playerSlider.frame.origin.y-50;
                break;
        }
    }else if (SCREEN_HEIGHT==736) {
        switch (a) {
            case 1:
                return self.playerSlider.frame.origin.y-115;
                break;
            case 2:
                return (self.playerSlider.frame.origin.y+13)/2;
            case 3 :
                return self.playerSlider.frame.origin.y-60;
                break;
                
        }
        
    }
    return 0;
}
-(UIView*)LocalMusic{
    if (!_LocalMusic) {
        CGFloat x = SCREEN_WIDTH;
        CGFloat y = 64;
        CGFloat w = SCREEN_WIDTH-SCREEN_WIDTH/7;
        _LocalMusic=[[UIView alloc]initWithFrame:CGRectMake(x, y, w,[self modelHeight:1])];
        _LocalMusic.center=CGPointMake(SCREEN_WIDTH+SCREEN_WIDTH/2,[self modelHeight:2]);
        _LocalMusic.backgroundColor=[UIColor colorWithRed:0.587 green:0.380 blue:1.000 alpha:0.50];
    }
    return _LocalMusic;
}
#pragma mark 播放状态
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    //监听发生变化调用
    if ([object isKindOfClass:[PlayerSupport class]]) {
        PlayerSupport *paly1=object;
        if ([paly1.status isEqualToString:@"1"]) {
            playProgresTimer =  [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(PlayProgressTimer) userInfo:nil repeats:YES];
        }
        else{
            NSLog(@"播放失败");
        }
    }
}

#pragma mark 计时器，用来显示下载进度和当前播放进度
-(void)PlayProgressTimer{
    _playerSlider.value=[play getPlayProgress];//播放进度
    _nowTimeLabel.text                                                     =[play getAllMusicTime];
    _allTimeLabel.text=[play getNowMisocTime];
    _pro.progress=[play getDownloadProgress];
    [self playButtonPress];
    if (cacheCtateOfPlay) {
        if (_pro.progress>(_playerSlider.value+0.1)||_pro.progress>=1) {
            [play Myplay];
            cacheCtateOfPlay=NO;
        }
    }
    for (int i=0; i<LyrucsTima.count; i++) {
        if ([LyrucsTima[i] isEqual: [play getAllMusicTime]]) {
            [LyricsViewController shareObject].LyrTamin=i;
            PositionLyrics=i;
            self.PalyerLyr=LyrucsArray[i];
            break;
        }
    }
}
#pragma mark 循环状态
- (IBAction)Circulation:(UIButton*)sender {
    //状态1：随机播放 状态2：单曲循环
    if (StatePlay==1){
        SongOrderStatus=1;
        _roundLoopLabel.alpha = 0;
        StatePlay=2;
    }
    else{
        SongOrderStatus=0;
        _roundLoopLabel.alpha = 1;
        StatePlay=1;
    }
}
#pragma mark 上一首
- (IBAction)On:(UIButton *)sender {
    if (self.MusicName1.count==SongTags) {
        //章节播放完成，
        NSDictionary *ClackTag= @{@"ChangeState":@"complete",@"buttonTag":@(SongTags)};
        //创建一个消息对象
        NSNotification * notice = [NSNotification notificationWithName:@"ChaptersState" object:nil userInfo:ClackTag];
        //发送消息
        [[NSNotificationCenter defaultCenter]postNotification:notice];
        return;
    }
    for (int i=0;i<VoicelessSoundMusic.count;i++) {
        NSInteger name=[VoicelessSoundMusic[i] integerValue];
        if (name==SongTags-1){
            //发现本书下一章节没有声音
            NSDictionary *ClackTag= @{@"ChangeState":@"silent",@"ChangeName":@(name)};
            //创建一个消息对象
            NSNotification * notice = [NSNotification notificationWithName:@"ChaptersState" object:nil userInfo:ClackTag];
            //发送消息
            [[NSNotificationCenter defaultCenter]postNotification:notice];
            return;
        };
    }
    
    statePlay1=0;
    
    [_playButton setImage:pauseImage forState:UIControlStateNormal];
    if (self.MusicName1.count>0) {
        StatePlayButton=1;
        if (SongTags==0) {
            [self plays];
        }else{
            --SongTags;
            [self plays];
        }
        [self MyTitle:self.MusicName1[SongTags]];
        [self SplitLyrics];
    }else if (LocalMusicName.count>0) {
        StatePlayButton=1;
        if (SongTags==0) {
            play.playerLocalMusic=LocalMusicName[0];
            self.MusicLyr=LocalMusicLyr[0];
            [self MyTitle:LocalMusicName[0]];
        }else{
            play.playerLocalMusic=LocalMusicName[--SongTags];
        }
        
        [self MyTitle:LocalMusicName[SongTags]];
        self.localMusicLyr=LocalMusicLyr[SongTags];
        [self SplitLyricsLocal];
        
    }
    else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"没有可以播放的书籍" message:@"请到文集中选择" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"防SB模式开启");
        }];
        [alertController addAction:action1];
        [self presentViewController:alertController animated:YES completion:NULL];
    }
    
}

#pragma mark 下一首
- (IBAction)Follow:(id)sender {
    if (self.MusicName1.count-1==SongTags) {
        //章节播放完成，
        NSDictionary *ClackTag= @{@"ChangeState":@"complete",@"buttonTag":@(SongTags)};
        //创建一个消息对象
        NSNotification * notice = [NSNotification notificationWithName:@"ChaptersState" object:nil userInfo:ClackTag];
        //发送消息
        [[NSNotificationCenter defaultCenter]postNotification:notice];
        return;
    }
    
    for (int i=0;i<VoicelessSoundMusic.count;i++) {
        NSInteger name=[VoicelessSoundMusic[i] integerValue];
        if (name==(SongTags+1)){
            //发现本书下一章节没有声音
            NSDictionary *ClackTag= @{@"ChangeState":@"silent",@"ChangeName":@(name)};
            //创建一个消息对象
            NSNotification * notice = [NSNotification notificationWithName:@"ChaptersState" object:nil userInfo:ClackTag];
            //发送消息
            [[NSNotificationCenter defaultCenter]postNotification:notice];
            return;
        };
    }
    
    statePlay1=0;
    
    [_playButton setImage:pauseImage forState:UIControlStateNormal];
    if (self.MusicName1.count>0) {
        StatePlayButton=1;
        if (++SongTags>=self.MusicName1.count) {
            SongTags=0;
            [self plays];
        }else{
            [self plays];
        }
        [self MyTitle:self.MusicName1[SongTags]];
        [self SplitLyrics];
    }else if(LocalMusicName.count>0){
        StatePlayButton=1;
        if (SongTags>=LocalMusicName.count-1) {
            SongTags=0;
            play.playerLocalMusic=LocalMusicName[0];
            self.MusicLyr=LocalMusicLyr[0];
            [self MyTitle:LocalMusicName[0]];
        }else{
            play.playerLocalMusic=LocalMusicName[++SongTags];
        }
        [self MyTitle:LocalMusicName[SongTags]];
        self.localMusicLyr=LocalMusicLyr[SongTags];
        [self SplitLyricsLocal];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"没有可以播放的书籍" message:@"请到文集中选择" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"防SB模式开启");
        }];
        [alertController addAction:action1];
        [self presentViewController:alertController animated:YES completion:NULL];
    }
    
}
-(int)ClickPalyer{
    [self Player:self.playButton];
    return StatePlayButton;
}
#pragma mark 点击播放
- (IBAction)Player:(UIButton *)sender {
    PositionLyrics=1;
    if (StatePlayButton==1) {
        if (statePlay1==1) {
            [_playButton setImage:pauseImage forState:UIControlStateNormal];
            statePlay1=0;
        }
        else{
            [_playButton setImage:playImage forState:UIControlStateNormal];
            statePlay1=1;
        }
        [play Suspended];
        StatePlayButton=0;
        self.PalyerState=0;
    }
    else{
        if (self.MusicURL!=nil) {
            if (statePlay1==1) {
                [_playButton setImage:pauseImage forState:UIControlStateNormal];
                statePlay1=0;
            }
            else{
                [_playButton setImage:playImage forState:UIControlStateNormal];
                statePlay1=1;
            }
            [play Myplay];
            StatePlayButton=1;
        }
        else if(LocalMusicName.count>0){
            if (statePlay1==1) {
                [_playButton setImage:pauseImage forState:UIControlStateNormal];
                statePlay1=0;
            }
            else{
                [_playButton setImage:playImage forState:UIControlStateNormal];
                statePlay1=1;
            }
            [play Myplay];
            StatePlayButton=1;
            play.playerLocalMusic=LocalMusicName[0];
            [self MyTitle:LocalMusicName[0]];
            self.localMusicLyr=LocalMusicLyr[0];
            [self SplitLyricsLocal];
            self.MusicURL[SongTags]=@"1";
            StatePlayButton=1;
            self.PalyerState=1;
        }
        else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"没有可以播放的书籍" message:@"请到文集中选择" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"防SB模式开启");
            }];
            [alertController addAction:action1];
            [self presentViewController:alertController animated:YES completion:NULL];
        }
    }
    if (_MusicName1==nil){
        if (LocalMusicName==nil) {
            self.PalyerName=LocalMusicName[SongTags];
        }
    }
    else
        self.PalyerName=_MusicName1[SongTags];
}
#pragma mark 下载按钮
- (IBAction)Download:(UIButton *)sender {
    if (self.MusicURL!=nil&&![self.MusicURL isEqual:@"1"]) {
        [play DownloadMusic:self.MusicURL[SongTags] DownName:self.MusicName1[SongTags]];
        
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"没有可以下载的书籍" message:@"请到文集中选择" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"防SB模式开启");
        }];
        [alertController addAction:action1];
        [self presentViewController:alertController animated:YES completion:NULL];
    }
    
}
-(IBAction)myAllButton:(UIButton*)sender{
    if (self.MusicName1!=nil) {
        if (sender.tag==1) {
            CATransition *animation = [CATransition animation];
            animation.duration = 1.0;
            animation.timingFunction = UIViewAnimationCurveEaseInOut;
            animation.type = @"oglFlip";
            animation.subtype = kCATransitionFromLeft;
            [self.myAllChapters.view.layer addAnimation:animation forKey:nil];
            self.myAllChapters.view.alpha=1;
            sender.tag=0;
        }else{
            CATransition *animation = [CATransition animation];
            animation.duration = 1.0;
            animation.timingFunction = UIViewAnimationCurveEaseInOut;
            animation.type = @"oglFlip";
            animation.subtype = kCATransitionFromLeft;
            [self.myAllChapters.view.layer addAnimation:animation forKey:nil];
            self.myAllChapters.view.alpha=0;
            sender.tag=1;
            
        }
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"你还没有选择文集" message:@"请到文集中选择或者阅读本地文集" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"防SB模式开启");
        }];
        [alertController addAction:action1];
        [self presentViewController:alertController animated:YES completion:NULL];
    }
}
#pragma mark 下载完成
-(void)DownloadComplete:(NSString*)name{
    if([paly setLocelMusic:name lyrics:self.MusicLyr[SongTags]]){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"书籍:《%@》下载成功",name] message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"防SB模式开启");
        }];
        [alertController addAction:action1];
        [self presentViewController:alertController animated:YES completion:NULL];
        [LocalMusicName addObject:name];
        [LocalMusicLyr addObject:self.MusicLyr[SongTags]];
        [_LocalMusicTable reloadData];
    }
    else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"书籍:《%@》以存在",name] message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"防SB模式开启");
        }];
        [alertController addAction:action1];
        [self presentViewController:alertController animated:YES completion:NULL];
    }
}
#pragma mark 播放
-(void)plays{
    
    // 分享
    NSString *shareText = [NSString stringWithFormat:@"%@--%@",_MusicName1[SongTags],self.autorName[SongTags]];
    _share.Content = shareText; // 分享内容（详情）
    UMSocialUrlResource *aa = [[UMSocialUrlResource alloc]initWithSnsResourceType:UMSocialUrlResourceTypeMusic url:_MusicURL[SongTags]]; // 音频
    _share.UrlResource = aa; // 分享网址
    
    if (![self.autorName[SongTags] isEqualToString:@""]) {
        self.kj_nameLabel.text= self.autorName[SongTags];
    }else
        self.kj_nameLabel.text=@"新民社";
    play.playerURLMusic=self.MusicURL[SongTags];
    [play Myplay];
    self.PalyerName=_MusicName1[SongTags];
}

#pragma mark 播放完成
-(void)JudgePlayer:(BOOL)State{
    NSLog(@"播放完成了");
    PositionLyrics=1;
    if (SongOrderStatus==0) {//单曲循环
        [self MyTitle:self.MusicName1[SongTags]];
        [self SplitLyrics];
        [self plays];
        return;
    }
    statePlay1=1;
    [_playButton setImage:pauseImage forState:UIControlStateNormal];
    if (State) {
        if (self.MusicName1.count>0) {
            if (self.MusicName1.count-1==SongTags) {
                //章节播放完成，
                NSDictionary *ClackTag= @{@"ChangeState":@"complete",@"buttonTag":@(SongTags)};
                //创建一个消息对象
                NSNotification * notice = [NSNotification notificationWithName:@"ChaptersState" object:nil userInfo:ClackTag];
                //发送消息
                [[NSNotificationCenter defaultCenter]postNotification:notice];
                return;
            }
            
            for (int i=0;i<VoicelessSoundMusic.count;i++) {
                NSInteger name=[VoicelessSoundMusic[i] integerValue];
                if (name==(SongTags+1)){
                    //发现本书下一章节没有声音
                    NSDictionary *ClackTag= @{@"ChangeState":@"silent",@"ChangeName":@(name)};
                    //创建一个消息对象
                    NSNotification * notice = [NSNotification notificationWithName:@"ChaptersState" object:nil userInfo:ClackTag];
                    //发送消息
                    [[NSNotificationCenter defaultCenter]postNotification:notice];
                    return;
                };
            }
            if (SongTags>=self.MusicName1.count-1) {
                SongTags=0;
                [self MyTitle:self.MusicName1[0]];
                [self SplitLyrics];
                [self plays];
            }else{
                [self MyTitle:self.MusicName1[++SongTags]];
                [self SplitLyrics];
                [self plays];
            }
        }
        else{
            if (SongTags>=LocalMusicName.count-1) {
                SongTags=0;
                play.playerLocalMusic=LocalMusicName[SongTags];
                [self MyTitle:LocalMusicName[SongTags]];
                self.localMusicLyr=LocalMusicLyr[SongTags];
                [self SplitLyricsLocal];
            }else{
                play.playerLocalMusic=LocalMusicName[++SongTags];
                [self MyTitle:LocalMusicName[SongTags]];
                self.localMusicLyr=LocalMusicLyr[SongTags];
                [self SplitLyricsLocal];}
        }
    }
}
#pragma mark 传入端口，用于播放音乐
-(void)PalyerMusicURL:(NSMutableArray<theIncomingDataModel*>*)DataModel WhetherTheAudio:(NSMutableArray*)Audio{
    _MusicName1=[NSMutableArray array];
    _MusicURL=[NSMutableArray array];
    _MusicLyr=[NSMutableArray array];
    _kj_IDArray = [NSMutableArray new];
    _autorName = [NSMutableArray new];
    VoicelessSoundMusic=Audio;//5分地
    StatePlayButton=1;
    for (theIncomingDataModel *IncomingDataModel in DataModel) {
        [self.MusicName1 addObject:IncomingDataModel.chapterName];
        [self.MusicURL addObject:IncomingDataModel.chapterUrl];
        [self.MusicLyr addObject:IncomingDataModel.chapterLrc];
        self.imageUrl = IncomingDataModel.kj_imageUrl;
        [self.autorName addObject:IncomingDataModel.kj_autorName];
        [self.kj_IDArray addObject:IncomingDataModel.chapterID];
    }
    UIImage *image = [[UIImage imageNamed:@"001_0000s_0003_102"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *image2 = [[UIImage imageNamed:@"001_0000s_0002_102-副本"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 是否添加到收藏(喜欢)里面
    if ([[UserDataModel defaultDataModel].userLikeBookID containsObject:_kj_IDArray[SongTags]]) {
        [_likeButton setImage:image2 forState:UIControlStateNormal];
        likeButton = 1;
    }
    else{
        [_likeButton setImage:image forState:UIControlStateNormal];
        likeButton = 0;
    }
    
    if (![self.imageUrl isEqualToString:@""]) {
        NSURL *url = [NSURL URLWithString:_imageUrl];
        [self.kj_imageView sd_setImageWithURL:url];
        self.PalyerImage=_imageUrl;
    }
    // 后台执行：
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_imageUrl]];
        authorPortraits=[UIImage imageWithData:data];
    });
    _myAllChapters.sectionName=self.MusicName1;
    theIncomingDataModel *TheFirstOne=DataModel[0];
    SongTags=TheFirstOne.ClackTag;
    [self MyTitle:DataModel[SongTags].chapterName];
    [self plays];
    [self SplitLyrics];
}
-(void)MusicURL:(NSMutableArray<theIncomingDataModel*>*)DataModel WhetherTheAudio:(NSMutableArray*)Audio{
    _MusicName1=[NSMutableArray array];
    _MusicURL=[NSMutableArray array];
    _MusicLyr=[NSMutableArray array];
    _kj_IDArray = [NSMutableArray new];
    VoicelessSoundMusic=Audio;//5分地
    StatePlayButton=0;
    for (theIncomingDataModel *IncomingDataModel in DataModel) {
        [self.MusicName1 addObject:IncomingDataModel.chapterName];
        [self.MusicURL addObject:IncomingDataModel.chapterUrl];
        [self.MusicLyr addObject:IncomingDataModel.chapterLrc];
        [self.kj_IDArray addObject:IncomingDataModel.chapterID];
    }
    
    UIImage *image = [[UIImage imageNamed:@"001_0000s_0003_102"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *image2 = [[UIImage imageNamed:@"001_0000s_0002_102-副本"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 是否添加到收藏(喜欢)里面
    if ([[UserDataModel defaultDataModel].userLikeBookID containsObject:_kj_IDArray[SongTags]]) {
        [_likeButton setImage:image2 forState:UIControlStateNormal];
        likeButton = 1;
    }
    else{
        [_likeButton setImage:image forState:UIControlStateNormal];
        likeButton = 0;
    }
    
    if (_mp3Url!=nil) {
        NSURL *url = [NSURL URLWithString:_mp3Url];
        [self.kj_imageView sd_setImageWithURL:url];
    }
    
    NSLog(@"播放时候的mp3数据:%@", _MusicURL);
    _myAllChapters.sectionName=self.MusicName1;
    theIncomingDataModel *TheFirstOne=DataModel[0];
    SongTags=TheFirstOne.ClackTag;
    [self MyTitle:DataModel[SongTags].chapterName];
}
#pragma mark 拖动时间
-(void)setTmin:(CMTime)time{
    [play nowToTime:time];
}
#pragma mark 收藏
- (IBAction)collection:(UIButton *)sender {
    NSLog(@"点击了收藏");
    // 提示成功
    if (_kj_IDArray==nil) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"没有可以收藏的文集" message:@"请到文集中选择收藏" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"防SB模式开启");
        }];
        [alertController addAction:action1];
        [self presentViewController:alertController animated:YES completion:NULL];
        return;
    }
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    if (likeButton == 1) {
        likeButton=0;
        [[UserDataModel defaultDataModel] deleteLikeBookID:_kj_IDArray[SongTags]];
        [self performSelector:@selector(closeLikeSuccess) withObject:nil afterDelay:0.3f];
    }else if (likeButton==0){
        likeButton=1;
        [[UserDataModel defaultDataModel] addLikeBookID:_kj_IDArray[SongTags]];
        [self performSelector:@selector(likeSuccess) withObject:nil afterDelay:0.3f];
    }
}

- (void)closeLikeSuccess {
    [SVProgressHUD showSuccessWithStatus:@"取消喜欢!"];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.5f];
    UIImage *image = [[UIImage imageNamed:@"001_0000s_0003_102"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_likeButton setImage:image forState:UIControlStateNormal];
}
- (void)likeSuccess {
    [SVProgressHUD showSuccessWithStatus:@"加入我喜欢成功!"];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.5f];
    UIImage *image = [[UIImage imageNamed:@"001_0000s_0002_102-副本"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_likeButton setImage:image forState:UIControlStateNormal];
}

- (void)dismiss {
    [SVProgressHUD dismiss];
}

#pragma mark 更改时间
- (IBAction)adiustTime:(UISlider *)sender {
    CMTime firstframe=CMTimeMake(([play getPlayTime]*sender.value), 1);
    [self setTmin:firstframe];
}
#pragma mark 歌单列表
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return LocalMusicName.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.backgroundColor = [UIColor colorWithWhite:0.603 alpha:0];
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.textLabel.text = LocalMusicName[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    statePlay1=0;
    [_playButton setImage:pauseImage forState:UIControlStateNormal];
    StatePlayButton=1;
    SongTags=(int)indexPath.row;
    play.playerLocalMusic=LocalMusicName[indexPath.row];
    [self MyTitle:LocalMusicName[indexPath.row]];
    self.localMusicLyr=LocalMusicLyr[indexPath.row];
    [self SplitLyricsLocal];
    self.PalyerName=LocalMusicName[SongTags];
}
-(void)setEditing:(BOOL)editing animated:(BOOL)animated{//设置是否显示一个可编辑视图的视图控制器。
    [super setEditing:editing animated:animated];
    [self.LocalMusicTable setEditing:editing animated:animated];//切换接收者的进入和退出编辑模式。
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{//请求数据源提交的插入或删除指定行接收者。
    if (editingStyle ==UITableViewCellEditingStyleDelete) {//如果编辑样式为删除样式
        if (indexPath.row<[LocalMusicName count]) {
            [paly deleteMusic:LocalMusicName[indexPath.row]];//移除本地存储的目录源
            [self deleteFile:LocalMusicName[indexPath.row]];//移除沙河下的源文件文件
            [LocalMusicName removeObjectAtIndex:indexPath.row];//移除数据源的数据
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];//移除tableView中的数据
        }
    }
}
-(void)deleteFile:(NSString*)name {
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //文件名
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",name]];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (!blHave) {
        NSLog(@"没有发现文件");
        return ;
    }else {
        NSLog(@"发现沙河下的文件");
        BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
        if (blDele) {
            NSLog(@"删除成功");
        }else {
            NSLog(@"删除失败");
        }
        
    }
}
- (BOOL)canBecomeFirstResponder
{
    return YES;
}
//重写父类方法，接受外部事件的处理
- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        switch (receivedEvent.subtype) {
                
            case UIEventSubtypeRemoteControlTogglePlayPause:
                NSLog(@"点击了播放");
                // [self playAndStopSong:self.playButton];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                NSLog(@"1");//上一首
                //  [self playLastButton:self.lastButton];
                [self On:self.upButton];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                NSLog(@"2");//下一首
                // [self playNextSong:self.nextButton];
                [self Follow:self.downButton];
                break;
            case UIEventSubtypeRemoteControlPlay:
                NSLog(@"3");//播放
                //[self playAndStopSong:self.playButton];
                [self Player:self.playButton];
                break;
            case UIEventSubtypeRemoteControlPause:
                NSLog(@"4");//
                // [self playAndStopSong:self.playButton];
                [self Player:self.playButton];
                break;
            default:
                break;
        }
    }
}
- (void)playButtonPress{
    Class playingInfoCenter = NSClassFromString(@"MPNowPlayingInfoCenter");
    if (playingInfoCenter) {
        NSMutableDictionary *songInfo = [ [NSMutableDictionary alloc] init];
        MPMediaItemArtwork *albumArt;
        if (authorPortraits!=nil) {
            albumArt = [ [MPMediaItemArtwork alloc] initWithImage: authorPortraits];
        }else{
            albumArt = [ [MPMediaItemArtwork alloc] initWithImage: [UIImage imageNamed:@"12345@2x.jpg"]];
        }
        if (self.MusicName1!=nil) {
            [ songInfo setObject:self.MusicName1[SongTags]forKey:MPMediaItemPropertyTitle ];
        }else{
            [ songInfo setObject:LocalMusicName[SongTags]forKey:MPMediaItemPropertyTitle ];
        }
        
        [ songInfo setObject:LyrucsArray[PositionLyrics] forKey:MPMediaItemPropertyArtist ];
        [ songInfo setObject: albumArt forKey:MPMediaItemPropertyArtwork ];
        //音乐剩余时长
        [songInfo setObject:[NSNumber numberWithDouble:[play getNowIntMisocTime]] forKey:MPMediaItemPropertyPlaybackDuration];
        //音乐当前播放时间 在计时器中修改
        [songInfo setObject:[NSNumber numberWithDouble:[play getAllIntMusicTime]] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
        [ [MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo ];
    }
}
@end










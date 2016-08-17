//
//  SecionManageView.m
//  XinMinClub
//
//  Created by 赵劲松 on 16/4/14.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "SectionManageView.h"
#import "UserDataModel.h"
#import "DataModel.h"
#import "DownloadModule.h"
#import "ShareViewController.h"

@interface SectionManageView () {
    CGRect selfFrame_;
    UserDataModel *userModel_;
    DataModel *dataModel_;
    DownloadModule *downloadMoudle_;
    NSInteger shareClickNum; // 监听分享button在点击了腾讯微博分享的状态
    
    UIControl *smBackView_;
    
    NSInteger kj_sharekaiguan;// 分享开关
    UIViewController *vc;
}
@property(nonatomic,strong)ShareViewController *share;//分享

@property (nonatomic, strong) UIButton *downloadButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *fuckButton;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation SectionManageView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        userModel_ = [UserDataModel defaultDataModel];
        dataModel_ = [DataModel defaultDataModel];
        [self addSubview:self.likeButton];
        [self addSubview:self.cancelButton];
        [self addSubview:self.downloadButton];
        [self addSubview:self.fuckButton];
        [self addSubview:self.titleLabel];
        
        shareClickNum = 0;
        kj_sharekaiguan=0;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareButClick1:) name:@"closeShare" object:nil];
    }
    return self;
}

- (void)setData:(SectionData *)data {
    _data = data;
    self.titleLabel.text = data.sectionName;
    if (_data.isLike) {
        _likeButton.enabled = NO;
    }
    if (_data.isDownload) {
        _downloadButton.enabled = NO;
    }
    if ([dataModel_.downloadingSections containsObject:data]) {
        _downloadButton.enabled = NO;
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        CGFloat x = -1;
        CGFloat y = -1;
        CGFloat w = [UIScreen mainScreen].bounds.size.width + 2;
        CGFloat h = 30;
        UILabel* label = [[UILabel alloc] init];
        label.frame = CGRectMake(x, y, w, h);
        label.backgroundColor = [UIColor clearColor]; // 背景颜色
//        label.text = @"第N章"; // 显示内容
        [label setFont:[UIFont systemFontOfSize:14]];
        label.textColor = DEFAULT_COLOR; // 文字颜色
//        [label roundedRectWithConerRadius:0 BorderWidth:1 borderColor:[UIColor colorWithWhite:0.847 alpha:1.000]];
        //        label.lineBreakMode = NSLineBreakByTruncatingTail; // 显示不下的时候尾部用...表示
        //        label.font = [UIFont systemFontOfSize:14.0f]; // 字体大小
        //        label.textAlignment = NSTextAlignmentCenter; // 设置文本对齐方式 中间对齐
        //        label.userInteractionEnabled = NO; // 让label支持触摸事件
        //        label.numberOfLines = 1; // 显示行数
        //        label.shadowColor = [UIColor grayColor]; // 文本阴影颜色
        //        label.shadowOffset = CGSizeMake(0, -1); // 偏移距离(阴影)
        //        label.highlighted = YES; //是否高亮显示
        //        label.layer.masksToBounds = YES; // 显示边框
        //        label.layer.cornerRadius = 5.0f; // 圆角半径
        //        label.layer.borderColor = [[UIColor grayColor] CGColor]; // 边框颜色
        //        label.layer.borderWidth = 1.0f; // 边框尺寸
        //        label.adjustsFontSizeToFitWidth = YES; //设置字体大小适应label宽度
        //        label.enabled = NO; // 文本是否可变
        
        _titleLabel = label;
    }
    return _titleLabel;
}


- (UIButton *)likeButton {
    if (!_likeButton) {
        _likeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _likeButton.frame = CGRectMake((SCREEN_WIDTH - 3 * 40) / 3, 30, 40, 40);
        _likeButton.backgroundColor = [UIColor clearColor];
        [_likeButton setTitle:@"喜欢" forState:UIControlStateNormal];
        [_likeButton setTintColor:DEFAULT_COLOR];
        [_likeButton addTarget:self action:@selector(likeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _likeButton;
}

- (UIButton *)downloadButton {
    if (!_downloadButton) {
        _downloadButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _downloadButton.frame = CGRectMake((SCREEN_WIDTH - 3 * 40) / 3 * 2, 30, 40, 40);
        _downloadButton.backgroundColor = [UIColor clearColor];
        [_downloadButton setTitle:@"下载" forState:UIControlStateNormal];
        [_downloadButton setTintColor:DEFAULT_COLOR];
        [_downloadButton addTarget:self action:@selector(downloadAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downloadButton;
}

- (UIButton *)fuckButton {
    if (!_fuckButton) {
        _fuckButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _fuckButton.frame = CGRectMake((SCREEN_WIDTH - 3 * 40) / 3 * 3, 30, 40, 40);
        _fuckButton.backgroundColor = [UIColor clearColor];
        [_fuckButton setTintColor:DEFAULT_COLOR];
        [_fuckButton setTitle:@"分享" forState:UIControlStateNormal];
        [_fuckButton addTarget:self action:@selector(fuckAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fuckButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _cancelButton.frame = CGRectMake(-1, SCREEN_HEIGHT / 6 - 35 , SCREEN_WIDTH + 1, 35 + 1);
        _cancelButton.backgroundColor = [UIColor whiteColor];
        [_cancelButton setTintColor:[UIColor colorWithWhite:0.796 alpha:1.000]];
        [_cancelButton roundedRectWithConerRadius:0 BorderWidth:1 borderColor:[UIColor colorWithWhite:0.847 alpha:1.000]];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

#pragma mark Actions

- (void)backTap {
    if (shareClickNum != 0) {
        [UIView transitionWithView:self.share.view duration:0.4 options:0 animations:^{
            _share.view.center = CGPointMake(SCREEN_WIDTH/2,2*SCREEN_HEIGHT);
            _share.view.alpha = 0;
        } completion:nil];
    }
    smBackView_.hidden = YES;
    [UIView transitionWithView:self.share.view duration:0.4 options:0 animations:^{
        _share.view.center = CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT+SCREEN_HEIGHT/4);
        _share.view.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView transitionWithView:self duration:0.3 options:0 animations:^{
            self.alpha = 1;
        } completion:nil];
    }];
}

- (void)cancelAction {
    [_delegate cacenl];
}

- (void)fuckAction {
    [UIView transitionWithView:self duration:0.3 options:0 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (shareClickNum != 0) {
            _share.view.center = CGPointMake(SCREEN_WIDTH/2,2*SCREEN_HEIGHT - 60);
        }
        [UIView transitionWithView:self.share.view duration:0.4 options:0 animations:^{
            _share.view.alpha = 1.0;
            smBackView_.hidden = NO;
            if (shareClickNum != 0) {
                _share.view.center = CGPointMake(SCREEN_WIDTH/2,2*SCREEN_HEIGHT - 60);
            }
            _share.view.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT*5/6);
        } completion:^(BOOL finished) {
            [UIView transitionWithView:self duration:0.3 options:0 animations:^{
                
            } completion:nil];
        }];
    }];
    
}

- (void)downloadAction {
    if (!_data.isDownload) {
        _downloadButton.enabled = NO;
        // 数组变化
        [[dataModel_ mutableArrayValueForKey:@"downloadingSections"] addObject:_data];
        dataModel_.isDownloading = YES;
        if (!downloadMoudle_) {
            downloadMoudle_ = [[DownloadModule alloc] init];
        }
        //        [downloadMoudle_ startDownload:_data];
    }
    NSLog(@"下载");
}

- (void)likeAction {
    if (!_data.isLike) {
        _data.isLike = YES;
        _likeButton.enabled = NO;
        [userModel_.userLikeSectionID insertObject:self.data.clickSectionID atIndex:0];
        NSLog(@"id:%@ %@ %p %@",self.data.sectionID,userModel_.userLikeSectionID[0],userModel_.userLikeSectionID,dataModel_.allSection[0]);
//        [userModel_.userLikeSectionID removeAllObjects];
        [dataModel_.userLikeSection insertObject:self.data atIndex:0];
        userModel_.isChange = YES;
        [[UserDataModel defaultDataModel] saveLocalData];
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
        _share.view.alpha = 0;
        [_share.view addSubview:rank];
        [_share.view addSubview:button];
    }
    if (!smBackView_) {
        smBackView_ = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [smBackView_ addTarget:self action:@selector(backTap) forControlEvents:UIControlEventTouchUpInside];
        smBackView_.hidden = YES;
        smBackView_.backgroundColor = [UIColor clearColor];
    }
    // 当前顶层窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    // 添加到窗口
    [window addSubview:smBackView_];
    [window addSubview:_share.view];
    return _share;
}

// 通知中心
- (void)shareButClick1:(NSNotification *)not{
    NSLog(@"收起来!!!");
//    _share.view.alpha = 0;
    if (!kj_sharekaiguan) {
        shareClickNum = 1;
    }
}

-(IBAction)shareButClick:(id)sender{
    [self backTap];
}

- (IBAction)Share:(UIButton *)sender {
    if (shareClickNum != 0) {
        _share.view.center = CGPointMake(SCREEN_WIDTH/2,2*SCREEN_HEIGHT);
    }
    [UIView transitionWithView:self.share.view duration:0.5 options:0 animations:^{
        _share.view.alpha = 1.0;
        [self bringSubviewToFront:_share.view];
        if (shareClickNum != 0) {
            _share.view.center = CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT+SCREEN_HEIGHT/6);
            NSLog(@"%d",shareClickNum);
        }else {
            _share.view.center = CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT*5/6);
            shareClickNum = 0;
        }
    } completion:nil];
}

@end

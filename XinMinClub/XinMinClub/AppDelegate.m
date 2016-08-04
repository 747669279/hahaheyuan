//
//  AppDelegate.m
//  XinMinClub
//
//  Created by yangkejun on 16/3/18.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "AppDelegate.h"
#import "ICETutorialController.h"
#import "RegisterViewController.h"
#import "DataModel.h"
#import "UserDataModel.h"
#import "ForgetViewController.h"
#import "HomeViewController.h"
#import "GlobalDialogBoxCentralNervousSystem.h"
#import "DownloadModule.h"
#import "FBKVOController.h"
#import <AVFoundation/AVFoundation.h>
//第三方登陆
#import </Users/hejun/Desktop/hahaheyuan/XinMinClub/XinMinClub/ShareSDK/ShareSDK.framework/Headers/ShareSDK.h>
#import </Users/hejun/Desktop/hahaheyuan/XinMinClub/XinMinClub/ShareSDK/Support/Required/ShareSDKConnector.framework/Headers/ShareSDKConnector.h>
#import "WXApi.h"
#import "APOpenAPI.h"
#import "WBHttpRequest.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
// 分享
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"
#import "PalyerViewController.h"
#import "ReaderTableViewController.h"
@interface AppDelegate ()<ICETutorialControllerDelegate, LoginDelegate, RegisterDelegate, ForgetDelegate> {
    RegisterViewController *rvc;
    ForgetViewController *fvc;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //后台播放音频设置
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    //注册第三方登陆
    [ShareSDK registerApp:@"iosv1101"
          activePlatforms:@[
                            @(SSDKPlatformTypeWechat),@(SSDKPlatformTypeQQ),@(SSDKPlatformTypeAliPaySocial),@(SSDKPlatformTypeSinaWeibo)
                            ]
                 onImport:^(SSDKPlatformType platformType) {
                     
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
                             break;
                         case SSDKPlatformTypeAliPaySocial:[ShareSDKConnector connectAliPaySocial:[APOpenAPI class]];
                             break;
                         case SSDKPlatformTypeSinaWeibo:[ShareSDKConnector connectWeibo:[WBHttpRequest class]];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class]
                                        tencentOAuthClass:[TencentOAuth class]];
                             break;
                             
                         default:
                             break;
                     }
                     
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              switch (platformType)
              {
                      
                  case SSDKPlatformTypeWechat:
                      [appInfo SSDKSetupWeChatByAppId:@"wx4868b35061f87885"
                                            appSecret:@"64020361b8ec4c99936c0e3999a9f249"];
                      break;
                      
                  case SSDKPlatformTypeAliPaySocial:
                      [appInfo SSDKSetupAliPaySocialByAppId:@"2016060101468306"];
                      break;
                  case SSDKPlatformTypeQQ:
                      [appInfo SSDKSetupQQByAppId:@"100371282"
                                           appKey:@"aed9b0303e3ed1e27bae87c33761161d"
                                         authType:SSDKAuthTypeBoth];
                      break;
                  case SSDKPlatformTypeSinaWeibo:
                      //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                      [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
                                                appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                                              redirectUri:@"http://www.sharesdk.cn"
                                                 authType:SSDKAuthTypeBoth];
                      break;
                  default:
                      break;
              }
              
          }];
    // 一句话解决所有TableView的多余cell就一句代码放在AppDelegate里
    [[UITableView appearance] setTableFooterView:[UIView new]];
    [UMSocialData setAppKey:@"56fced81e0f55a3cf400182b"];//####为微信开放平台上申请到的appID
    [UMSocialWechatHandler setWXAppId:@"wxd930ea5d5a258f4f" appSecret:@"db426a9829e4b49a0dcac7b4162da6b6" url:@"http://13245351.czvv.com"];
    [UMSocialQQHandler setQQWithAppId:@"100424468" appKey:@"c7394704798a158208a74ab60104f0ba" url:@"http://13245351.czvv.com"];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"1007222427"secret:@"97bebb3f4423245897bf1410084749d8"RedirectURL:@"http://13245351.czvv.com"];
    [UMSocialQQHandler setQQWithAppId:@"100424468" appKey:@"c7394704798a158208a74ab60104f0ba" url:@"http://13245351.czvv.com"];

    [[UINavigationBar appearance] setTintColor: [UIColor colorWithRed:0.070 green:0.035 blue:0.023 alpha:0.800]];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0.070 green:0.035 blue:0.023 alpha:0.800], NSForegroundColorAttributeName, nil, NSFontAttributeName, nil]];

    // Init the pages texts, and pictures.
    ICETutorialPage *layer1 = [[ICETutorialPage alloc] initWithTitle:@"雅書華學舘" subTitle:@"仁愛謹信  知行合一" pictureName:@"tu1.jpg" duration:3.0];
    ICETutorialPage *layer2 = [[ICETutorialPage alloc] initWithTitle:@"雅書華學舘" subTitle:@"雅讀詩書氣質華" pictureName:@"tu2.jpg" duration:3.0];
    ICETutorialPage *layer3 = [[ICETutorialPage alloc] initWithTitle:@"樂 學 堂" subTitle:@"仁愛謹信  知行合一" pictureName:@"tu3.jpg" duration:3.0];
    ICETutorialPage *layer4 = [[ICETutorialPage alloc] initWithTitle:@"樂 學 堂" subTitle:@"好學者不如樂學者" pictureName:@"tu4.jpg" duration:3.0];
    //    ICETutorialPage *layer5 = [[ICETutorialPage alloc] initWithTitle:@"Picture 5" subTitle:@"The Louvre's Museum Pyramide" pictureName:@"5@2x.jpg" duration:3.0];
    NSArray *tutorialLayers = @[layer1,layer2,layer3,layer4];
    
    // Set the common style for the title.
    ICETutorialLabelStyle *titleStyle = [[ICETutorialLabelStyle alloc] init];
    [titleStyle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17.0f]];
    [titleStyle setTextColor:[UIColor whiteColor]];
    [titleStyle setLinesNumber:1];
    [titleStyle setOffset:180];
    [[ICETutorialStyle sharedInstance] setTitleStyle:titleStyle];
    
    // Set the subTitles style with few properties and let the others by default.
    [[ICETutorialStyle sharedInstance] setSubTitleColor:[UIColor whiteColor]];
    [[ICETutorialStyle sharedInstance] setSubTitleOffset:150];
    
    // Init tutorial.
    self.leadViewController = [[ICETutorialController alloc] initWithPages:tutorialLayers delegate:self];
    
    // Run it.
    [self.leadViewController startScrolling];
    
    // 设置window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [[GlobalDialogBoxCentralNervousSystem shareObject] viewDidLoad];
   // [GlobalDialogBoxCentralNervousSystem shareObject].windowDelegate = self;
    self.window.rootViewController = self.leadViewController;
    [self.window makeKeyAndVisible];
    // 返回按钮
    [self setNavigationBarBackButton:nil withText:@""];
    [self setColor];
    return YES;
}

- (void)setColor {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]]; // 返回按钮颜色
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.594 green:0.205 blue:0.170 alpha:1.000]]; // navigation背景颜色
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:18], NSFontAttributeName, nil]]; // 标题文字颜色
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)setNavigationBarBackButton:(UIImage *)image withText:(NSString *)text {
    if ([text isEqualToString:@""]) {
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    }
    else {
    }
    UIImage *backButtonImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}

#pragma mark - ICETutorialController delegate
- (void)tutorialController:(ICETutorialController *)tutorialController scrollingFromPageIndex:(NSUInteger)fromIndex toPageIndex:(NSUInteger)toIndex {
//    NSLog(@"Scrolling from page %lu to page %lu.", (unsigned long)fromIndex, (unsigned long)toIndex);
}

- (void)tutorialControllerDidReachLastPage:(ICETutorialController *)tutorialController {
//    NSLog(@"最后一张图片需要做的事情");
} 

- (void)tutorialController:(ICETutorialController *)tutorialController didClickOnLeftButton:(UIButton *)sender {
    NSLog(@"点击了登录");
    if (!_lvc) {
        _lvc = [[HelloWord alloc] init];
    }
    UIImage *im = [[UIImage imageNamed:@"12345.jpg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _lvc.advertisementImage=im;
    _loginView=[[LoginViewController alloc]init];
    _loginView.delegate = self;
    if (_lvc.ThereAreNoPassword) {
        [self.leadViewController presentViewController:_lvc animated:YES completion:nil];
    }else{
        [self.leadViewController presentViewController:_loginView animated:YES completion:nil];
    }
}

- (void)tutorialController:(ICETutorialController *)tutorialController didClickOnRightButton:(UIButton *)sender {
    NSLog(@"点击了注册");
    if (!rvc) {
        rvc = [[RegisterViewController alloc] init];
        rvc.delegate = self;
    }
    // 设置切换动画
    CATransition *animation = [CATransition animation];
    animation.duration = 0.6;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"rippleEffect";
    [self.window.layer addAnimation:animation forKey:nil];
    rvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.leadViewController presentViewController:rvc animated:YES completion:nil];
}

#pragma mark GlobalDialogBoxCentralNervousSystemDelegate
//- (void)pushAlertView{
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"传入的章节已经播放完成" message:@"是否跳转到相应的界面" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *action= [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        //跳转到相应的播放器
//        NSLog(@"选择确定");
//        self.PlayCompleteState=YES;
//        }];
//    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"选择取消");
//     }];
//    [alertController addAction:action];
//    [alertController addAction:action1];
//    [[UIApplication sharedApplication].keyWindow.rootViewController.navigationController presentViewController:alertController animated:YES completion:nil];
//}
#pragma mark LoginDelegate
- (void)loginForget {
    if (!fvc) {
        fvc = [[ForgetViewController alloc] init];
        fvc.delegate = self;
    }
//    fvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.leadViewController presentViewController:fvc animated:NO completion:nil];
}

- (void)loginRegister {
    if (!rvc) {
        rvc = [[RegisterViewController alloc] init];
        rvc.delegate = self;
    }
    rvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.leadViewController presentViewController:rvc animated:YES completion:nil];
}

- (void)registerLogin {
    if (!_lvc) {
        _lvc = [[HelloWord alloc] init];
    }
    UIImage *im = [[UIImage imageNamed:@"12345.jpg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _lvc.advertisementImage=im;
    if (_lvc.ThereAreNoPassword) {
        [self.leadViewController presentViewController:_lvc animated:NO completion:nil];
    }else{
        LoginViewController *loginView=[[LoginViewController alloc]init];
        [self.leadViewController presentViewController:loginView animated:NO completion:nil];
    }
}

#pragma mark ForgetDelegate

- (void)forgetRegister {
    if (!rvc) {
        rvc = [[RegisterViewController alloc] init];
        rvc.delegate = self;
    }
    rvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.leadViewController presentViewController:rvc animated:YES completion:nil];
}
- (void)forgetLogin {
    if (!_lvc) {
        _lvc = [[HelloWord alloc] init];
    }
    UIImage *im = [[UIImage imageNamed:@"12345.jpg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _lvc.advertisementImage=im;
    if (_lvc.ThereAreNoPassword) {
        [self.leadViewController presentViewController:_lvc animated:NO completion:nil];
    }else{
        LoginViewController *loginView=[[LoginViewController alloc]init];
        [self.leadViewController presentViewController:loginView animated:NO completion:nil];
    }

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}


@end

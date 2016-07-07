//
//  CommentModel.m
//  XinMinClub
//
//  Created by 杨科军 on 16/4/20.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "CommentModel.h"
#import "SectionData.h"
#import "DetailsTableView.h"
#import "DetailsTableViewController.h"

@interface CommentModel()

@property (nonatomic, strong) NSString *libraryNum;
@property (nonatomic, strong) NSString *libraryContent1;
@end

@implementation CommentModel

+(instancetype)shareObject{
    static CommentModel *model = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        model = [[super allocWithZone:NULL] init];
    });
    return model;
}

- (void)startGetComment:(NSString *)libraryID{
    _libraryNum = libraryID;
    [self appraiseRequest];
}

- (void)appraiseRequest{
    // 拼接参数
    NSString *s1 = @"{\"Right_ID\": \"";
    NSString *s2 = [NSString stringWithFormat:@"%@",[UserDataModel defaultDataModel].userID];
    NSString *s12 = [s1 stringByAppendingString:s2];
    NSString *S3 = @"\", \"FunName\": \"Get_Sys_Gx_WenJi_PL\", \"Params\": {\"WJ_ID\":\"";
    NSString *s23 = [s12 stringByAppendingString:S3];
    NSString *s4 = [NSString stringWithFormat:@"%@",_libraryNum];
    NSString *s34 = [s23 stringByAppendingString:s4];
    NSString *s5 = @"\"}}";
    NSString *s45 = [s34 stringByAppendingString:s5];
    NSString *param = s45;
    NSLog(@"param = %@",param);
    
    // 创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 设置请求路径
    NSURL*URL=[NSURL URLWithString:@"http://218.240.52.135/App/App.ashx"];
    // 创建请求对象
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];//默认为get请求
    request.timeoutInterval=5;//设置请求超时为5秒
    request.HTTPMethod=@"POST";//设置请求方法
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 解析数据
        if (data != nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if (dict != nil) {
//                    NSLog(@"用户评价返回的json%@",dict);
                NSMutableArray *arr = [NSMutableArray array];
                NSDictionary *dic = [[dict valueForKey:@"RET"] valueForKey:@"SYS_GX_WJ_PL"];
                for (NSDictionary *dictt in dic) {
                    SectionData *data = [[SectionData alloc] init];
                    data.commentTime = [dictt valueForKey:@"PL_OPS_TIME"];
                    data.commentUserID = [dictt valueForKey:@"PL_USER_ID"];
                    data.commentBookID = [dictt valueForKey:@"PL_WJ_ID"];
                    data.commentText = [dictt valueForKey:@"PL_WJ_CONTENT"];
                    data.commentImageUrl = [dictt valueForKey:@"USER_IMG"];
                    data.commentID = [dictt valueForKey:@"PL_ID"];
                    data.commentName = [dictt valueForKey:@"USER_NAME"];
                    [arr addObject:data];
                }
                // 获取到的分类列表在主线程中通过委托返回出去
                dispatch_sync(dispatch_get_main_queue(), ^{
                    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
                    UIViewController *topVC = appRootVC;
                    while (topVC.presentedViewController) {
                        topVC = topVC.presentedViewController;
                    }
                    if ([topVC isKindOfClass:[DetailsTableView class]] || [topVC isKindOfClass:[DetailsTableViewController class]]) {
                        [_commentDelegate getComment:arr];
                    }
                });
            }
            else
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    // 服务器无反应
                    
                });
        }
        else
            dispatch_async(dispatch_get_main_queue(), ^(void){
                // 无网络
                
            });
    }];
    // 执行任务
    [dataTask resume];
}

- (void)updateUserAppraise:(NSString *)libraryID LibraryContent:(NSString *)libraryContent{
    _libraryNum = libraryID;
    _libraryContent1 = libraryContent;
    [self updateAppraiseRequest];
}

- (void)updateAppraiseRequest{
    // 拼接参数
    NSString *s1 = @"{\"Right_ID\": \"";
    NSString *s2 = [NSString stringWithFormat:@"%@",[UserDataModel defaultDataModel].userID];
    NSString *s12 = [s1 stringByAppendingString:s2];
    NSString *S3 = @"\", \"FunName\": \"Add_Sys_Gx_WenJi_PL\", \"Params\": {\"PL_WJ_ID\":\"";
    NSString *s23 = [s12 stringByAppendingString:S3];
    NSString *s4 = [NSString stringWithFormat:@"%@",_libraryNum];
    NSString *s34 = [s23 stringByAppendingString:s4];
    NSString *s5 = @"\",\"PL_WJ_CONTENT\":\"";
    NSString *s45 = [s34 stringByAppendingString:s5];
    NSString *s6 = [NSString stringWithFormat:@"%@",_libraryContent1];
    NSString *s56 = [s45 stringByAppendingString:s6];
    NSString *s7 = @"\"}}";
    NSString *s67 = [s56 stringByAppendingString:s7];
    NSString *param = s67;
    NSLog(@"param = %@",param);
    
    // 创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 设置请求路径
    NSURL*URL=[NSURL URLWithString:@"http://218.240.52.135/App/App.ashx"];
    // 创建请求对象
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];//默认为get请求
    request.timeoutInterval=5;//设置请求超时为5秒
    request.HTTPMethod=@"POST";//设置请求方法
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 解析数据
        if (data != nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if (dict != nil) {
//                NSLog(@"上传用户评价返回的json%@",dict);
                NSString *re = [[dict valueForKey:@"RET"] valueForKey:@"DATA"];
                // 获取到的分类列表在主线程中通过委托返回出去
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [_commentDelegate updateUserAppraiseIsSucceed:re];
                });
            }
            else
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    // 服务器无反应
                    
                });
        }
        else
            dispatch_async(dispatch_get_main_queue(), ^(void){
                // 无网络
                
            });
    }];
    // 执行任务
    [dataTask resume];
}

@end

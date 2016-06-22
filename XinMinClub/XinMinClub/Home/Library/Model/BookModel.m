//
//  SongModel.m
//  KJ5sing2
//
//  Created by yangkejun on 16/3/12.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "BookModel.h"
#import <AVKit/AVKit.h>

@interface BookModel()

@property (nonatomic, copy) NSString *userID; // 用户ID
@property (nonatomic, copy) NSString *type; // 文集分类
@property (nonatomic, copy) NSString *pageIndex; //上拉刷新当先显示的是第几次
@property (nonatomic, copy) NSString *pageCount; //每次上拉刷新加载文集数目

@end

@implementation BookModel

+(instancetype)shareObject{
    static BookModel *model = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        model = [[super allocWithZone:NULL] init];
    });
    return model;
}

- (void)startGetList:(NSString *)userID{
    _userID = userID;
    [self listRequest];
}

- (void)listRequest{
    // 拼接参数
//    NSString *s1 = @"{\"Right_ID\": \"";
//    NSString *s2 = [NSString stringWithFormat:@"%@",_userID];
//    NSString *s12 = [s1 stringByAppendingString:s2];
//    NSString *S3 = @"\", \"FunName\": \"Get_WJ_TYPE_Data\", \"Params\": {\"DATA\":\"\"}}";
//    NSString *s23 = [s12 stringByAppendingString:S3];
//    NSString *param = s23;
    NSString *k = @"0";
    NSString *param = [NSString stringWithFormat:@"{\"Right_ID\": \"%@\", \"FunName\": \"Get_WJ_Type\", \"Params\":{\"ZY_PID\":\"%@\"}}",[UserDataModel defaultDataModel].userID, k];
//    NSLog(@"param = %@",param);
    
    // 创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 设置请求路径
    NSURL*URL=[NSURL URLWithString:@"http://218.240.52.135/App/App.ashx"];
    // 创建请求对象
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];//默认为get请求
    request.timeoutInterval=5.0;//设置请求超时为5秒
    request.HTTPMethod=@"POST";//设置请求方法
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 解析数据
        if (data != nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if (dict != nil) {
//                                NSLog(@"分类列表返回的json%@",dict);
                NSArray *dataString = [[dict valueForKey:@"RET"] valueForKey:@"Sys_Zy_Config"];
//                NSArray *a11 = [dataString componentsSeparatedByString:@","];//分割数组当中的内容
                NSMutableArray *a11=[NSMutableArray array];
                for (NSDictionary *dii in dataString) {
                    SectionData *data=[[SectionData alloc] init];
                    data.ZY_TYPE = [dii valueForKey:@"ZY_TYPE"];
                    data.ZY_E = [dii valueForKey:@"ZY_E"];
                    data.ZY_CONTENT = [dii valueForKey:@"ZY_CONTENT"];
                    data.ZY_TIME = [dii valueForKey:@"ZY_TIME"];
                    data.ZY_PID = [dii valueForKey:@"ZY_PID"];
                    data.ZY_NAME = [dii valueForKey:@"ZY_NAME"];
                    data.ZY_ID = [dii valueForKey:@"ZY_ID"];
                    data.ZY_USER = [dii valueForKey:@"ZY_USER"];
                    data.ZY_ISORT = [dii valueForKey:@"ZY_ISORT"];
                    [a11 addObject:data];
                }
                // 获取到的分类列表在主线程中通过委托返回出去
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [_libraryModelDelegate getLibrartList:a11];
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

- (void)startGetLibraryModelDataUserID:(NSString *)userID Type:(NSString *)type PageIndex:(NSInteger)pageIndex{
    _userID = userID;
    _type = type;
    _pageIndex = [NSString stringWithFormat:@"%d",pageIndex];
    _pageCount = @"20";
    [self bookRequest];
}

// 书集请求
- (void)bookRequest{
    // 拼接参数
    NSString *s1 = @"{\"Right_ID\": \"";
    NSString *s2 = [NSString stringWithFormat:@"%@",_userID];
    NSString *s12 = [s1 stringByAppendingString:s2];
    NSString *S3 = @"\", \"FunName\": \"Get_WenJi_DataList\", \"Params\": { \"TYPE\":\"";
    NSString *s23 = [s12 stringByAppendingString:S3];
    NSString *s4 = [NSString stringWithFormat:@"%@",_type];
    NSString *s34 = [s23 stringByAppendingString:s4];
    NSString *s5 = @"\", \"Page_Index\":\"";
    NSString *s45 = [s34 stringByAppendingString:s5];
    NSString *s6 = [NSString stringWithFormat:@"%@",_pageIndex];
    NSString *s56 = [s45 stringByAppendingString:s6];
    NSString *s7 = @"\", \"Page_Count\":\"";
    NSString *s67 = [s56 stringByAppendingString:s7];
    NSString *s8 = [NSString stringWithFormat:@"%@",_pageCount];
    NSString *s78 = [s67 stringByAppendingString:s8];
    NSString *s9 = @"\" }}";
    NSString *s89 = [s78 stringByAppendingString:s9];
    NSString *param = s89;
//        NSLog(@"param = %@",param);
    NSString *kj_type = _type;
    // 创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 设置请求路径
    NSURL*URL=[NSURL URLWithString:@"http://218.240.52.135/App/App.ashx"];
    // 创建请求对象
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];//默认为get请求
    request.timeoutInterval=20.0;//设置请求超时为5秒
    request.HTTPMethod=@"POST";//设置请求方法
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 解析数据
        if (data != nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if (dict != nil) {
//                                NSLog(@"文集返回的json%@",dict);
//                NSInteger a1 =[[[dict valueForKey:@"RET"] valueForKey:@"Record_Count"] integerValue];
                NSDictionary *dataString = [[dict valueForKey:@"RET"] valueForKey:@"Sys_GX_WenJI"];
                NSMutableArray *arr = [NSMutableArray array];
                for (NSDictionary *dic in dataString) {
                    SectionData *data = [[SectionData alloc]init];
                    data.libraryReadTotal = [dic valueForKey:@"WJ_WCOUNT"];
                    data.libraryAuthorName = [dic valueForKey:@"WJ_USER"];
                    data.libraryDetails = [dic valueForKey:@"WJ_CONTENT"];
                    data.libraryImageUrl = [dic valueForKey:@"WJ_IMG"];
                    data.libraryNum = [dic valueForKey:@"WJ_ID"];
                    data.libraryTitle = [dic valueForKey:@"WJ_NAME"];
                    data.libraryType = [dic valueForKey:@"WJ_TYPE"];
                    data.libraryTime = [dic valueForKey:@"WJ_PUBLISH"];
                    data.libraryLanguage = [dic valueForKey:@"WJ_LANGUAGE"];
                    [arr addObject:data];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_libraryModelDelegate getLibraryModelDataComplete:arr ReturnType:kj_type];
                });
            }
            else
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    // 服务器无反应
                    NSLog(@"服务器无反应!!!");
                });
        }
        else
            dispatch_async(dispatch_get_main_queue(), ^(void){
                // 无网络
                NSLog(@"网络连接失败!!!");
            });
    }];
    // 执行任务
    [dataTask resume];
}

- (void)kj_startGetLibraryModelDataUserID:(NSString *)userID Type:(NSString *)type PageIndex:(NSInteger)pageIndex{
    _userID = userID;
    _type = type;
    _pageIndex = [NSString stringWithFormat:@"%d",pageIndex];
    _pageCount = @"20";
    [self kj_bookRequest];
}

// 书集请求
- (void)kj_bookRequest{
    // 拼接参数
    NSString *s1 = @"{\"Right_ID\": \"";
    NSString *s2 = [NSString stringWithFormat:@"%@",_userID];
    NSString *s12 = [s1 stringByAppendingString:s2];
    NSString *S3 = @"\", \"FunName\": \"Get_WenJi_DataList\", \"Params\": { \"TYPE\":\"";
    NSString *s23 = [s12 stringByAppendingString:S3];
    NSString *s4 = [NSString stringWithFormat:@"%@",_type];
    NSString *s34 = [s23 stringByAppendingString:s4];
    NSString *s5 = @"\", \"Page_Index\":\"";
    NSString *s45 = [s34 stringByAppendingString:s5];
    NSString *s6 = [NSString stringWithFormat:@"%@",_pageIndex];
    NSString *s56 = [s45 stringByAppendingString:s6];
    NSString *s7 = @"\", \"Page_Count\":\"";
    NSString *s67 = [s56 stringByAppendingString:s7];
    NSString *s8 = [NSString stringWithFormat:@"%@",_pageCount];
    NSString *s78 = [s67 stringByAppendingString:s8];
    NSString *s9 = @"\" }}";
    NSString *s89 = [s78 stringByAppendingString:s9];
    NSString *param = s89;
    //        NSLog(@"param = %@",param);
//    NSString *kj_type = _type;
    // 创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 设置请求路径
    NSURL*URL=[NSURL URLWithString:@"http://218.240.52.135/App/App.ashx"];
    // 创建请求对象
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];//默认为get请求
    request.timeoutInterval=20.0;//设置请求超时为5秒
    request.HTTPMethod=@"POST";//设置请求方法
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 解析数据
        if (data != nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if (dict != nil) {
                // NSLog(@"文集返回的json%@",dict);
                NSInteger a1 =[[[dict valueForKey:@"RET"] valueForKey:@"Record_Count"] integerValue];
                NSDictionary *dataString = [[dict valueForKey:@"RET"] valueForKey:@"Sys_GX_WenJI"];
                NSMutableArray *arr = [NSMutableArray array];
                for (NSDictionary *dic in dataString) {
                    SectionData *data = [[SectionData alloc]init];
                    data.libraryReadTotal = [dic valueForKey:@"WJ_WCOUNT"];
                    data.libraryAuthorName = [dic valueForKey:@"WJ_USER"];
                    data.libraryDetails = [dic valueForKey:@"WJ_CONTENT"];
                    data.libraryImageUrl = [dic valueForKey:@"WJ_IMG"];
                    data.libraryNum = [dic valueForKey:@"WJ_ID"];
                    data.libraryTitle = [dic valueForKey:@"WJ_NAME"];
                    data.libraryType = [dic valueForKey:@"WJ_TYPE"];
                    data.libraryTime = [dic valueForKey:@"WJ_PUBLISH"];
                    data.libraryLanguage = [dic valueForKey:@"WJ_LANGUAGE"];
                    [arr addObject:data];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_libraryModelDelegate getLibraryModelDataComplete:arr LibraryCount:a1];
                });
            }
            else
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    // 服务器无反应
                    NSLog(@"服务器无反应!!!");
                });
        }
        else
            dispatch_async(dispatch_get_main_queue(), ^(void){
                // 无网络
                NSLog(@"网络连接失败!!!");
            });
    }];
    // 执行任务
    [dataTask resume];
}


@end

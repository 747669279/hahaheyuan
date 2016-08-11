//
//  ClickModel.m
//  XinMinClub
//
//  Created by yangkejun on 16/3/30.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "SectionModel.h"
#import "SaveModule.h"

@interface SectionModel(){
    NSString *kj_bookID;
    NSString *section_typeID;
}

@end

@implementation SectionModel

+(instancetype)shareObject{
    static SectionModel *model = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        model = [[super allocWithZone:NULL] init];
    });
    return model;
}

// 获取章节分类
- (void)startSectionType:(NSString *)bookID{
    kj_bookID = bookID;

    NSString *param = [NSString stringWithFormat:@"{\"Right_ID\": \"%@\",\"FunName\": \"Get_WJ_ZJ_TYPE\",\"Params\":{\"GJ_WJ_ID\":\"%@\"}}",[UserDataModel defaultDataModel].userID,bookID];
//    NSLog(@"取得章节分类:%@",param);    // 把拼接后的字符串转换为data，设置请求体
    [self kj_typeRequest:param];
}

- (void)kj_typeRequest:(NSString *)param{
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
//                                NSLog(@"章节分类返回的json%@",dict);
                NSString *dataString = [[dict valueForKey:@"RET"] valueForKey:@"DATA"];
                NSArray *a11 = [dataString componentsSeparatedByString:@","];//分割数组当中的内容
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_clickDelegate getSectionType:a11];
                    
                    [[SaveModule defaultObject] saveSectionListWithBookID:kj_bookID firstLevel:a11];
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
                NSLog(@"网络连接失败，无网!!!");
            });
    }];
    // 执行任务
    [dataTask resume];
    
}

- (void)startSectionList:(NSString *)sectionTypeID IsSectionList:(BOOL)list{
    section_typeID = sectionTypeID;
    // 参数
    NSString *a1 = @"1";
    NSString *a2 = @"100000";
    NSString *param = [NSString stringWithFormat:@"{\"Right_ID\": \"%@\", \"FunName\": \"Get_WJ_ZJ_TYPE_DataList\", \"Params\":{\"GJ_WJ_ID\":\"%@\", \"GJ_WJ_ZY_TYPE\":\"%@\",\"Page_Index\":\"%@\",\"Page_Count\":\"%@\"}}",[UserDataModel defaultDataModel].userID, kj_bookID, sectionTypeID, a1, a2];
    NSLog(@"%@",param);
    [self kj_listRequest:param IsSectionList:list];
}

- (void)kj_listRequest:(NSString *)param IsSectionList:(BOOL)list{
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
//                NSLog(@"章节二级分类返回的json%@",dict);
//                SectionData *da = [[SectionData alloc]init];
//                da.clickSectionTotal = [[dict valueForKey:@"RET"] valueForKey:@"Record_Count"];
//                da.clickNewSectionNum = [[dict valueForKey:@"RET"] valueForKey:@"Page_Index"];
//                NSInteger a1 =[da.clickSectionTotal integerValue];
                NSDictionary *dataString = [[dict valueForKey:@"RET"] valueForKey:@"Sys_GX_ZJ"];
                NSMutableArray *arr = [NSMutableArray array]; // 章节
                for (NSDictionary *dic in dataString) {
                    SectionData *data = [[SectionData alloc]init];
                    data.clickTitle = [dic valueForKey:@"GJ_NAME"]; // 章节名字
                    data.clickSectionType = [dic valueForKey:@"GJ_TYP1"]; // 章节分类
                    data.clickLibraryID = [dic valueForKey:@"GJ_WJ_ID"]; // 文集ID
                    data.clickAuthor = [dic valueForKey:@"GJ_ZJ"]; // 作者名字
                    data.clickSectionCNText = [dic valueForKey:@"GJ_CONTENT_CN"]; // 简体中文内容
                    data.clickSectionANText = [dic valueForKey:@"GJ_CONTENT_AN"]; // 繁体中文内容
                    data.clickSectionENText = [dic valueForKey:@"GJ_CONTENT_EN"]; // 英文内容
                    data.clickTime = [dic valueForKey:@"GJ_OPS_TIME"]; // 发布时间
                    data.clickNameRank = [dic valueForKey:@"GJ_ISORT"]; // 章节名称排序
                    data.clickTypeRank = [dic valueForKey:@"GJ_TYPE_ISORT"]; // 章节分类排序
                    data.clickMp3 = [NSString stringWithFormat:@"http://218.240.52.135%@",[dic valueForKey:@"GJ_MP3"] ]; // mp3
                    data.clickRemarks = [dic valueForKey:@"GJ_CONTENT"]; // 备注
                    data.clickSectionID = [dic valueForKey:@"GJ_ID"]; // 章节ID
                    if ([data.clickAuthor isEqualToString:@""]) {
                        data.clickAuthor = @"无名";
                    }
                    [arr addObject:data];
                    [[SaveModule defaultObject] saveSectionDataWithSectionID:data.clickSectionID sectionData:data];
                    if (![[DataModel defaultDataModel].allSectionID containsObject:data.clickSectionID]) {
                        [[DataModel defaultDataModel].allSectionID addObject:data.clickSectionID];
                        [[DataModel defaultDataModel].allSection insertObject:data atIndex:0];
                    }
                }
                NSArray *kj_dataArray = [arr sortedArrayUsingComparator:^NSComparisonResult(SectionData *string1, SectionData *string2) {
                    return[string1.clickNameRank compare:string2.clickNameRank]; // 升序排列
                }];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (list) { // 判断是否为章节请求的数据
                        [_listDelegate getSectionList:kj_dataArray];
                    }else
                        [_readListDelegate getSectionReadList:kj_dataArray];
                });
                
                
                NSMutableArray *secondLevel = [NSMutableArray array];
                for (SectionData *data in kj_dataArray) {
                    [secondLevel addObject:data.clickTitle];
                }
                [[SaveModule defaultObject] setSectionListWithBookID:kj_bookID firstLevel:@[section_typeID] secondLevel:secondLevel];
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    // 服务器无反应
                    NSLog(@"服务器无反应!!!");
                });
            }
        }
        else
            dispatch_async(dispatch_get_main_queue(), ^(void){
                // 无网络
                NSLog(@"网络连接失败，无网!!!");
            });
}];
    // 执行任务
    [dataTask resume];
    
}

@end

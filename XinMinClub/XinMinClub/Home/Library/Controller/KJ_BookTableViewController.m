//
//  KJ_BookTableViewController.m
//  XinMinClub
//
//  Created by 杨科军 on 16/5/23.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "KJ_BookTableViewController.h"
//#import "HTHorizontalSelectionList.h"
//#import "KJ_BookCell1.h"
//#import "KJ_BookCell2.h"
//#import "BookModel.h"
//
//@interface KJ_BookTableViewController ()<LibraryModelDelegata,HTHorizontalSelectionListDelegate,HTHorizontalSelectionListDataSource>{
//    NSMutableArray *adArray; // 滚动广告数据
//    NSMutableArray *listArray;//分类列表
//    NSMutableDictionary *kj_dict; // 数据字典
//    NSInteger kj_a; // 判断数据是否获取完
//}
//
//@property(nonatomic, copy) HTHorizontalSelectionList *categoryList;
//
//@end
//
@implementation KJ_BookTableViewController
//
//// 初始化
//- (id)init{
//    if (self=[super init]) {
//        // 创建空的数组
//        adArray = [NSMutableArray new];
//        listArray = [NSMutableArray new];
//        kj_dict = [NSMutableDictionary new];
//        
//        // 初始化一些数据
//        kj_a=0;
//        
//        // 设置委托对象和请求数据
//        [BookModel shareObject].libraryModelDelegate=self;
//        [[BookModel shareObject] startGetList:[UserDataModel defaultDataModel].userID]; // 开始获取分类列表请求
//    }
//    return self;
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    [self addImage]; // 获取滚动广告数据
//    
//    // 注册cell类
//    [self.tableView registerClass:[KJ_BookCell1 class] forCellReuseIdentifier:@"kj_bookCell1"];
//    [self.tableView registerClass:[KJ_BookCell2 class] forCellReuseIdentifier:@"kj_bookCell2"];
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    
//}
//
//// 假数据（滚动广告）
//- (void)addImage{
//    UIImage *im1 = [UIImage imageNamed:@"24.jpg"];
//    UIImage *im2 = [UIImage imageNamed:@"25.jpg"];
//    UIImage *im3 = [UIImage imageNamed:@"26.jpg"];
//    UIImage *im4 = [UIImage imageNamed:@"27.jpg"];
//    UIImage *im5 = [UIImage imageNamed:@"28.jpg"];
//    [adArray addObject:im1];
//    [adArray addObject:im2];
//    [adArray addObject:im3];
//    [adArray addObject:im4];
//    [adArray addObject:im5];
//}
//
//#pragma mark LibraryModelDelegata
//- (void)getLibrartList:(NSArray *)listDatas{
//    for (NSInteger a=0; a<listDatas.count; a++) {
//        SectionData *daa=listDatas[a];
//        [listArray addObject:daa.ZY_NAME];
//    }
////    [self.categoryList reloadData];
//    for (NSInteger b=0; b<listArray.count; b++) {
//        [self reloadWithType:listArray[b] PageIndex:1];
//        kj_a=b;
//    }
//}
//- (void)getLibraryModelDataComplete:(NSArray *)libraryDatas ReturnType:(NSString *)typee{
//    [kj_dict addEntriesFromDictionary:@{typee:libraryDatas}];
//    if (kj_a+1==listArray.count) {
//        [self.tableView reloadData];
//    }
//}
//
//- (void)reloadWithType:(NSString*)type PageIndex:(NSInteger)pageIndex{
//    [[BookModel shareObject] startGetLibraryModelDataUserID:[UserDataModel defaultDataModel].userID Type:type PageIndex:pageIndex];
//}
//
//#pragma mark - Table view data source
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 2;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section==0) {
//        return 1;
//    }
//    return 1;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section==0) {
//        return SCREEN_HEIGHT/4;
//    }
//    if (indexPath.section==1) {
//        return SCREEN_HEIGHT-64-30-44;
//    }
//    return 0.1;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell;
//    if (indexPath.section==0) {
//        cell = [tableView dequeueReusableCellWithIdentifier:@"kj_bookCell1" forIndexPath:indexPath];
//        // 传递数据
//        ((KJ_BookCell1*)cell).kj_adImageArray = adArray;
//        return cell;
//    }
//    if (indexPath.section==1) {
//        cell = [tableView dequeueReusableCellWithIdentifier:@"kj_bookCell2" forIndexPath:indexPath];
//        // 传递数据
//        ((KJ_BookCell2*)cell).kj_typeArray=listArray;
//        ((KJ_BookCell2*)cell).kj_dataDict=kj_dict;
//        cell.backgroundColor=[UIColor colorWithRed:0.8859 green:0.4448 blue:0.0 alpha:1.0];
//        return cell;
//    }
//    
//    cell = [tableView dequeueReusableCellWithIdentifier:@"xx"];
//    if (!cell) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"xx"];
//    }
//    cell.textLabel.text=@"测试CELL";
//
//    return cell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section==1) {
//        return 30;
//    }
//    return 0.1;
//}
//- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (section==0) {
//        return nil;
//    }
//    return self.categoryList;
//}
//- (HTHorizontalSelectionList *)categoryList{
//    if (_categoryList == nil) {
//        _categoryList = [[HTHorizontalSelectionList alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/4, SCREEN_WIDTH, 30)];
//        // 指定第三方里面的协议的委托对象，实现对应处理
//        _categoryList.dataSource = self;
//        _categoryList.delegate = self;
//        // 根据第三方提供的属性设置一些可视化的东西
//        _categoryList.showsEdgeFadeEffect = YES; // 显示边缘淡出的效果
//        _categoryList.centerAlignButtons = YES; // 居中显示
//        _categoryList.snapToCenter = YES;
//        _categoryList.autoselectCentralItem = YES;
//        _categoryList.selectionIndicatorColor = [UIColor colorWithRed:0.851 green:0.263 blue:0.259 alpha:1.000];
//        _categoryList.bottomTrimColor = [UIColor grayColor];
//        [_categoryList setTitleFont:[UIFont fontWithName:@"Courier" size:16] forState:UIControlStateNormal];
//    }
//    return _categoryList;
//}
//#pragma mark HTHorizontalSelectionListDataSource
//// 返回分类有多少个
//- (NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList{
//    return listArray.count;
//}
//
//// 返回指定分类的名字
//- (NSString *)selectionList:(HTHorizontalSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index{
//    return listArray[index];
//}
//
//#pragma mark HTHorizontalSelectionListDelegate
//- (void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index{
//    // 当选中某个分类时的处理
////    CGRect frame = self.contentScrollView.bounds;
////    frame.origin.x = frame.size.width * index;
////    [self.contentScrollView scrollRectToVisible:frame animated:YES];
////    collectionTag = index+100;
////    selectListIndex = index;
////    // 空白数组，用于每次储存数据
////    NSMutableArray *avacancyArray = [NSMutableArray array];
////    libraryArray = avacancyArray;
////    
////    i = 1;
////    [self reloadWithType:listArray[index] PageIndex:i];
//}
//
//
//#pragma mark - Navigation
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//
//
@end


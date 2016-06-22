//
//  LibraryViewController.m
//  XinMinClub
//
//  Created by yangkejun on 16/3/19.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "LibraryViewController.h"
#import "MJBannnerPlayer.h"
#import "BookModel.h"
#import "LibraryCollectionCell.h"
#import "MJRefresh.h"
#import "HTHorizontalSelectionList.h"
#import "ADViewController.h"
#import "ClickLibraryViewController.h"
#import "KJ_BackTableViewController.h"
#import "DataModel.h"
#import "BookData.h"
#import "DiagramsView.h"

@interface LibraryViewController ()<MJBannnerPlayerDeledage,LibraryModelDelegata,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HTHorizontalSelectionListDelegate,HTHorizontalSelectionListDataSource,UIScrollViewDelegate>{
    NSMutableArray *listArray;//分类列表
    NSMutableArray *adArray; // 滚动广告数据
//    NSMutableArray *libraryArray; // 下面文库数据
//    bool off; // 判断数据是否获取到的状态
//    NSInteger i; // 上拉刷新
//    NSInteger collectionTag; // 第几个collectionView
//    NSInteger libraryTotal;  // 书集总数
//    NSInteger selectListIndex; // 选中的分类list
//    NSInteger scrollPage; // 滚动时候和上面分类list对应的数据
//    NSInteger startContentOffsetX;
//    NSInteger willEndContentOffsetX;
//    NSInteger endContentOffsetX;
//    int _lastPosition; // 判断scrollView的滚动方向
//    
//    NSTimer *endRefreshTimer; // 结束刷新计时器
//    
//    BookData *bookData;// bookData
}

@property(nonatomic, copy) HTHorizontalSelectionList *categoryList;
@property(nonatomic, copy) UIScrollView *contentScrollView;

@property(nonatomic, copy) UICollectionView *libraryCollectionView;
@property(nonatomic, copy) UICollectionViewLayout *layoutObject;

@property (nonatomic, strong) DiagramsView *diagramsView;

@end

@implementation LibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    listArray = [NSMutableArray array];
    adArray = [NSMutableArray array];
    [self addImage]; // 假数据
    [self adPlayer]; // 创建滚动广告视图
    
    [self.view addSubview:self.diagramsView];
    
//    collectionTag = 100;
//    off = NO;
//    i = 1;
//    [BookModel shareObject].libraryModelDelegate = self;
//    [[BookModel shareObject] startGetList:[UserDataModel defaultDataModel].userID]; // 开始获取分类列表请求
//    
//    [self.view addSubview:self.categoryList];
//    [self.view addSubview:self.contentScrollView];
//    
//    libraryArray = [NSMutableArray array]; // 创建一个保存collectionView图片的数组，每次刷新后的新增到这个里面
}

// 假数据（滚动广告）
- (void)addImage{
    UIImage *im1 = [UIImage imageNamed:@"24.jpg"];
    UIImage *im2 = [UIImage imageNamed:@"25.jpg"];
    UIImage *im3 = [UIImage imageNamed:@"26.jpg"];
    UIImage *im4 = [UIImage imageNamed:@"27.jpg"];
    UIImage *im5 = [UIImage imageNamed:@"28.jpg"];
    [adArray addObject:im1];
    [adArray addObject:im2];
    [adArray addObject:im3];
    [adArray addObject:im4];
    [adArray addObject:im5];
}

// 初始化一个本地图片的滚动广告
- (void)adPlayer{
    [MJBannnerPlayer initWithSourceArray:adArray addTarget:self delegate:self withSize:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/4) withTimeInterval:4.f];
}
#pragma mark MJBannnerPlayerDeledage
-(void)MJBannnerPlayer:(UIView *)bannerPlayer didSelectedIndex:(NSInteger)index{
    // TODO: 点击了滚动广告未完成
    NSLog(@"点击了Ad图片%d",index);
    //    ADViewController *advc = [[ADViewController alloc] init];
    //    advc.adImage = adArray[index];
    //    [self presentViewController:advc animated:NO completion:nil];
}

- (DiagramsView*)diagramsView{
    if (!_diagramsView) {
        _diagramsView = [[DiagramsView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT/4, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_HEIGHT/4)];
        _diagramsView.backgroundColor=[UIColor colorWithRed:0.8786 green:0.8786 blue:0.8786 alpha:1.0];
    }
    return _diagramsView;
}


//- (void)reloadWithType:(NSString*)type PageIndex:(NSInteger)pageIndex{
//    [[BookModel shareObject] kj_startGetLibraryModelDataUserID:[UserDataModel defaultDataModel].userID Type:type PageIndex:pageIndex];
//    // 下拉刷新
//    self.libraryCollectionView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        // 结束刷新
//            [self.libraryCollectionView.mj_header endRefreshing];
//            }];
//    
//    // 设置自动切换透明度(在导航栏下面自动隐藏)
//    self.libraryCollectionView.mj_header.automaticallyChangeAlpha = YES;
//    
//    // 上拉刷新
//    self.libraryCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        i++;
//        off=YES;
//        if (libraryArray.count>=libraryTotal) {
//            [self.libraryCollectionView.mj_footer endRefreshing];
//        }
//        else
//            [[BookModel shareObject] kj_startGetLibraryModelDataUserID:[UserDataModel defaultDataModel].userID Type:type PageIndex:i];
//    }];
//}
//
//#pragma mark LibraryModelDelegata
//- (void)getLibrartList:(NSArray *)listDatas{
//    for (NSInteger a=0; a<listDatas.count; a++) {
//        SectionData *daa=listDatas[a];
//        [listArray addObject:daa.ZY_NAME];
//    }
//    
//    [self.categoryList reloadData];
//    [self addCollectionView];
//    [self reloadWithType:listArray[0] PageIndex:i];
//}
//- (void)getLibraryModelDataComplete:(NSArray *)libraryDatas LibraryCount:(NSInteger)libCount{
//    [libraryArray addObjectsFromArray:libraryDatas];
//    libraryTotal = libCount;
//    [self.libraryCollectionView reloadData];
//    if (off==YES) {
//        // 结束刷新
//        [self.libraryCollectionView.mj_footer endRefreshing];
//        off=NO;
//    }
//}
//
//// 分类数组
//- (NSArray *)categories{
//    return listArray;
//}
//- (HTHorizontalSelectionList *)categoryList{
//    
//    if (_categoryList == nil) {
//        _categoryList = [[HTHorizontalSelectionList alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/4, SCREEN_WIDTH, 30)];
//        // 指定第三方里面的协议的委托对象，实现对应处理
//        _categoryList.dataSource = self;
//        _categoryList.delegate = self;
//        // 根据第三方提供的属性设置一些可视化的东西
////        _categoryList.bottomTrimHidden = YES;
//        _categoryList.showsEdgeFadeEffect = YES; // 显示边缘淡出的效果
//        _categoryList.centerAlignButtons = YES; // 居中显示
////        _categoryList.centerOnSelection = YES;  // 选中的居中显示
//        _categoryList.snapToCenter = YES;
//        _categoryList.autoselectCentralItem = YES;
//        _categoryList.selectionIndicatorColor = [UIColor colorWithRed:0.851 green:0.263 blue:0.259 alpha:1.000];
//        _categoryList.bottomTrimColor = [UIColor grayColor];
//        [_categoryList setTitleFont:[UIFont fontWithName:@"Courier" size:16] forState:UIControlStateNormal];
//    }
//    return _categoryList;
//}
//
//- (UIScrollView *)contentScrollView{
//    if (_contentScrollView == nil) {
//        _contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT/4+30, SCREEN_WIDTH, SCREEN_HEIGHT - SCREEN_HEIGHT/4 - 30)];
//        // 指定scrollView的委托对象
//        _contentScrollView.delegate = self;
//        _contentScrollView.pagingEnabled = YES; // 当不足一张的时候显示最大的那个内容
//        _contentScrollView.showsHorizontalScrollIndicator = NO; // 关闭显示水平大概位置的条状物
//        _contentScrollView.showsVerticalScrollIndicator = NO; // 关闭显示垂直大概位置的条状物
//    }
//    return _contentScrollView;
//}
//
//#pragma mark HTHorizontalSelectionListDataSource
//// 返回分类有多少个
//- (NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList{
//    return [self categories].count;
//}
//
//// 返回指定分类的名字
//- (NSString *)selectionList:(HTHorizontalSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index{
//    return [self categories][index];
//}
//
//#pragma mark HTHorizontalSelectionListDelegate
//// 当选中某个分类时的处理
//- (void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index{
//    CGRect frame = self.contentScrollView.bounds;
//    frame.origin.x = frame.size.width * index;
//    [self.contentScrollView scrollRectToVisible:frame animated:YES];
//    collectionTag = index+100;
//    selectListIndex = index;
//    // 空白数组，用于每次储存数据
//    NSMutableArray *avacancyArray = [NSMutableArray array];
//    libraryArray = avacancyArray;
//    
//    i = 1;
//    [self reloadWithType:listArray[index] PageIndex:i];
//}
//
//#pragma mark UIScrollViewDelegate
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    //拖动前的起始坐标
//    startContentOffsetX = scrollView.contentOffset.x;
//}
//
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
//    //将要停止前的坐标
//    willEndContentOffsetX = scrollView.contentOffset.x;
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    endContentOffsetX = scrollView.contentOffset.x;
//    if (endContentOffsetX<willEndContentOffsetX && willEndContentOffsetX < startContentOffsetX) {
//        //画面从右往左移动，前一页
//        NSLog(@"前一页");
//        _categoryList.selectedButtonIndex=--selectListIndex;
//        CGRect frame = self.contentScrollView.bounds;
//        frame.origin.x = frame.size.width * (selectListIndex);
//        [self.contentScrollView scrollRectToVisible:frame animated:YES];
//        collectionTag = selectListIndex+100;
//        // 空白数组，用于每次储存数据
//        NSMutableArray *avacancyArray = [NSMutableArray array];
//        libraryArray = avacancyArray;
//        i = 1;
//        [self reloadWithType:listArray[selectListIndex] PageIndex:i];
//    
//    } else if (endContentOffsetX > willEndContentOffsetX && willEndContentOffsetX > startContentOffsetX) {
//        //画面从左往右移动，后一页
//        NSLog(@"后一页");
//        _categoryList.selectedButtonIndex=++selectListIndex;
//        CGRect frame = self.contentScrollView.bounds;
//        frame.origin.x = frame.size.width * (selectListIndex);
//        [self.contentScrollView scrollRectToVisible:frame animated:YES];
//        collectionTag = selectListIndex+100;
//        // 空白数组，用于每次储存数据
//        NSMutableArray *avacancyArray = [NSMutableArray array];
//        libraryArray = avacancyArray;
//        i = 1;
//        [self reloadWithType:listArray[selectListIndex] PageIndex:i];
//    }
//}
//
//#pragma mark Subviews
//- (void)addCollectionView{
//    CGFloat w = self.contentScrollView.frame.size.width;
//    CGFloat h = self.contentScrollView.frame.size.height;
//    
//    // 添加tableView
//    for (NSInteger k = 0; k < self.categories.count; k++) {
//        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(k*w, 0, w, h-100) collectionViewLayout:self.layoutObject];
//        collectionView.backgroundColor = [UIColor colorWithWhite:0.940 alpha:1.000];
//        collectionView.delegate = self;
//        collectionView.dataSource = self;
//        collectionView.tag = k+100;// 设置标签，方便后面使用对应的collectionView
//        
//        // 注册类
//        [collectionView registerClass:[LibraryCollectionCell class] forCellWithReuseIdentifier:@"libraryCollectionCell"];
//        
//        [self.contentScrollView addSubview:collectionView];
//    }
//    // 设置scrollView
//    self.contentScrollView.contentSize = CGSizeMake(self.categories.count*w, h);
//}
//
//- (UICollectionView *)libraryCollectionView{
//    _libraryCollectionView = [self.contentScrollView viewWithTag:collectionTag]; // 0-99为苹果公司保留
//    _libraryCollectionView.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
//    return _libraryCollectionView;
//}
//
//// 创建布局对象
//- (UICollectionViewLayout *)layoutObject {
//    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
//    return flowLayout;
//}
//
//#pragma mark --UICollectionViewDelegateFlowLayout
////定义每个UICollectionView 的大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    return CGSizeMake((SCREEN_WIDTH-4*20)/3, (SCREEN_WIDTH-4*20)/3+(SCREEN_WIDTH-4*20)/6);
//}
////定义每个UICollectionView 的 margin
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsMake(10, 20, 10, 20);
//}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    return CGSizeMake(SCREEN_WIDTH, 0);
//}
//
//#pragma mark <UICollectionViewDataSource>
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    return 1;
//}
//// 返回指定section中cell的个数
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    for (NSInteger k = 100; k<listArray.count+100; k++) {
//        if (collectionView.tag==k) {
//            return libraryArray.count;
//        }
//    }
//    return 0;
//}
//// 返回指定位置的cell
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    LibraryCollectionCell *cell = nil;
//    for (NSInteger m = 100; m<listArray.count+100; m++) {
//        if (collectionView.tag == m) {
//            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"libraryCollectionCell" forIndexPath:indexPath];
//            SectionData *data = libraryArray[indexPath.row];
//            cell.libraryImageUrl = data.libraryImageUrl;
//            cell.readtotal = data.libraryReadTotal;
//            return cell;
//        }
//    }
//    
//    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"libraryCollectionCell" forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor grayColor];
//    return cell;
//}
//
//#pragma mark <UICollectionViewDelegate>
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"collectionView.tag = %d,section = %d, row = %d", collectionView.tag,indexPath.section, indexPath.row);
//    
////    // 设置切换动画
////    CATransition *animation = [CATransition animation];
////    animation.duration = 0.7;
////    animation.type = kCATransitionFade;
////    [self.view.window.layer addAnimation:animation forKey:nil];
//    
//    SectionData *data = libraryArray[indexPath.row];
//    KJ_BackTableViewController *kj_svc = [[KJ_BackTableViewController alloc] init];
//    kj_svc.libraryTitle = data.libraryTitle;
//    kj_svc.libraryAuthorName = data.libraryAuthorName;
//    kj_svc.libraryType = data.libraryType;
//    kj_svc.libraryDetails = data.libraryDetails;
//    kj_svc.libraryLanguage = data.libraryLanguage;
//    kj_svc.libraryNum = data.libraryNum;
//    kj_svc.libraryAuthorImageUrl = data.libraryAuthorImageUrl;
//    NSString *string = [NSString stringWithFormat:@"http://218.240.52.135%@",data.libraryImageUrl];
//    
//    kj_svc.libraryImageUrl = string;
//    
//    [[DataModel defaultDataModel] addAllLibrary:kj_svc.libraryNum ImageUrl:kj_svc.libraryImageUrl BookName:kj_svc.libraryTitle AuthorName:kj_svc.libraryAuthorName];
//    
//    [self.navigationController pushViewController:kj_svc animated:NO];
//}

@end

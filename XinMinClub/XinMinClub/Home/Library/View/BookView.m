//
//  BookView.m
//  XinMinClub
//
//  Created by 杨科军 on 16/6/26.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "BookView.h"
#import "LibraryCollectionCell.h"
#import "BookModel.h"
#import "MJRefresh.h"
#import "KJ_BackTableViewController.h"

@interface BookView()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,LibraryModelDelegata>{
    NSMutableArray *libraryArray; // 下面文库数据
    bool off; // 判断数据是否获取到的状态
    NSInteger i; // 上拉刷新
    NSInteger collectionTag; // 第几个collectionView
    NSInteger libraryTotal;  // 书集总数
}

@property(nonatomic, copy) UICollectionView *libraryCollectionView;
@property(nonatomic, copy) UICollectionViewLayout *layoutObject;

@end

@implementation BookView

- (void)setKj_title:(NSString *)kj_title{
    self.title=kj_title;
    _kj_title=kj_title;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    UIImageView *iii=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"beijing"]];
    iii.frame=CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:iii];
    
    off = NO;
    i = 1;
    [BookModel shareObject].libraryModelDelegate = self;
    [[BookModel shareObject] startGetList:[UserDataModel defaultDataModel].userID]; // 开始获取分类列表请求
    
    libraryArray = [NSMutableArray array]; // 创建一个保存collectionView图片的数组，每次刷新后的新增到这个里面
    
    // 注册类
    [self.libraryCollectionView registerClass:[LibraryCollectionCell class] forCellWithReuseIdentifier:@"libraryCollectionCell"];
    [self.view addSubview:self.libraryCollectionView];
}

- (void)reloadWithType:(NSString*)type PageIndex:(NSInteger)pageIndex{
    [[BookModel shareObject] kj_startGetLibraryModelDataUserID:[UserDataModel defaultDataModel].userID Type:type PageIndex:pageIndex];
    // 下拉刷新
    self.libraryCollectionView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 结束刷新
        [self.libraryCollectionView.mj_header endRefreshing];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.libraryCollectionView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    self.libraryCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        i++;
        off=YES;
        if (libraryArray.count>=libraryTotal) {
            [self.libraryCollectionView.mj_footer endRefreshing];
        }
        else
            [[BookModel shareObject] kj_startGetLibraryModelDataUserID:[UserDataModel defaultDataModel].userID Type:type PageIndex:i];
    }];
}

#pragma mark LibraryModelDelegata
- (void)getLibrartList:(NSArray *)listDatas{
    //    for (NSInteger a=0; a<listDatas.count; a++) {
    //        SectionData *daa=listDatas[a];
    //        [listArray addObject:daa.ZY_NAME];
    //    }
    //
    //    [self.categoryList reloadData];
    //    [self addCollectionView];
    [self reloadWithType:@"儒学新编" PageIndex:i];
}
- (void)getLibraryModelDataComplete:(NSArray *)libraryDatas LibraryCount:(NSInteger)libCount{
    [libraryArray addObjectsFromArray:libraryDatas];
    libraryTotal = libCount;
    [self.libraryCollectionView reloadData];
    if (off==YES) {
        // 结束刷新
        [self.libraryCollectionView.mj_footer endRefreshing];
        off=NO;
    }
}

#pragma mark Subviews
- (UICollectionView*)libraryCollectionView{
    if (!_libraryCollectionView) {
        _libraryCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) collectionViewLayout:self.layoutObject];
        _libraryCollectionView.backgroundColor = [UIColor clearColor];
        _libraryCollectionView.delegate = self;
        _libraryCollectionView.dataSource = self;
    }
    return _libraryCollectionView;
}

// 创建布局对象
- (UICollectionViewLayout *)layoutObject {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    return flowLayout;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREEN_WIDTH-4*20)/3, (SCREEN_WIDTH-4*20)/3+(SCREEN_WIDTH-4*20)/6);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 20, 10, 20);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, 0);
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
// 返回指定section中cell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return libraryArray.count;
}
// 返回指定位置的cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LibraryCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"libraryCollectionCell" forIndexPath:indexPath];
    SectionData *data = libraryArray[indexPath.row];
    cell.libraryImageUrl = data.libraryImageUrl;
    cell.readtotal = data.libraryReadTotal;
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"collectionView.tag = %d,section = %d, row = %d", collectionView.tag,indexPath.section, indexPath.row);
    
    //    // 设置切换动画
    //    CATransition *animation = [CATransition animation];
    //    animation.duration = 0.7;
    //    animation.type = kCATransitionFade;
    //    [self.view.window.layer addAnimation:animation forKey:nil];
    
    SectionData *data = libraryArray[indexPath.row];
    KJ_BackTableViewController *kj_svc = [[KJ_BackTableViewController alloc] init];
    kj_svc.libraryTitle = data.libraryTitle;
    kj_svc.libraryAuthorName = data.libraryAuthorName;
    kj_svc.libraryType = data.libraryType;
    kj_svc.libraryDetails = data.libraryDetails;
    kj_svc.libraryLanguage = data.libraryLanguage;
    kj_svc.libraryNum = data.libraryNum;
    kj_svc.libraryAuthorImageUrl = data.libraryAuthorImageUrl;
    NSString *string = [NSString stringWithFormat:@"http://218.240.52.135%@",data.libraryImageUrl];
    
    kj_svc.libraryImageUrl = string;
    
    [[DataModel defaultDataModel] addAllLibrary:kj_svc.libraryNum ImageUrl:kj_svc.libraryImageUrl BookName:kj_svc.libraryTitle AuthorName:kj_svc.libraryAuthorName];
    
    [self.navigationController pushViewController:kj_svc animated:NO];
}


@end

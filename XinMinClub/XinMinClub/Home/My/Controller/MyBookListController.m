//
//  MyBookListController.m
//  XinMinClub
//
//  Created by 赵劲松 on 16/4/27.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "MyBookListController.h"
#import "UserDataModel.h"
#import "SaveModule.h"
#import "LibraryCollectionCell.h"

@interface MyBookListController () <UICollectionViewDataSource> {
    NSArray *listArray;//分类列表
    NSMutableArray *libraryArray; // 下面文库数据
    UICollectionView *bookCollectionView;
}

@end

@implementation MyBookListController

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:[self imageView]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self imageView];
}

- (UIImageView *)imageView {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UserDataModel defaultDataModel].userImage];
    imageView.frame = CGRectMake(200, 100, 160, 160);
    return imageView;
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
// 返回指定section中cell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    for (NSInteger k = 100; k<listArray.count+100; k++) {
        if (collectionView.tag==k) {
            return libraryArray.count;
        }
    }
    return 0;
}
// 返回指定位置的cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LibraryCollectionCell *cell = nil;
    for (NSInteger m = 100; m<listArray.count+100; m++) {
        if (collectionView.tag == m) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"libraryCollectionCell" forIndexPath:indexPath];
            SectionData *data = libraryArray[indexPath.row];
            cell.libraryImageUrl = data.libraryImageUrl;
            cell.readtotal = data.libraryReadTotal;
            return cell;
        }
    }
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"libraryCollectionCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor grayColor];
    return cell;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [[UserDataModel defaultDataModel] saveUserImage];
//    [[UserDataModel defaultDataModel] getUserImage];
    
//    [[UserDataModel defaultDataModel] saveUserInternetData];
//
//    [[UserDataModel defaultDataModel] getUserData];
    
//    [[UserDataModel defaultDataModel] saveRecommend];
//    [[UserDataModel defaultDataModel] deleteRecommend];
    
//    [[UserDataModel defaultDataModel] saveLike];
//    [[UserDataModel defaultDataModel] getRecommend];
//    [[UserDataModel defaultDataModel] getLike];
//    [[SaveModule defaultObject] saveSectionListWithBookID:@"1" firstLevel:@[@"1.1",@"1.2",@"1.3"]];
//    [[SaveModule defaultObject] setSectionListWithBookID:@"1" firstLevel:@[@"1.1"] secondLevel:@[@"1.1.1",@"1.1.2",@"1.1.3",@"1.1.4"]];
}

@end

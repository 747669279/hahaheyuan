//
//  ReadTableViewController.m
//  XinMinClub
//
//  Created by 杨科军 on 16/5/10.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "ReadTableViewController.h"
#import "ReadTableView.h"
#import "SectionModel.h"
#import "MJRefresh.h"
#import <Foundation/NSObject.h>
@interface ReadTableViewController ()<ClickModelDelegate,ReadListModelDelegate>{
    NSArray *kj_readTypeArray;
    NSInteger kj_i;
    BOOL off;
}
@property (nonatomic,strong)NSArray *kj_readListArray;
@property (nonatomic, strong) ReadTableView *readTableView;

@end

@implementation ReadTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    kj_i=0;
    
    // 设置委托对象
    [SectionModel shareObject].readListDelegate=self;
    [SectionModel shareObject].clickDelegate=self;
    
    // 下拉刷新
    self.readTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 结束刷新
        [self.readTableView.mj_header endRefreshing];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.readTableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    self.readTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        kj_i++;
        off=YES;
        if (kj_i<kj_readTypeArray.count){
            [[SectionModel shareObject] startSectionList:kj_readTypeArray[kj_i] IsSectionList:NO];
        }else
            [self.readTableView.mj_footer endRefreshing];
    }];
}

#pragma mark 返回的数据
-(void)setKj_bookID:(NSString *)kj_bookID{
    _kj_bookID = kj_bookID;
    [[SectionModel shareObject] startSectionType:kj_bookID];
}
- (void)getSectionType:(NSArray *)type{
    kj_readTypeArray=type;
    _readTableView.kj_typeee=kj_readTypeArray;
    [[SectionModel shareObject] startSectionList:type[kj_i] IsSectionList:NO];
}
- (void)getSectionReadList:(NSArray *)list{
    self.kj_readListArray=list;
    if (off==YES) {
        // 结束刷新
        [self.readTableView.mj_footer endRefreshing];
        off=NO;
    }
}
-(void)setKj_readListArray:(NSArray *)kj_readListArray{
    _readTableView.kj_x=kj_i;
    _readTableView.readTextArray=kj_readListArray;
    [self.view addSubview:self.readTableView];
}
- (ReadTableView *)readTableView{
    if (!_readTableView) {
        NSInteger y=111;
        NSInteger h=111;
        if (SCREEN_HEIGHT==568) {
            y=60;
            h=110;
        }
        else if (SCREEN_HEIGHT==667) {
            y=90;
        }else{
            y=88;
            h=109;
        }
        
        _readTableView = [[ReadTableView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, SCREEN_HEIGHT-h)];
        // 传递数据
        
        _readTableView.backgroundColor = [UIColor whiteColor];
    }
    return _readTableView;
}

@end

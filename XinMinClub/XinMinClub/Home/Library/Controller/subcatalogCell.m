//
//  subcatalogCell.m
//  XinMinClub
//
//  Created by 贺军 on 16/5/11.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "subcatalogCell.h"
#import "TransferStationObject.h"
#import "KJ_BackTableViewController.h"

@interface subcatalogCell()<UITableViewDelegate,UITableViewDataSource>{
    __weak IBOutlet UITableView *subcatalog;
    NSMutableArray *myData;
    NSMutableArray <NSMutableDictionary *> *saveDictArray;
    NSMutableDictionary *saveDictionary;
    
    NSInteger saveTag; // 点击的是哪个cell
    
    // 传给播放器的数组
    NSMutableArray *detailsListArray;
    NSMutableArray *detailsListIDArray;
    NSMutableArray *detailsMp3Array;
    NSMutableArray *detailsNameArray;
    NSMutableArray *detailsCNArray;
    NSMutableArray *detailsANArray;
    NSMutableArray *detailsENArray;
}

@property(nonatomic, readonly) UIViewController *viewController;

@property (nonatomic, strong) NSString *libraryName;  // 文集名字
@property (nonatomic, strong) NSString *kj_imageUrl;  // 头像Url

@end

@implementation subcatalogCell

//  获取当前view所处的viewController重写读方法
- (UIViewController *)viewController{
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            // 上面if判断是否为UIViewController的子类
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    saveDictArray =[NSMutableArray array];
    myData=[NSMutableArray array];
    
    detailsListIDArray = [NSMutableArray array];
    detailsListArray = [NSMutableArray array];
    detailsMp3Array = [NSMutableArray array];
    detailsNameArray = [NSMutableArray array];
    detailsCNArray = [NSMutableArray array];
    detailsANArray = [NSMutableArray array];
    detailsENArray = [NSMutableArray array];
    
    subcatalog.scrollEnabled = NO;
    subcatalog.dataSource=self;
    subcatalog.delegate=self;
}

-(void)setData:(NSMutableArray *)data{
    myData=data;
    [subcatalog reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return myData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.text= [NSString stringWithFormat:@"     %@",myData[indexPath.row]];
    cell.textLabel.textColor=[UIColor redColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self abcccc:indexPath.row];
}

- (void)abcccc:(NSInteger)kaa{
    // 传递书集名字
    SectionData *da=_kj_sectionDataArray[kaa];
    _libraryName=da.libraryTitle;
    
    if (da.libraryAuthorImageUrl!=nil) {
        _kj_imageUrl=da.libraryAuthorImageUrl;
    }else
        _kj_imageUrl=_imageUlr_kk;
    
    // 保存点击的是哪个cell
    saveTag = kaa;
    // 整理数组
    [self arrangeAndSaveDataArray];
    // 存入到字典当中
    [self saveDataToDictionary];
    NSInteger a = [[saveDictArray[saveTag] valueForKey:@"CN"] integerValue]==1 ? 1:0; //a=1点击这个有中文
    NSInteger b = [[saveDictArray[saveTag] valueForKey:@"AN"] integerValue]==1 ? 1:0;
    NSInteger c = [[saveDictArray[saveTag] valueForKey:@"EN"] integerValue]==1 ? 1:0;
    
    // 默认简体中文
    switch ([DataModel defaultDataModel].setDefaultLanguage) {
        case 0: // 默认中文
            if (a) {
                [self popWithArray:detailsCNArray];
            }else{
                [self alertView:@[@(a),@(b),@(c)]];
            }
            break;
        case 1: // 默认繁体
            if (b) {
                [self popWithArray:detailsANArray];
            }else{
                [self alertView:@[@(a),@(b),@(c)]];
            }
            break;
        case 2: // 默认英文
            if (c) {
                [self popWithArray:detailsENArray];
            }else{
                [self alertView:@[@(a),@(b),@(c)]];
            }
            break;
    }
}

#pragma mark 整理与保存传入过来的数据到各个数组当中
- (void)arrangeAndSaveDataArray{
    [detailsListIDArray removeAllObjects]; // 清空数组
    [detailsListArray removeAllObjects]; // 清空数组
    [detailsMp3Array removeAllObjects]; // 清空数组
    [detailsCNArray removeAllObjects]; // 清空数组
    [detailsANArray removeAllObjects]; // 清空数组
    [detailsENArray removeAllObjects]; // 清空数组
    [detailsNameArray removeAllObjects];
    
    for (NSInteger k=0; k<_kj_sectionDataArray.count; k++) {
        SectionData *data = _kj_sectionDataArray[k];
        [detailsListArray addObject:data.clickTitle];
        [detailsListIDArray addObject:data.clickSectionID];
        [detailsMp3Array addObject:data.clickMp3];
        [detailsCNArray addObject:data.clickSectionCNText];
        [detailsANArray addObject:data.clickSectionANText];
        [detailsENArray addObject:data.clickSectionENText];
        [detailsNameArray addObject:data.clickAuthor];
    }
}

-(void)saveDataToDictionary{
    //saveDictArray 存放编辑好键值对
    [saveDictArray removeAllObjects];
    for (NSInteger i=0; i<_kj_sectionDataArray.count; i++) {
        saveDictionary = [NSMutableDictionary dictionary];
        [saveDictionary addEntriesFromDictionary:@{@"arrayTag":@(0),@"CN":@(0),@"AN":@(0),@"EN":@(0)}];
        if(![detailsCNArray[i] isEqualToString:@""])
            [saveDictionary addEntriesFromDictionary:@{@"arrayTag":@(i),@"CN":@(1)}];
        if(![detailsANArray[i] isEqualToString:@""])
            [saveDictionary addEntriesFromDictionary:@{@"arrayTag":@(i),@"AN":@(1)}];
        if(![detailsENArray[i] isEqualToString:@""])
            [saveDictionary addEntriesFromDictionary:@{@"arrayTag":@(i),@"EN":@(1)}];
        [saveDictArray addObject:saveDictionary];
    }
}

- (void)popWithArray:(NSArray *)array1{
    [[TransferStationObject shareObject] IncomingDataLibraryName:_libraryName ImageUrl:_kj_imageUrl  AuthorName:detailsNameArray ClickCellNum:saveTag+1 SectionName:detailsListArray SectionMp3:detailsMp3Array SectionID:detailsListIDArray SectionText:array1 block:^(BOOL successful) {
        if (successful) {
            [self kj_pushIsPlayerOrEBook:1];
        }else
            [self kj_pushIsPlayerOrEBook:2];
    }];
}

// 通知的方法
- (void)kj_pushIsPlayerOrEBook:(NSInteger)aaa{
    NSDictionary *diccc = @{@"kj_pushIsPlayerOrEBook":@(aaa)};
    KJ_BackTableViewController *kj_bvc = [[KJ_BackTableViewController alloc] init];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kj_pushIsPlayerOrEBook" object:kj_bvc userInfo:diccc];
}

- (void)alertView:(NSArray *)parameter{
    NSString *selectLangue;
    if ([DataModel defaultDataModel].setDefaultLanguage==0) {
        selectLangue = @"简体中文";
    }else if ([DataModel defaultDataModel].setDefaultLanguage==1){
        selectLangue = @"繁体中文";
    }else{
        selectLangue = @"English";
    }
    
    NSString *aa = [NSString stringWithFormat:@"该文集没有%@版本,请重新选择语言!",selectLangue];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警  告" message:aa preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"简体中文" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[TransferStationObject shareObject] IncomingDataLibraryName:_libraryName ImageUrl:_kj_imageUrl  AuthorName:detailsNameArray ClickCellNum:saveTag+1 SectionName:detailsListArray SectionMp3:detailsMp3Array SectionID:detailsListIDArray SectionText:detailsCNArray block:^(BOOL successful) {
            if (successful) {
                [self kj_pushIsPlayerOrEBook:1];
            }else
                [self kj_pushIsPlayerOrEBook:2];
        }];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"繁体中文" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[TransferStationObject shareObject] IncomingDataLibraryName:_libraryName ImageUrl:_kj_imageUrl  AuthorName:detailsNameArray ClickCellNum:saveTag+1 SectionName:detailsListArray SectionMp3:detailsMp3Array SectionID:detailsListIDArray SectionText:detailsANArray block:^(BOOL successful) {
            if (successful) {
                [self kj_pushIsPlayerOrEBook:1];
            }else
                [self kj_pushIsPlayerOrEBook:2];
        }];
    }];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"English" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[TransferStationObject shareObject] IncomingDataLibraryName:_libraryName ImageUrl:_kj_imageUrl  AuthorName:detailsNameArray ClickCellNum:saveTag+1 SectionName:detailsListArray SectionMp3:detailsMp3Array SectionID:detailsListIDArray SectionText:detailsENArray block:^(BOOL successful) {
            if (successful) {
                [self kj_pushIsPlayerOrEBook:1];
            }else
                [self kj_pushIsPlayerOrEBook:2];
        }];
    }];
    
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"取  消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    NSString *a1 = [NSString stringWithFormat:@"%@",parameter[0]];
    NSString *a2 = [NSString stringWithFormat:@"%@",parameter[1]];
    NSString *a3 = [NSString stringWithFormat:@"%@",parameter[2]];
    if ([a1 isEqualToString:@"1"]) {
        [alertController addAction:action1];
    }
    if ([a2 isEqualToString:@"1"]) {
        [alertController addAction:action2];
    }
    if ([a3 isEqualToString:@"1"]) {
        [alertController addAction:action3];
    }
    
    [alertController addAction:action4];
    [self.viewController presentViewController:alertController animated:YES completion:NULL];
}


@end

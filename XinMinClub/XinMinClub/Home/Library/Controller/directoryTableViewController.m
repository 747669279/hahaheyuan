
//  directoryTableViewController.m
//  XinMinClub
//
//  Created by 贺军 on 16/5/5.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "directoryTableViewController.h"
#import "SectionModel.h"
#import "UIView+SDAutoLayout.h"
#import "subcatalogCell.h"
#import "HomeViewController.h"
#import "TransferStationObject.h"

@interface directoryTableViewController ()<UITableViewDelegate,UITableViewDataSource,ListModelDelegate,ClickModelDelegate> {
    NSArray *sectionTypeArray; // 章节分类
    NSArray *sectionListArray; // 章节二级分类列表
    UITableViewCell *kj_cell;
    NSInteger kj_clickCellNum; // 点击的是哪个cell
    NSMutableDictionary *kj_dict;
    NSString *kj_key; // 键
    NSMutableArray *kj_textArray;
    
    NSInteger kj_k; // 请求到第几个目录数据
    BOOL kj_clickCellStatus; // 点击cell的状态
    BOOL kj_touchCellStatus;  // 模拟点击了cell状态（处理章节播放结束，请求数据继续播放的情况）
    
    NSInteger kj_kaiguan;// 多次点击cell的开关
    
    // 设置箭头
    UIImage *imm1;
    UIImage *imm2;
    UIImageView *kj_imm1;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation directoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    kj_dict = [NSMutableDictionary new];
    kj_textArray = [NSMutableArray new];
    
    kj_clickCellStatus=NO;
    kj_clickCellNum=-2;
    kj_k=0;
    kj_kaiguan=0;
    
    imm1 = [UIImage imageNamed:@"setbutton"];
    imm2 = [UIImage imageNamed:@"actionbutton"];
    
    kj_touchCellStatus=NO;
    
    UINib *nib=[UINib nibWithNibName:@"subcatalogCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"subcaCell"];
    [SectionModel shareObject].listDelegate=self;
    [SectionModel shareObject].clickDelegate = self;
    [self.view addSubview:self.tableView];
    
    // 监听属性“PlayCompleteState”
    /* KVO: listen for changes to our earthquake data source for table view updates
     HomeViewController类名,在类里面声明一个属性PlayCompleteState,@“PlayCompleteState"属性名字符串来访问对象属性
     */
    [[HomeViewController shareObject] addObserver:self forKeyPath:@"p_CompleteState" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark 键值监听
// 播放列表歌曲播放结束，继续请求数据
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    //监听发生变化调用
    NSLog(@"kkkeyPath%@,oooobject%@,cccchange:%@,context:%@",keyPath,object,change,context);
    if ([keyPath isEqualToString:@"p_CompleteState"]) {
        kj_k++;
        if (kj_k>=sectionTypeArray.count) {
            return;
        }
        else{
            kj_clickCellNum+=2;
            kj_touchCellStatus=YES;
            [[SectionModel shareObject] startSectionList:sectionTypeArray[kj_k] IsSectionList:YES];
        }
    }
}

- (void)dealloc{
    // 移除监听
    [[HomeViewController shareObject] removeObserver:self forKeyPath:@"p_CompleteState"];
}

- (void)setKj_libraryNum:(NSString *)kj_libraryNum{
    [[SectionModel shareObject] startSectionType:kj_libraryNum];
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}

#pragma mark 判断是否滚动到顶部
- (void)setHasBeenTo:(BOOL)hasBeenTo{
    if (hasBeenTo) {
        self.tableView.scrollEnabled = YES;
    }else
        self.tableView.scrollEnabled = NO;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.bounds.origin.y <= 0){
        self.whenTheTop = YES;
        self.tableView.scrollEnabled = NO;
    }
}

#pragma mark ClickModelDelegate
- (void)getSectionType:(NSArray *)type{
    sectionTypeArray = type;
    [self.tableView reloadData];
}
#pragma mark ListModelDelegate
- (void)getSectionList:(NSArray *)list{
    [kj_textArray removeAllObjects]; // 清空数组
    sectionListArray = list;
    [kj_dict addEntriesFromDictionary:@{sectionTypeArray[kj_clickCellNum/2]:sectionListArray}];
    kj_key=[NSString stringWithFormat:@"%@",sectionTypeArray[kj_clickCellNum/2]];
    for (NSInteger k=0; k<((NSArray*)[kj_dict valueForKey:kj_key]).count; k++) {
        SectionData *data = ((NSArray*)[kj_dict valueForKey:kj_key])[k];
        [kj_textArray addObject:data.clickTitle];
    }
    
    if (kj_touchCellStatus==YES) {
        kj_touchCellStatus=NO;
        [self aabb:list];
        return;
    }
    [self.tableView reloadData];
}

- (void)aabb:(NSArray*)abc{
    
    NSMutableArray *detailsListIDArray = [NSMutableArray array];
    NSMutableArray *detailsListArray = [NSMutableArray array];
    NSMutableArray *detailsMp3Array = [NSMutableArray array];
    NSMutableArray *detailsNameArray = [NSMutableArray array];
    NSMutableArray *detailsCNArray = [NSMutableArray array];
    NSMutableArray *detailsANArray = [NSMutableArray array];
    NSMutableArray *detailsENArray = [NSMutableArray array];
    NSString *libName;
    
    for (NSInteger k=0; k<abc.count; k++) {
        SectionData *data = abc[k];
        libName=data.libraryTitle;
        [detailsListArray addObject:data.clickTitle];
        [detailsListIDArray addObject:data.clickSectionID];
        [detailsMp3Array addObject:data.clickMp3];
        [detailsCNArray addObject:data.clickSectionCNText];
        [detailsANArray addObject:data.clickSectionANText];
        [detailsENArray addObject:data.clickSectionENText];
        [detailsNameArray addObject:data.clickAuthor];
    }
    
    // 传递数据
    [[TransferStationObject shareObject] IncomingDataLibraryName:libName ImageUrl:_kj_imageUrll AuthorName:detailsNameArray ClickCellNum:1 SectionName:detailsListArray SectionMp3:detailsMp3Array SectionID:detailsListIDArray SectionText:detailsCNArray data:nil block:^(BOOL successful) {
        
    }];
}


#pragma mark - TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return sectionTypeArray.count*2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (kj_clickCellNum+1==indexPath.row) {
        switch (kj_clickCellStatus) {
            case YES:
                return kj_textArray.count*40;
                break;
                
            case NO:
                return 0.1;
                break;
        }
    }
    if (indexPath.row%2!=0) {
        return 0.1;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    kj_cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!kj_cell) {
        kj_cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if (indexPath.row%2==0) {
        switch (kj_clickCellStatus) {
            case YES:
                if (kj_clickCellNum!=indexPath.row) {
                    kj_imm1=[[UIImageView alloc]initWithImage:imm1];
                }else
                    kj_imm1=[[UIImageView alloc]initWithImage:imm2];
                break;
                
            case NO:
                kj_imm1=[[UIImageView alloc]initWithImage:imm1];
                break;
        }
        kj_cell.accessoryView=kj_imm1;
        kj_cell.textLabel.text=[NSString stringWithFormat:@"%@",sectionTypeArray[indexPath.row/2]];
    }else{
        kj_cell=[tableView dequeueReusableCellWithIdentifier:@"subcaCell" forIndexPath:indexPath];
        // 传递数据
        ((subcatalogCell*)kj_cell).data=kj_textArray;
        ((subcatalogCell*)kj_cell).imageUlr_kk=_kj_imageUrll;
        ((subcatalogCell*)kj_cell).kj_sectionDataArray=((NSArray*)[kj_dict valueForKey:kj_key]);
    }
    kj_cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    kj_cell.sd_tableView = tableView;
    kj_cell.sd_indexPath = indexPath;
    //////////////////////////////////////////////////////////////////
    return kj_cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (kj_clickCellNum!=indexPath.row) {
        kj_kaiguan=0;
    }
    kj_kaiguan++;
    switch (kj_kaiguan%2) {
        case 1:
            kj_clickCellStatus=YES;
            [[SectionModel shareObject] startSectionList:sectionTypeArray[indexPath.row/2] IsSectionList:YES];
            kj_clickCellNum=indexPath.row;
            kj_k=indexPath.row/2;
            break;
        case 0:
            if (kj_clickCellNum==indexPath.row) {
                kj_clickCellStatus=NO;
                [self.tableView reloadData];
                return;
            }
            break;
    }
}

@end

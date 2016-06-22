//
//  FinishDownload.m
//  XinMinClub
//
//  Created by 赵劲松 on 16/3/30.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "FinishDownload.h"
#import "ManageCell.h"
#import "BookCell.h"
#import "DataModel.h"
#import "UserDataModel.h"
#import "SectionManageView.h"
#import "DeleteController.h"
#import "ProcessSelect.h"

#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height) // 屏幕高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width) // 屏幕宽度

@interface FinishDownload () <ManageDelegate, SectionDelegate, SectionManageDelegate> {
    
    UIView *searchView_;
    UINib *nib_;
    NSInteger selectedCell;

    DataModel *dataModel_;
    UserDataModel *userModel_;
    SectionManageView *smView_;
    UIControl *smBackView_;

}

@end

@implementation FinishDownload

static NSString *manageCell = @"manageCell";
static NSString *bookCell = @"bookCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataModel_ = [DataModel defaultDataModel];
    self.title = @"歌曲";
    // 选择的cell
    selectedCell = -1;
    nib_ = [UINib nibWithNibName:@"ManageCell" bundle:nil];
    [self.tableView registerNib:nib_ forCellReuseIdentifier:manageCell];
    nib_ = [UINib nibWithNibName:@"BookCell" bundle:nil];
    [self.tableView registerNib:nib_ forCellReuseIdentifier:bookCell];
    self.tableView.tableHeaderView = [self searchView];
    self.tableView.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self smBackTap];
}

- (id)init {
    if (self = [super init]) {
        _sectionNum = 10;
    }
    return self;
}

- (UIView *)searchView {
    if (!searchView_) {
        searchView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    }
    searchView_.backgroundColor = [UIColor colorWithWhite:0.953 alpha:1.000];
    return searchView_;
}

#pragma mark Actions

- (void)smBackTap {
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        smBackView_.backgroundColor = [UIColor clearColor];
        smView_.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
    } completion:^(BOOL finished) {
        smBackView_.hidden = YES;
    }];
}

- (void)cacenl {
    [self smBackTap];
}

#pragma mark ManageDelegate

- (void)manageAll {
    DeleteController *delete = [[DeleteController alloc] init];
    delete.deleteArr = [DataModel defaultDataModel].allSection;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:delete];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)playAll {
    NSLog(@"播放全部");
}

#pragma mark SectionManageDelegate

- (void)sectionManage:(NSInteger)tag {
    if (!smBackView_) {
        smBackView_ = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [smBackView_ addTarget:self action:@selector(smBackTap) forControlEvents:UIControlEventTouchUpInside];
        smBackView_.hidden = YES;
        smBackView_.backgroundColor = [UIColor clearColor];
        [self.view.superview.window addSubview:smBackView_];
    }
    
    CGRect frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
    smView_ = [[SectionManageView alloc] initWithFrame:frame];
    smView_.backgroundColor = [UIColor whiteColor];
    smView_.delegate = self;
    [self.view.superview.window addSubview:smView_];
    smView_.data = (SectionData *)dataModel_.downloadSection[tag - 13000];
    [SectionOperation sectionManage:smBackView_ StatusView:smView_ andViewController:nil];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (dataModel_.downloadSection.count == 0) {
        return dataModel_.downloadSection.count;
    } else {
        return dataModel_.downloadSection.count + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:manageCell forIndexPath:indexPath];
        ((ManageCell *)cell).manageDelegate = self;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:bookCell forIndexPath:indexPath];
        ((BookCell *) cell).sectionsName.text = ((SectionData *)dataModel_.downloadSection[indexPath.row - 1]).sectionName;
        
        ((BookCell *) cell).authorName.text = ((SectionData *)dataModel_.downloadSection[indexPath.row - 1]).author;
        ((BookCell *) cell).statusView.hidden = YES;
        ((BookCell *) cell).delegate = self;
        ((BookCell *) cell).accessoryButton.tag = indexPath.row - 1 + 13000;
        if ([((SectionData *)dataModel_.downloadSection[indexPath.row - 1]).sectionID isEqual:dataModel_.playingSection.sectionID]) {
            ((BookCell *) cell).statusView.hidden = NO;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProcessSelect *select = [[ProcessSelect alloc] init];
    [select processTableSelect:tableView didSelectRowAtIndexPath:indexPath forData:dataModel_.downloadSection inViewController:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

@end

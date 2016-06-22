//
//  ResentPlay.m
//  XinMinClub
//
//  Created by 赵劲松 on 16/3/30.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "ResentPlay.h"
#import "ManageCell.h"
#import "BookCell.h"
#import "DataModel.h"
#import "UserDataModel.h"
#import "SectionManageView.h"
#import "DeleteController.h"
#import "ProcessSelect.h"

#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height) // 屏幕高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width) // 屏幕宽度

@interface ResentPlay () <ManageDelegate, SectionDelegate, SectionManageDelegate> {
    
    UIView *searchView_;
    UINib *nib_;
    NSInteger selectedCell;
    UIImageView *backImageView_;
    UILabel *backLabel_;
    
    DataModel *dataModel_;
    UserDataModel *userModel_;
    SectionManageView *smView_;
    UIControl *smBackView_;
}

@end

@implementation ResentPlay


- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataModel_ = [DataModel defaultDataModel];
    self.title = @"最近播放";
    
    [self initViews];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self smBackTap];
}

static NSString *manageCell = @"manageCell";
static NSString *bookCell = @"bookCell";

- (void)initViews {
    
//    NSData *compressedImageData = [[NSData alloc] initWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"11.jpg"], 1)];
//    NSLog(@"图片数据：%@",compressedImageData);
    
    // 选择的cell
    selectedCell = -1;
    nib_ = [UINib nibWithNibName:@"ManageCell" bundle:nil];
    [self.tableView registerNib:nib_ forCellReuseIdentifier:manageCell];
    nib_ = [UINib nibWithNibName:@"BookCell" bundle:nil];
    [self.tableView registerNib:nib_ forCellReuseIdentifier:bookCell];
    
    // 任意添加一个高度为0.01的view
    self.tableView.tableHeaderView = [self searchView];
    [self.view addSubview:[self backImageView]];
    [self.view addSubview:[self backLabel]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    if (dataModel_.recentPlay.count == 0) {
        backImageView_.hidden = NO;
        backLabel_.hidden = NO;
        self.tableView.userInteractionEnabled = NO;
    }
    else {
        backImageView_.hidden = YES;
        backLabel_.hidden = YES;
        self.tableView.userInteractionEnabled = YES;
    }
}

- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
        dataModel_ = [DataModel defaultDataModel];
    }
    return self;
}

#pragma mark Views

- (UIView *)searchView {
    if (!searchView_) {
        searchView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    }
    searchView_.backgroundColor = [UIColor colorWithWhite:0.953 alpha:1.000];
    return searchView_;
}

- (UIImageView *)backImageView {
    if (!backImageView_) {
        backImageView_ = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2"]];
        backImageView_.frame = CGRectMake(0, 0, SCREEN_WIDTH / 2, SCREEN_WIDTH / 2);
        backImageView_.center = CGPointMake(self.view.center.x, self.view.center.y - SCREEN_WIDTH / 3);
    }
    return backImageView_;
}

- (UILabel *)backLabel {
    if (!backLabel_) {
        backLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 60)];
        backLabel_.text = @"还没有播放哦!";
        [backLabel_ setFont:[UIFont systemFontOfSize:15]];
        backLabel_.textColor = [UIColor colorWithWhite:0.696 alpha:1.000];
        backLabel_.textAlignment = NSTextAlignmentCenter;
        backLabel_.backgroundColor = [UIColor clearColor];
        backLabel_.center = CGPointMake(self.view.center.x, backImageView_.frame.origin.y + backImageView_.bounds.size.height + 30);
    }
    return backLabel_;
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
    delete.deleteArr = [DataModel defaultDataModel].recentPlay;
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
    smView_.data = (SectionData *)dataModel_.recentPlay[tag - 15000];
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
    if (dataModel_.recentPlay.count == 0) {
        return dataModel_.recentPlay.count;
    } else {
        return dataModel_.recentPlay.count + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:manageCell forIndexPath:indexPath];
        ((ManageCell *)cell).manageDelegate = self;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:bookCell forIndexPath:indexPath];
        ((BookCell *) cell).sectionsName.text = ((SectionData *)dataModel_.recentPlay[indexPath.row - 1]).sectionName;
        
        ((BookCell *) cell).authorName.text = [NSString stringWithFormat:@"%@  播放次数:%d",((SectionData *)dataModel_.recentPlay[indexPath.row - 1]).author, [((SectionData *)dataModel_.recentPlay[indexPath.row - 1]).playCount intValue]];
        ((BookCell *) cell).statusView.hidden = YES;
        ((BookCell *) cell).delegate = self;
        ((BookCell *) cell).accessoryButton.tag = indexPath.row - 1 + 15000;
        if ([((SectionData *)dataModel_.recentPlay[indexPath.row - 1]).sectionID isEqual:dataModel_.playingSection.sectionID]) {
            ((BookCell *) cell).statusView.hidden = NO;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProcessSelect *select = [[ProcessSelect alloc] init];
    [select processTableSelect:tableView didSelectRowAtIndexPath:indexPath forData:dataModel_.recentPlay inViewController:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

@end

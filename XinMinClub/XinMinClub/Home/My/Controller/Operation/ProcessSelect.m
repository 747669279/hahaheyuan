    //
//  ProcessSelect.m
//  XinMinClub
//
//  Created by 赵劲松 on 16/4/27.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "ProcessSelect.h"
#import "BookCell.h"
#import "DataModel.h"
#import "TransferStationObject.h"
#import "UserDataModel.h"

@interface ProcessSelect () {
    TransferStationObject *transfer_;
}

@end

@implementation ProcessSelect

- (id)init {
    if (self = [super init]) {
        transfer_ = [TransferStationObject shareObject];
    }
    return self;
}

- (void)processTableSelect:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath forData:(id)data inViewController:(UIViewController *)viewController{
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:10];
    arr = (NSMutableArray *)data;
//    NSLog(@"%@",arr);
    
    DataModel *dataModel_ = [DataModel defaultDataModel];
    
    if (indexPath.section == 0) {
        if (indexPath.row > 0) {
            
            SectionData *data = ((SectionData *)arr[indexPath.row - 1]);
            
            BookCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.statusView.hidden = NO;
            // 是否添加最近播放
            if (!data.isAddRecent) {
                [dataModel_.recentPlay insertObject:data atIndex:0];
                data.isAddRecent = YES;
            }
            // 判断、设置播放状态等
            if (![data isEqual:((SectionData *)dataModel_.playingSection)]) {
                dataModel_.playingSection = arr[indexPath.row - 1];
                // 设置播放次数
                NSInteger a = [data.playCount intValue];
                a++;
                NSLog(@"%@playCount:%d", data.sectionName, a);
                data.playCount = [NSString stringWithFormat:@"%d",a];
                [dataModel_.recentPlayIDAndCount setObject:data.playCount forKey:data.sectionID];
                
                // 设置cell选中状态
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
                [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
                NSArray *sectionName = @[data.sectionName];
                NSArray *sectionID = @[data.sectionID];
                
                [[UserDataModel defaultDataModel] saveLocalData];
                
                [transfer_ IncomingDataLibraryName:nil  ImageUrl:nil  AuthorName:nil ClickCellNum:0 SectionName:sectionName SectionMp3:nil SectionID:sectionID SectionText:nil block:^(BOOL successful) {
                    NSLog(@"播放成功");
                }];
            }
        }
    }
}

@end

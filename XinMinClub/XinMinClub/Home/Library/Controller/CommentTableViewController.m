//
//  CommentTableViewController.m
//  XinMinClub
//
//  Created by 赵劲松 on 16/8/2.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "CommentTableViewController.h"
#import "CommentCell.h"

@interface CommentTableViewController () <UITextViewDelegate> {
    
    UINib *nib_;
    CommentCell *cell_;
    UserDataModel *userDataModel_;
}

@end

@implementation CommentTableViewController

static NSString * userFirstIdentifier = @"comment";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelf];
}

- (void)initSelf {
    
    self.title = @"评论";
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame = CGRectMake(0, 0, 40, 30);
    [rightButton setTitle:@"发表" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(publishComment) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    leftButton.frame = CGRectMake(0, 0, 40, 30);
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    nib_ = [UINib nibWithNibName:@"CommentCell" bundle:nil];
    [self.tableView registerNib:nib_ forCellReuseIdentifier:userFirstIdentifier];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    //添加观察者,监听键盘弹出，隐藏事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark NavAction (取消和发表动作)

- (void)publishComment {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    cell_ = (CommentCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [self.delegate content:cell_.userDetailDataField.text];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancel{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark KeyBoard (键盘弹出收回)

//键盘弹出时不产生遮挡关系的设置
- (void)keyboardShow:(NSNotification *)notify{
//    
//    indexPath_ = [NSIndexPath indexPathForRow:0 inSection:userLabelArr_.count - 1];
//    cell_ = (UserFirstCell *)[userTableView_ cellForRowAtIndexPath:indexPath_];
//    if (!isFirst)
//        return;
//    isFirst = NO;
//    if (cell_.userDetailDataField.isFirstResponder) {
//        //获取高度差
//        CGFloat deltaH = -userTableView_.frame.size.height / 7 * 2;
//        
//        [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
//            CGRect frame = userTableView_.frame;
//            frame = CGRectMake(frame.origin.x, frame.origin.y + deltaH , frame.size.width, frame.size.height);
//            userTableView_.frame = frame;
//        } completion:nil];
//    }
    
    NSDictionary* info = [notify userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    cell_ = (CommentCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    CGRect frame = cell_.userDetailDataField.frame;
    cell_.frame = CGRectMake(frame.origin.x, frame.origin.y, SCREEN_WIDTH, SCREEN_HEIGHT - kbSize.height * 1.3);
}

//键盘隐藏
- (void)keyboardHide:(NSNotification *)notify{
    
//    isFirst = YES;
//    CGRect frame = userTableView_.frame;
//    frame = CGRectMake(frame.origin.x, 0, frame.size.width, frame.size.height);
//    userTableView_.frame = frame;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    cell_ = (CommentCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    CGRect frame = cell_.userDetailDataField.frame;
//    cell_.frame = CGRectMake(frame.origin.x, frame.origin.y, SCREEN_WIDTH, SCREEN_HEIGHT);
}

#pragma mark UITextViewDelegate (用户简介长度)

- (void)textViewDidChange:(UITextView *)textView {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    cell_ = (CommentCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    dispatch_async(dispatch_get_main_queue(), ^{
        cell_.textNumber.text = [NSString stringWithFormat:@"%d字", 130 - [textView.text length]];
    });
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 160;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommentCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:userFirstIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.userLabel.hidden = YES;
    cell.userDetailLabel.hidden = YES;
    cell.userDetailDataField.hidden = NO;
    cell.userDataField.hidden = YES;
    cell.textNumber.hidden = NO;
    cell.userDetailDataField.delegate = self;
    cell.backgroundColor = [UIColor blueColor];
    cell.userDetailDataField.keyboardType = UIKeyboardTypeDefault;
    cell.textNumber.text = [NSString stringWithFormat:@"%d字", 130 - [userDataModel_.userIntroduction length]];
//    cell.userDetailDataField.text = userDataModel_.userIntroduction;
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

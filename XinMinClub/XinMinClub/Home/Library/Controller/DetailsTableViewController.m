//
//  DetailsTable.m
//  XinMinClub
//
//  Created by 杨科军 on 16/5/6.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "DetailsTableViewController.h"
#import "DetailsCell1.h"
#import "DetailsCell2.h"
#import "DetailsCell3.h"
#import "CommentModel.h"
#import "SVProgressHUD.h"

@interface DetailsTableViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate,CommentModelDelegate>{
    NSArray *commentArray;
    SectionData *commentData;
    NSString *userContent;
}

@property(nonatomic,copy) UITableView *tableView;
@property(nonatomic,copy) UIView *backView;

@end

@implementation DetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.backView];
    [self.view addSubview:self.tableView];
    [CommentModel shareObject].commentDelegate = self;
    [[CommentModel shareObject] startGetComment:_libraryID];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    UINib *de1 = [UINib nibWithNibName:@"DetailsCell1" bundle:nil];
    [self.tableView registerNib:de1 forCellReuseIdentifier:@"detailsCell1"];
    UINib *de2 = [UINib nibWithNibName:@"DetailsCell2" bundle:nil];
    [self.tableView registerNib:de2 forCellReuseIdentifier:@"detailsCell2"];
    UINib *de3 = [UINib nibWithNibName:@"DetailsCell3" bundle:nil];
    [self.tableView registerNib:de3 forCellReuseIdentifier:@"detailsCell3"];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.backView addGestureRecognizer:singleTap];
    
    // 这个可以加到任何控件上,比如你只想响应WebView，我正好填满整个屏幕
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
    
    // 添加观察者,监听键盘弹出，隐藏事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [_detailsTextField resignFirstResponder];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)setLibraryID:(NSString *)libraryID{
    _libraryID=libraryID;
    [[CommentModel shareObject] startGetComment:libraryID];
}

- (void)setKj_hasBeenTo:(BOOL)kj_hasBeenTo{
    if (kj_hasBeenTo) {
        self.tableView.scrollEnabled = YES;
    }else
        self.tableView.scrollEnabled = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.bounds.origin.y <= 0){
        self.kj_whenTheTop = YES;
        self.tableView.scrollEnabled = NO;
    }
}

#pragma mark CommentModelDelegate
- (void)getComment:(NSArray *)comment{
    if (comment.count==0) {
        NSLog(@"kong!!");
    }else
        commentArray = comment;
//    NSLog(@"commentArray:%@",commentArray);
    [self.tableView reloadData];
}

#pragma mark 手势(解决点击收键盘事件)
// 然后有一个关键的，要实现一个方法：
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

// 最后，响应的方法中，可以获取点击的坐标哦！
-(void)handleSingleTap:(UITapGestureRecognizer *)sender{
//    CGPoint point = [sender locationInView:self.backView];
    [_detailsTextField resignFirstResponder];
    [self.view bringSubviewToFront:self.tableView];
}

- (NSArray *)textArray{
    return @[@"作者",@"分类",@"语言",@"简介"];
}

#pragma mark Subviews
- (UITableView *)tableView{
    if (!_tableView) {
        CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];

    }
    return _tableView;
}

- (UIView *)backView{
    if (_backView==nil) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*2/3)];
        _backView.backgroundColor = [UIColor clearColor];
    }
    return _backView;
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return self.textArray.count+1;
    }
    return commentArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if(indexPath.row == 0){
            return 80;
        }
        if(indexPath.row == self.textArray.count){
            return 150;
        }
        return 50;
    }
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (indexPath.section==0&&indexPath.row==0) {
        DetailsCell3 *cell = [tableView dequeueReusableCellWithIdentifier:@"detailsCell3" forIndexPath:indexPath];
        cell.imageUrl = self.detailsTextArray[0];
        cell.libraryName = self.detailsTextArray[1];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor colorWithWhite:0.373 alpha:1.000];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section==0&&indexPath.row>0){
        DetailsCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"detailsCell1" forIndexPath:indexPath];
        cell.details1Text = self.textArray[indexPath.row-1];
        cell.details1Title = self.detailsTextArray[indexPath.row+1];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor colorWithWhite:0.373 alpha:1.000];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"detailsCell2" forIndexPath:indexPath];
    commentData = commentArray[indexPath.row];
    ((DetailsCell2*)cell).detailsImageUrl = commentData.commentImageUrl;
    ((DetailsCell2*)cell).details2Text = commentData.commentName;
    ((DetailsCell2*)cell).details2Time = commentData.commentTime;
    ((DetailsCell2*)cell).details2Title = commentData.commentText;
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textColor = [UIColor colorWithWhite:0.373 alpha:1.000];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 30;
    }
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 60;
    }
    return 0.1;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *aView = [UIView new];
    if (section == 1) {
        aView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
        aView.backgroundColor = [UIColor colorWithWhite:0.898 alpha:1.000];
        UILabel *aaa = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 30)];
        aaa.text = @"用户评价";
        
        [aView addSubview:aaa];
    }
    
    return aView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *detailsView;
    if (section==1) {
        detailsView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
        detailsView.backgroundColor = [UIColor colorWithWhite:0.898 alpha:1.000];
        
        _detailsTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width*3/4-10, 40)];
        [_detailsTextField setBorderStyle:UITextBorderStyleRoundedRect]; //外框类型
        _detailsTextField.keyboardType = UIKeyboardTypeDefault;
        _detailsTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _detailsTextField.returnKeyType = UIReturnKeyDone;
        _detailsTextField.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
        
        _detailsTextField.delegate = self;
        
        UIButton *detailsButon = [UIButton buttonWithType:UIButtonTypeCustom];
        detailsButon.frame = CGRectMake(self.view.frame.size.width*3/4+5, 10, self.view.frame.size.width/4-15, 40);
        [detailsButon setTitle:@"发送" forState:UIControlStateNormal];
        [detailsButon setTitleColor:[UIColor colorWithRed:0.553 green:0.281 blue:0.248 alpha:1.000] forState:UIControlStateNormal];
        [detailsButon addTarget:self action:@selector(updateUser) forControlEvents:UIControlEventTouchUpInside];
        
        detailsButon.layer.masksToBounds = YES;
        detailsButon.layer.cornerRadius = 6.0;
        detailsButon.layer.borderColor = [[UIColor colorWithWhite:0.503 alpha:0.800] CGColor];
        detailsButon.layer.borderWidth = 0.5;
        detailsButon.showsTouchWhenHighlighted=YES;
        
        [detailsView addSubview:_detailsTextField];
        [detailsView addSubview:detailsButon];
    }
    return detailsView;
}

- (void)updateUser{
    [[CommentModel shareObject]updateUserAppraise:self.libraryID LibraryContent:userContent];
}

- (void)updateUserAppraiseIsSucceed:(NSString *)kkkk{
    if ([kkkk isEqualToString:@"1"]) {
    [[CommentModel shareObject]startGetComment:_libraryID];
        // 提示成功
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD show];
        [self performSelector:@selector(success) withObject:nil afterDelay:0.6f];
    }else{
        // 提示成功
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD show];
        [self performSelector:@selector(success11) withObject:nil afterDelay:0.6f];
    }
}
- (void)success {
    [SVProgressHUD showSuccessWithStatus:@"评价成功!!!"];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.5f];
}
- (void)success11 {
    [SVProgressHUD showSuccessWithStatus:@"评价失败!"];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.5f];
}
- (void)dismiss {
    [SVProgressHUD dismiss];
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"mmmmmmmmmmm%d",indexPath.row);
}

#pragma mark Actions
// 键盘弹出时不产生遮挡关系的设置
- (void)keyboardShow:(NSNotification *)notify{
    NSValue *value = [notify.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGFloat keyboardHeight = value.CGRectValue.size.height;
    // 获取屏幕与控件高度差
    CGFloat deltaH=1;
    if (commentArray.count==0) {
        if (SCREEN_HEIGHT ==736) {
            // 6p的高度
            deltaH = -keyboardHeight+162;
        }
        else if (SCREEN_HEIGHT ==667) {
            // 6的高度
            deltaH = -keyboardHeight+90;
        }
        else if (SCREEN_HEIGHT ==568) {
            // 5s的高度
            deltaH = -keyboardHeight +175-79;
        }
    }
    else
        deltaH = -keyboardHeight;
    
    // 如果屏幕不够高
    if (deltaH < 0) {
        CGRect frame = self.view.frame;
        frame = CGRectMake(frame.origin.x, deltaH, frame.size.width, frame.size.height);
        self.view.frame = frame;
    }
    NSLog(@"屏幕高度:%f",SCREEN_HEIGHT);
    [self.view bringSubviewToFront:self.backView];
}

// 键盘隐藏
- (void)keyboardHide:(NSNotification *)notify{
    CGRect frame = self.view.frame;
    frame = CGRectMake(frame.origin.x, 0, frame.size.width, frame.size.height);
    self.view.frame = frame;
}

// 点击键盘下一项
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_detailsTextField resignFirstResponder];
    NSLog(@"点击键盘右下角的键");
    return YES;
}
// textField开始编辑
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    userContent = textField.text;
}

@end

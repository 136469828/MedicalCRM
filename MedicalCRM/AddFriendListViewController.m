//
//  AddFriendListViewController.m
//  MedicalCRM
//
//  Created by admin on 16/7/19.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "AddFriendListViewController.h"
#import "NetManger.h"
#import "FriendListRightCell.h"
#import "FriendListModel.h"
#import <RongIMKit/RongIMKit.h>
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "AllGroupSelectViewController.h"
#import "ChatLinkManInfoViewController.h"
#import "MJExtension.h"
@interface AddFriendListViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UISearchControllerDelegate>

{
    NetManger *manger;
    NSArray *data;
    NSMutableArray *filterData;
    UISearchDisplayController *searchDisplayController;
    int selectCount;

}
@property (nonatomic, strong) UITableView *m_tableView;
@property (nonatomic ,strong) NSMutableArray *m_fansListsArray;
@property (nonatomic, strong) NSMutableArray *m_dateArray;
@property (nonatomic, strong) NSMutableArray *m_date;
@property (nonatomic, strong) NSMutableArray *m_IDdate;
@end

@implementation AddFriendListViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
}
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    manger = [NetManger shareInstance];
    manger.keywork = @"";
    [manger loadData:RequestOfGetrongclouduserpagelist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createTableView) name:@"getrongclouduserpagelist" object:nil];
//    [self createTableView];
    [_m_date removeAllObjects];
    [_m_IDdate removeAllObjects];
    if (_m_date == nil)
    {
        _m_date = [NSMutableArray array];
    }
    if (_m_IDdate == nil)
    {
        _m_IDdate = [NSMutableArray array];
    }

}


- (NSMutableArray *)m_fansListsArray
{
    if (_m_fansListsArray == nil)
    {
        _m_fansListsArray = [NSMutableArray array];
    }
    return _m_fansListsArray;
    
}

- (void)createTableView
{
    self.m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    self.m_tableView.delegate = self;
    self.m_tableView.dataSource = self;
    [self.m_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:self.m_tableView];
#pragma mark - 设置navigationItem右侧按钮
    UIButton *meassageBut = ({
        UIButton *meassageBut = [UIButton buttonWithType:UIButtonTypeCustom];
        meassageBut.frame = CGRectMake(0, 0, 35, 20);
        meassageBut.titleLabel.font = [UIFont systemFontOfSize:15];
        [meassageBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [meassageBut addTarget:self action:@selector(popCtr) forControlEvents:UIControlEventTouchDown];
        [meassageBut setTitle:@"确认"  forState:UIControlStateNormal];
        meassageBut;
    });
    UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithCustomView:meassageBut];
    self.navigationItem.rightBarButtonItem = rBtn;
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width
                                                                           , 44)];
    searchBar.placeholder = @"搜索";
    
    // 添加 searchbar 到 headerview
    self.m_tableView.tableHeaderView = searchBar;
    
    // 用 searchbar 初始化 SearchDisplayController
    // 并把 searchDisplayController 和当前 controller 关联起来
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    
    // searchResultsDataSource 就是 UITableViewDataSource
    searchDisplayController.searchResultsDataSource = self;
    // searchResultsDelegate 就是 UITableViewDelegate
    searchDisplayController.searchResultsDelegate = self;
}



- (NSMutableArray *)m_dateArray
{


    if (_m_dateArray == nil)
    {
        _m_dateArray = [NSMutableArray array];
        
        for (int i = 0; i<manger.clouduserpagelist.count; i++)
        {
            if (self.isNogroup == 2)
            {
                FriendListModel *fansModel = manger.clouduserpagelist[i];
                //            fansModel.EmployeeName = [NSString stringWithFormat:@"张连伟%d",i];
                //            NSLog(@"UserID - %@",fansModel.UserID);
                [[RCIM sharedRCIM] getDiscussion:self.ID success:^(RCDiscussion *discussion)
                 {
                     NSArray *memberIdList =  discussion.memberIdList; // 群组成员ID列表
                     if ([memberIdList containsObject:fansModel.UserID])
                     {
                         JCKLog(@"包含：%@",fansModel.UserID);
                         fansModel.m_chooseBtn = YES;
                         if (!_m_date) {
                             _m_date = [NSMutableArray array];
                         }
                         [_m_date addObject:fansModel.EmployeeName];
                     }
                     else
                     {
//                         JCKLog(@"不包含：%@",fansModel.UserID);
                         fansModel.m_chooseBtn = NO;
                     }
                    [_m_dateArray addObject:fansModel];
                 } error:^(RCErrorCode status) {
                     [SVProgressHUD showErrorWithStatus:@"服务器错误"];
                 }];
            }
            else
            {
                FriendListModel *fansModel = manger.clouduserpagelist[i];
                //            fansModel.EmployeeName = [NSString stringWithFormat:@"张连伟%d",i];
                [_m_dateArray addObject:fansModel];
            }
            
        }
    }
    
    return _m_dateArray;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.m_tableView)
    {
        [self.m_tableView deselectRowAtIndexPath:indexPath animated:YES];
        FriendListRightCell *cell = (FriendListRightCell *)[self.m_tableView cellForRowAtIndexPath:indexPath];
        FriendListModel *model = self.m_dateArray[indexPath.row];
        model.m_chooseBtn = !model.isChooseBtn;
        if (model.m_chooseBtn)
        { //选择了
            NSString *str = [NSString stringWithFormat:@"%@",model.EmployeeName];
            NSString *str2 = [NSString stringWithFormat:@"%@",model.EmployeeID];
            [self.m_date addObject:str];
            [self.m_IDdate addObject:str2];
            [self.m_fansListsArray addObject:model.UserID];
        }
        else
        { //取消
            NSString *str = [NSString stringWithFormat:@"%@",model.EmployeeName];
            [self.m_date removeObject:str];
            [self.m_fansListsArray removeObject:model.UserID];
            
        }
        [cell rowSelected];

    }
    else
    {
        [self.m_tableView deselectRowAtIndexPath:indexPath animated:YES];
        FriendListRightCell *cell = (FriendListRightCell *)[self.m_tableView cellForRowAtIndexPath:indexPath];
        FriendListModel *model = filterData[indexPath.row];
        model.m_chooseBtn = !model.isChooseBtn;
        if (model.m_chooseBtn)
        { //选择了
            NSString *str = [NSString stringWithFormat:@"%@",model.EmployeeName];
            NSString *str2 = [NSString stringWithFormat:@"%@",model.EmployeeID];
            [self.m_date addObject:str];
            [self.m_IDdate addObject:str2];
            [self.m_fansListsArray addObject:model.UserID];
        }
        else
        { //取消
            NSString *str = [NSString stringWithFormat:@"%@",model.EmployeeName];
            [self.m_date removeObject:str];
            [self.m_fansListsArray removeObject:model.UserID];
        }
        [cell rowSelected];
        [searchDisplayController setActive:NO animated:YES ];
    }
//    if (_m_date.count % 4)
//    {
//        selectCount ++;
//    }
//    NSString *ns=[_m_date componentsJoinedByString:@","];
//    UILabel *lb = (UILabel *)[tableView viewWithTag:8888];
//    lb.text = [NSString stringWithFormat:@"您添加的好友为: %@",ns];
        NSLog(@"ID%@ 名字%@",self.m_fansListsArray,_m_date);
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.m_tableView)
    {
        return self.m_dateArray.count;
    }
    else
    {
        // 谓词搜索
        [filterData removeAllObjects];
        filterData = [NSMutableArray array];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@",searchDisplayController.searchBar.text];
        for (int i = 0; i< _m_dateArray.count; i++)
        {
            // [roadTitleLab.text rangeOfString:@"qingjoin"].location !=NSNotFound [model.EmployeeName isEqualToString:searchDisplayController.searchBar.text]
            FriendListModel *model = _m_dateArray[i];
            JCKLog(@"%@",model.EmployeeName);
            if ([model.EmployeeName rangeOfString:searchDisplayController.searchBar.text].location !=NSNotFound)
            {
                [filterData addObject:model];
            }
            
        }
//        filterData =  [[NSArray alloc] initWithArray:[_m_dateArray filteredArrayUsingPredicate:predicate]];
        
//        filterData = self.m_dateArray;
        return filterData.count;
    }
}
#if 0
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section  // 返回一个UIView作为头视图
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
    bgView.backgroundColor = [UIColor whiteColor];
    UIButton *friendInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    friendInfoBtn.frame = CGRectMake(12,0,ScreenWidth-12,60);
    friendInfoBtn.backgroundColor = [UIColor clearColor];
    [friendInfoBtn addTarget:self action:@selector(friendInfoBtnAction) forControlEvents:UIControlEventTouchDown];
    [bgView addSubview:friendInfoBtn];
    UILabel *selcetLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, ScreenWidth-12, 60)];
    selcetLab.tag = 8888;
    selcetLab.numberOfLines = 0;
    if (_m_date.count != 0) {
        NSString *ns=[_m_date componentsJoinedByString:@","];
        selcetLab.text = [NSString stringWithFormat:@"您添加的好友为: %@",ns];
    }
    else
    {
        selcetLab.text = @"您添加的好友为:";
    }

    selcetLab.font = [UIFont systemFontOfSize:13];
    [bgView addSubview: selcetLab];
//    bgView.backgroundColor = [UIColor redColor];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 60-1, ScreenWidth, 1)];
    line.backgroundColor = RGB(234, 234, 234);
    [bgView addSubview:line];
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(0, 63, ScreenWidth, 55);
//    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, ScreenWidth-60, 55)];
//    lb.text = @"点击选择一个部门";
//    lb.font = [UIFont systemFontOfSize:13];
//    [btn addSubview:lb];
//    [btn addTarget:self action:@selector(selectAllGroupAction) forControlEvents:UIControlEventTouchDown];
//    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 120-1, ScreenWidth, 1)];
//    line2.backgroundColor = RGB(234, 234, 234);
//    [bgView addSubview:line2];
//    [bgView addSubview:btn];
    return bgView;
}
#endif
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendListRightCell *cell = [FriendListRightCell selectedCell:tableView];
    cell.tagLab.hidden = YES;
    if (tableView == self.m_tableView)
    {
        FriendListModel *model = self.m_dateArray[indexPath.row];
        if (model.m_chooseBtn)
        {
            cell.selectedBtn.selected = NO;
            [cell rowSelected];
//            [cell.selectedBtn setBackgroundImage:[UIImage imageNamed:@"score_icon_select.png"] forState:UIControlStateSelected];
        }
        cell.hearImg.layer.cornerRadius = 5;
        [cell.hearImg sd_setImageWithURL:[NSURL URLWithString:model.PhotoURL]];
        cell.m_model = model;
        cell.hearImg.layer.masksToBounds= YES;
        return cell;
    }
    else
    {
        FriendListModel *model = filterData[indexPath.row];
        if (model.m_chooseBtn)
        {
            cell.selectedBtn.selected = NO;
            [cell rowSelected];
            //            [cell.selectedBtn setBackgroundImage:[UIImage imageNamed:@"score_icon_select.png"] forState:UIControlStateSelected];
        }
        cell.hearImg.layer.cornerRadius = 5;
        [cell.hearImg sd_setImageWithURL:[NSURL URLWithString:model.PhotoURL]];
        cell.m_model = model;
        cell.hearImg.layer.masksToBounds= YES;
        return cell;
    }

}
- (void)friendInfoBtnAction
{
    ChatLinkManInfoViewController *sub = [[ChatLinkManInfoViewController alloc] init];
    sub.title = @"好友列表";
    sub.groupID = self.ID;
    [self.navigationController pushViewController:sub animated:YES];

}
- (void)selectAllGroupAction
{
    AllGroupSelectViewController *sub = [[AllGroupSelectViewController alloc] init];
    sub.title = @"从部门添加";
    [self.navigationController pushViewController:sub animated:YES];

}
- (void)popCtr
{
    if (self.isNogroup == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"请输入群组名"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确认", nil];
        // 基本输入框，显示实际输入的内容
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        
        //设置输入框的键盘类型
        UITextField *tf = [alert textFieldAtIndex:0];
        
        UITextField *tf2 = [alert textFieldAtIndex:1];
        if (alert.alertViewStyle == UIAlertViewStylePlainTextInput) {
            // 对于用户名密码类型的弹出框，还可以取另一个输入框
            tf2 = [alert textFieldAtIndex:1];
            tf2.keyboardType = UIKeyboardTypeASCIICapable;
            NSString* text2 = tf2.text;
            NSLog(@"INPUT1:%@", text2);
        }
        
        // 取得输入的值
        NSString* text = tf.text;
        NSLog(@"INPUT:%@", text);
        if (alert.alertViewStyle == UIAlertViewStylePlainTextInput) {
            // 对于两个输入框的
            NSString* text2 = tf2.text;
            NSLog(@"INPUT2:%@", text2);
        }
        
        [alert show];
    }
    else if (self.isNogroup == 1)
    {
        NSArray *users = self.m_fansListsArray;
        if (self.block)
        {
            self.block(self.m_date,self.m_IDdate);
        }
//        [self.navigationController popViewControllerAnimated:YES];
        int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
        if (index < 2)
        {
            index = 2;
        }
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index -2)] animated:YES];
    }
    else if (self.isNogroup == 2)
    {
        JCKLog(@"%@",self.m_fansListsArray);
        [[RCIM sharedRCIM] addMemberToDiscussion:self.ID userIdList:self.m_fansListsArray success:^(RCDiscussion *discussion) {
            JCKLog(@"%@",discussion);
//            for (NSString *str in discussion.memberIdList)
//            {
//                NSLog(@"memberIdList:%@",str);
//            }
//            JCKLog(@"%@",discussion.memberIdList);
            NSString *userID=[discussion.memberIdList componentsJoinedByString:@","];
            manger.creatediscussions = @[userID,discussion.discussionId,discussion.discussionName];
            
            [manger loadData:RequestOfCreatediscussion];
            [SVProgressHUD showSuccessWithStatus:@"添加成功"];

        } error:^(RCErrorCode status)
         {
            JCKLog(@"错误");
           [SVProgressHUD showErrorWithStatus:@"服务异常，请重新操作"];
        }];
//        UIViewController *viewCtl = self.navigationController.viewControllers[0];
//        [self.navigationController popToViewController:viewCtl animated:YES];
//        [self.navigationController popViewControllerAnimated:YES];
        int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
        if (index < 2)
        {
            index = 2;
        }
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index -2)] animated:YES];
    }
   
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    NSLog(@"%@",self.m_fansListsArray);// 只有被邀请ID
////    for (int i = 0; i<self.m_fansListsArray.count; i++)
////    {
////        NSDictionary *dic = @{
////                              @"PhotoURL": _creatediscussionsDetails[0],
////                              @"EmployeeName": _creatediscussionsDetails[1],
////                              @"ID": self.m_fansListsArray[i],
////                              @"UserID": _creatediscussionsDetails[3],
////                              };
////    }
    if (self.needAddFriendID == nil || self.needAddFriendID == NULL || [self.needAddFriendID isKindOfClass:[NSNull class]] || [[self.needAddFriendID stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
//        JCKLog(@"123");
        
    }
    else
    {
        [self.m_fansListsArray addObject:self.needAddFriendID];
    }
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        UITextField *nameField = [alertView textFieldAtIndex:0];
        //TODO
        NSLog(@"nameField %@",nameField.text);
        if (buttonIndex == 1)
        {
            // 新建群聊
            NSArray *users = self.m_fansListsArray;

            [[RCIM sharedRCIM] createDiscussion:nameField.text userIdList:users success:^(RCDiscussion *discussion) {
                NSLog(@"discussionId:%@ \n discussionName:%@",discussion.discussionId,discussion.discussionName);
                for (NSString *str in discussion.memberIdList)
                {
                    NSLog(@"memberIdList:%@",str);
                }
                [self.m_fansListsArray addObject:manger.userID];
                NSString *userID=[self.m_fansListsArray componentsJoinedByString:@","];
                manger.creatediscussions = @[userID,discussion.discussionId,discussion.discussionName];

                [manger loadData:RequestOfCreatediscussion];
            } error:^(RCErrorCode status) {
                NSLog(@"%ld",(long)status);
            }];
//            [self.navigationController popViewControllerAnimated:YES];
            int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
            if (index < 2)
            {
                index = 2;
            }
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index -2)] animated:YES];
        }
    }
    
}
@end

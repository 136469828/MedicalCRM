//
//  TheFriendListViewController.m
//  MedicalCRM
//
//  Created by admin on 16/8/5.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "TheFriendListViewController.h"
#import "FriendListModel.h"
#import "FriendListRightCell.h"
#import "CustomerListViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "FriendViewController.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import "NetManger.h"
#import "ChatViewController.h"
#import "GroupViewController.h"
#import "ChatListViewController.h"
#import "DepartmentListController.h"
#import "UIImageView+WebCache.h"
#import <RongIMKit/RongIMKit.h>
#import "SVProgressHUD.h"
@interface TheFriendListViewController ()<UITableViewDataSource,UITableViewDelegate,CNContactPickerDelegate,UIAlertViewDelegate,UISearchControllerDelegate>
{
    NetManger *manger;
    NSArray *titles;
    NSArray *imgs;
    UISearchDisplayController *searchDisplayController;
    NSMutableArray *datas;
    NSArray *filterData;
}
@property (nonatomic ,strong) NSMutableArray *m_fansListsArray;
@property (nonatomic, strong) NSMutableArray *m_dateArray;
@property (nonatomic, strong) UITableView *tableViewRight;

@end

@implementation TheFriendListViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.title = @"通讯录";
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    manger = [NetManger shareInstance];
    manger.keywork = @"";
    [manger loadData:RequestOfGetrongclouduserpagelist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDatas) name:@"getrongclouduserpagelist" object:nil];
    
    _tableViewRight = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    _tableViewRight.tag = 6002;
    _tableViewRight.delegate = self;
    _tableViewRight.dataSource = self;
    [_tableViewRight setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableViewRight];
    [self setHearView];
}
- (void)reloadDatas
{
    [datas removeAllObjects];
    for (int i = 0; i<manger.clouduserpagelist.count; i++)
    {
        FriendListModel *model = manger.clouduserpagelist[i];
        if (!datas) {
            datas = [[NSMutableArray alloc] initWithCapacity:0];
        }
        [datas addObject:[NSString stringWithFormat:@"%@|%@|%@",model.EmployeeName,model.PhotoURL,model.UserID]];
        if (_m_fansListsArray == nil)
        {
            _m_fansListsArray = [NSMutableArray array];
        }
        [_m_fansListsArray addObject:model];
    }
    [self.tableViewRight reloadData];
}
- (void)setHearView
{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth , 44)];
    searchBar.placeholder = @"搜索";
    
    // 添加 searchbar 到 headerview
    self.tableViewRight.tableHeaderView = searchBar;
    
    // 用 searchbar 初始化 SearchDisplayController
    // 并把 searchDisplayController 和当前 controller 关联起来
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    
    // searchResultsDataSource 就是 UITableViewDataSource
    searchDisplayController.searchResultsDataSource = self;
    // searchResultsDelegate 就是 UITableViewDelegate
    searchDisplayController.searchResultsDelegate = self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableViewRight) {
        return _m_fansListsArray.count;
    }else{
        // 谓词搜索
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@",searchDisplayController.searchBar.text];
        filterData =  [[NSArray alloc] initWithArray:[datas filteredArrayUsingPredicate:predicate]];
        return filterData.count;
    }

    //    return manger.clouduserpagelist.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section // 返回组的头宽
{
    if (section == 1)
    {
        return 25;
    }
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section // 返回一个UIView作为头视图
{
    if (section == 1) {
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 25)];
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, ScreenWidth-50, 19)];
        topView.backgroundColor = RGB(242, 242, 242);
        lb.text = @"我的好友";
        lb.textColor = RGB(170, 170, 170);
        lb.font = [UIFont systemFontOfSize:13];
        [topView addSubview:lb];
        return topView;
    }
    return nil;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView // 一个表视图里面有多少组
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        FriendListRightCell *cell = [FriendListRightCell selectedCell:tableView];
        cell.selectedBtn.hidden = YES;
        FriendListModel *model = manger.clouduserpagelist[indexPath.row];
    
        if (tableView == self.tableViewRight)
        {
            [cell.hearImg sd_setImageWithURL:[NSURL URLWithString:model.PhotoURL]];
            cell.nameLab.text = model.EmployeeName;
            cell.tagLab.text = [NSString stringWithFormat:@"%@",model.UserID];
        }else
        {
            NSArray *array = [[NSString stringWithFormat:@"%@",filterData[indexPath.row]] componentsSeparatedByString:@"|"]; //从字符A中分隔成2个元素的数组
            [cell.hearImg sd_setImageWithURL:[NSURL URLWithString:array[1]]];
            cell.nameLab.text = array[0];
            cell.tagLab.text = [NSString stringWithFormat:@"%@",array[2]];
        }
        cell.tagLab.textColor = [UIColor clearColor];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [SVProgressHUD showWithStatus:@"发送中"];
    FriendListRightCell *cell = (FriendListRightCell*)[tableView cellForRowAtIndexPath:indexPath];
    __weak typeof(&*self) weakSelf = self;
    if (self.isImg == 1)
    {
        RCTextMessage *message = [RCTextMessage messageWithContent:self.strCopy];
        [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE
                                          targetId:cell.tagLab.text
                                           content:message
                                       pushContent:nil
                                          pushData:nil
                                           success:^(long messageId) {
                                               NSLog(@"发送成功");
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   ChatViewController *conversationVC = [[ChatViewController alloc]init];
                                                   conversationVC.conversationType =ConversationType_PRIVATE;
                                                   conversationVC.targetId = cell.tagLab.text; //
                                                   conversationVC.ID = cell.tagLab.text;
                                                   conversationVC.title = cell.nameLab.text;
                                                   conversationVC.hidesBottomBarWhenPushed = YES;
                                                   [weakSelf.navigationController pushViewController:conversationVC animated:YES];
                                               });
                                           } error:^(RCErrorCode nErrorCode, long messageId) {
                                               NSLog(@"发送失败");
                                           }];
    }
    else if (self.isImg == 3) // 多条转发
    {
        for (int i = 0; i < self.contextArr.count; i++)
        {
            RCTextMessage *message = [RCTextMessage messageWithContent:self.contextArr[i]];
            [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE
                                              targetId:cell.tagLab.text
                                               content:message
                                           pushContent:nil
                                              pushData:nil
                                               success:^(long messageId) {
                                                   NSLog(@"发送成功");
                                                   if (i+1 == self.contextArr.count)
                                                   {
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                           ChatViewController *conversationVC = [[ChatViewController alloc]init];
                                                           conversationVC.conversationType =ConversationType_PRIVATE;
                                                           conversationVC.targetId = cell.tagLab.text; //
                                                           conversationVC.ID = cell.tagLab.text;
                                                           conversationVC.title = cell.nameLab.text;
                                                           conversationVC.hidesBottomBarWhenPushed = YES;
                                                           [weakSelf.navigationController pushViewController:conversationVC animated:YES];
                                                       });
                                                   }
                                                   
                                               } error:^(RCErrorCode nErrorCode, long messageId) {
                                                   NSLog(@"发送失败");
                                               }];
        }
       
    }
    else if (self.isImg == 2)
    {
        RCImageMessage *message = [RCImageMessage messageWithImageURI:self.strCopy];//messageWithContent:self.strCopy];
        [[RCIM sharedRCIM] sendMediaMessage:ConversationType_PRIVATE targetId:cell.tagLab.text content:message pushContent:nil pushData:nil progress:^(int progress, long messageId) {
            
        } success:^(long messageId) {
            dispatch_async(dispatch_get_main_queue(), ^{
                ChatViewController *conversationVC = [[ChatViewController alloc]init];
                conversationVC.conversationType =ConversationType_PRIVATE;
                conversationVC.targetId = cell.tagLab.text; //
                conversationVC.ID = cell.tagLab.text;
                conversationVC.title = cell.nameLab.text;
                conversationVC.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:conversationVC animated:YES];
            });

        } error:^(RCErrorCode errorCode, long messageId) {
            
        }];
    }
    else if (self.isImg == 4)
    {
        RCFileMessage *message = [RCFileMessage messageWithFile:self.strCopy];//messageWithContent:self.strCopy];
        [[RCIM sharedRCIM] sendMediaMessage:ConversationType_PRIVATE targetId:cell.tagLab.text content:message pushContent:nil pushData:nil progress:^(int progress, long messageId)
        {
            JCKLog(@"progress - %d",progress);
        } success:^(long messageId) {
            
            [SVProgressHUD dismiss];
            dispatch_async(dispatch_get_main_queue(), ^{
                ChatViewController *conversationVC = [[ChatViewController alloc]init];
                conversationVC.conversationType =ConversationType_PRIVATE;
                conversationVC.targetId = cell.tagLab.text; //
                conversationVC.ID = cell.tagLab.text;
                conversationVC.title = cell.nameLab.text;
                conversationVC.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:conversationVC animated:YES];
                });
                
        } error:^(RCErrorCode errorCode, long messageId)
         {
             JCKLog(@"%ld %ld",(long)errorCode,messageId);
            [SVProgressHUD showErrorWithStatus:@"发送失败"];
        }];
    }

 
}

#pragma mark - BtnAction
- (void)btnAction:(UIButton *)btn
{
    switch (btn.tag) {
        case 7000:
        {
            CustomerListViewController *sub = [[CustomerListViewController alloc] init];
            sub.title = @"我的客户";
            sub.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sub animated:YES];
        }
            break;
        case 7001:
        {
            ChatListViewController *sub = [[ChatListViewController alloc] init];
            sub.title = @"群组";
            sub.isOnlyGroup = YES;
            sub.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sub animated:YES];
            
        }
            break;
        case 7002:
        {
            // 1.创建选择联系人的控制器
            CNContactPickerViewController *contactVc = [[CNContactPickerViewController alloc] init];
            // 2.设置代理
            contactVc.delegate = self;
            // 3.弹出控制器
            [self presentViewController:contactVc animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}
- (void)seachBtnAction
{
    FriendViewController *sub = [[FriendViewController alloc] init];
    sub.title = @"查找好友";
    sub.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sub animated:YES];
    
}
- (void)popCtr
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
#pragma mark - contactVcDelegate
// ④实现代理方法
// 1.点击取消按钮调用的方法
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker
{
    NSLog(@"取消选择联系人");
}
// 2.当选中某一个联系人时会执行该方法
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact
{
    //    // 1.获取联系人的姓名
    //    NSString *lastname = contact.familyName;
    //    NSString *firstname = contact.givenName;
    //    NSLog(@"%@ %@", lastname, firstname);
    //
    //    // 2.获取联系人的电话号码(此处获取的是该联系人的第一个号码,也可以遍历所有的号码)
    //    NSArray *phoneNums = contact.phoneNumbers;
    //    CNLabeledValue *labeledValue = phoneNums[0];
    //    CNPhoneNumber *phoneNumer = labeledValue.value;
    //    NSString *phoneNumber = phoneNumer.stringValue;
    //    NSLog(@"%@", phoneNumber);
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%@",self.m_fansListsArray);
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        UITextField *nameField = [alertView textFieldAtIndex:0];
        //TODO
        NSLog(@"nameField %@",nameField.text);
        if (buttonIndex == 1)
        {
            // 新建群聊
            NSArray *users = @[@"10011",@"1"];
            [[RCIM sharedRCIM] createDiscussion:nameField.text userIdList:users success:^(RCDiscussion *discussion) {
                NSLog(@"discussionId:%@ discussionName:%@",discussion.discussionId,discussion.discussionName);
                for (NSString *str in discussion.memberIdList) {
                    NSLog(@"memberIdList:%@",str);
                }
            } error:^(RCErrorCode status) {
                NSLog(@"%ld",(long)status);
            }];
            [self.navigationController popViewControllerAnimated:YES];
        }
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

@end

//
//  FriendListViewController.m
//  MedicalCRM
//
//  Created by admin on 16/7/18.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "FriendListViewController.h"
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
#import "TheFriendListViewController.h"
@interface FriendListViewController ()<UITableViewDataSource,UITableViewDelegate,CNContactPickerDelegate,UIAlertViewDelegate,UISearchControllerDelegate>
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

@implementation FriendListViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
    if (!self.isAdd)
    {
        [self setHearView];
    }
    else
    {
#pragma mark - 设置navigationItem右侧按钮
        UIButton *meassageBut = ({
            UIButton *meassageBut = [UIButton buttonWithType:UIButtonTypeCustom];
            meassageBut.frame = CGRectMake(0, 0, 35, 20);
            meassageBut.titleLabel.font = [UIFont systemFontOfSize:15];
            [meassageBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [meassageBut addTarget:self action:@selector(popCtr) forControlEvents:UIControlEventTouchDown];
            [meassageBut setTitle:@"确认"  forState:UIControlStateNormal];
            meassageBut;
        });
        
        UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithCustomView:meassageBut];
        self.navigationItem.rightBarButtonItem = rBtn;
    }
    titles = @[@"群组",@"通讯录",@"财务部",@"生产部",@"销售部"];
    imgs = @[@"群组",@"通讯录",@"bumenIcon",@"bumenIcon",@"bumenIcon"];
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
        [datas addObject:model.EmployeeName];
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
    if (section == 0)
    {
        return 5;
    }
    else
    {
        if (tableView == self.tableViewRight) {
            return datas.count;
        }else{
            // 谓词搜索
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@",searchDisplayController.searchBar.text];
            filterData =  [[NSArray alloc] initWithArray:[datas filteredArrayUsingPredicate:predicate]];
            return filterData.count;
        }
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
        lb.text = @"最近联系人好友";
        lb.textColor = RGB(170, 170, 170);
        lb.font = [UIFont systemFontOfSize:13];
        [topView addSubview:lb];
        return topView;
    }
    return nil;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView // 一个表视图里面有多少组
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 45;
    }
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    FriendListRightCell *cell = [FriendListRightCell selectedCell:tableView];
    if (!self.isAdd)
    {
        cell.selectedBtn.hidden = YES;
    }
    if (indexPath.section == 0)
    {
        cell.nameLab.text = [NSString stringWithFormat:@"%@",titles[indexPath.row]];
        cell.hearImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imgs[indexPath.row]]] ;
        cell.tagLab.hidden = YES;
    }
    else
    {
        FriendListModel *model = manger.clouduserpagelist[indexPath.row];
        cell.tagLab.text = [NSString stringWithFormat:@"%@",model.UserID];
        if (tableView == self.tableViewRight)
        {
            cell.nameLab.text = datas[indexPath.row];
        }else{
            cell.nameLab.text = filterData[indexPath.row];
        }
        cell.tagLab.textColor = [UIColor clearColor];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (!self.isAdd)
    {
        if (indexPath.section == 0)
        {
            switch (indexPath.row) {
                case 0:
                {
                    ChatListViewController *sub = [[ChatListViewController alloc] init];
                    sub.title = @"群组";
                    sub.isOnlyGroup = YES;
                    sub.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:sub animated:YES];
                }
                    break;
                    
                case 1:
                {
                    // 1.创建选择联系人的控制器
                    CNContactPickerViewController *contactVc = [[CNContactPickerViewController alloc] init];
                    // 2.设置代理
                    contactVc.delegate = self;
                    // 3.弹出控制器
                    [self presentViewController:contactVc animated:YES completion:^
                    {
                        
                    }];
                }
                    break;
//                case 2:
//                {
//                    DepartmentListController *contactVc = [[DepartmentListController alloc] init];
////                    NSArray *arr = manger.departments;
////                    contactVc.datas = arr;
//                    contactVc.title = @"公司部门";
//                    [self.navigationController pushViewController:contactVc animated:YES];
//                }
//                    break;
                default:
                {
                    TheFriendListViewController *sub = [[TheFriendListViewController alloc] init];
                    sub.title = @"详情";
                    [self.navigationController pushViewController:sub animated:YES];

                }
                    break;
            }
        }
        else
        {
            FriendListRightCell *cell = (FriendListRightCell*)[tableView cellForRowAtIndexPath:indexPath];
            
            ChatViewController *conversationVC = [[ChatViewController alloc]init];
            conversationVC.conversationType =ConversationType_PRIVATE;
            conversationVC.targetId = cell.tagLab.text; //这里模拟自己给自己发消息，您可以替换成其他登录的用户的UserId 110
            conversationVC.title = cell.nameLab.text;
            conversationVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:conversationVC animated:YES];
        }

    }
    else
    {
        [self.tableViewRight deselectRowAtIndexPath:indexPath animated:YES];
        
        FriendListRightCell *cell = (FriendListRightCell *)[self.tableViewRight cellForRowAtIndexPath:indexPath];
        FriendListModel *model = self.m_dateArray[indexPath.row];
        model.m_chooseBtn = !model.isChooseBtn;
        if (model.m_chooseBtn)
        { //选择了
            [self.m_fansListsArray addObject:model];
            
        }
        else
        { //取消
            [self.m_fansListsArray removeObject:model];
            
        }
        [cell rowSelected];
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
- (NSMutableArray *)m_dateArray
{
    if (_m_fansListsArray == nil)
    {
        _m_fansListsArray = [NSMutableArray array];
    }
    
    return _m_dateArray;
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

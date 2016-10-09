//
//  AddMyTeamCompanyMenberViewController.m
//  MedicalCRM
//
//  Created by admin on 16/8/22.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "AddMyTeamCompanyMenberViewController.h"
#import "NewFriendGroupCell.h"
#import "FriendListModel.h"
#import "NetManger.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import "MJExtension.h"
#import "ChatListViewController.h"
#import "ChatViewController.h"
#import "NewFriendGroupViewController.h"
#import "UIImageView+WebCache.h"
#import "SeachFriendViewController.h"
#import "SigninViewController.h" // 签到
#import "ProjectMangerViewController.h" // 项目管理
#import "MyPayViewController.h" // 费用
#import "MyDemoChiController.h" // 样机

#import "MyPerformanceViewController.h" // 业绩
#import "AssessmentViewController.h" // 我的价值
#import "CreditViewController.h" // 诚信度
#import "LifeNavigationViewController.h" // 人生导航
#import "AuditListViewController.h"
#import "ExhibitionListViewController.h"
#import "ProjectBuildViewController.h"
#import "DemoMachineSaveController.h"
#import "TheNewCustomerListController.h"
#import "CLDropDownMenu.h"
#import "AddFriendListViewController.h"

@interface AddMyTeamCompanyMenberViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchControllerDelegate,CNContactPickerDelegate>
{
    NetManger *manger;
    NSArray *titles;
    NSArray *imgs1;
    NSArray *imgs2;
    NSArray *titles2;
    NSArray *data;
    NSArray *filterData;
    UISearchDisplayController *searchDisplayController;
}
@property (nonatomic, strong) NSMutableArray *m_dateArray;
@property (nonatomic, strong) NSMutableArray *m_groups;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation AddMyTeamCompanyMenberViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"通讯录";
    manger = [NetManger shareInstance];
    [manger loadData:RequestOfGetdeptusers];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDatas) name:@"getdeptusers" object:nil];
}
- (void)reloadDatas
{
    for (NSDictionary *dic in manger.friendLists)
    {
        if (!_m_groups) {
            _m_groups = [NSMutableArray array];
        }
        
        [_m_groups addObject:dic[@"DeptName"]];
        if (!_m_dateArray) {
            _m_dateArray = [NSMutableArray array];
        }
        
        [_m_dateArray addObject:dic[@"Users"]];
    }
    //    JCKLog(@"%@",_m_dateArray);
    [self setTableView];
}
#pragma mark -
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 69) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //iOS 8开始的自适应高度，可以不需要实现定义高度的方法
    //    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = 60;
    
    [self.view addSubview:_tableView];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *datas = _m_dateArray[section];
    return datas.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView // 一个表视图里面有多少组
{
    return _m_groups.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section // 返回组的头宽
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section // 返回组的尾宽
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section // 返回组名
{
    return _m_groups[section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewFriendGroupCell *cell = [NewFriendGroupCell selectedCell:tableView];
    cell.nameLab.text = _m_dateArray[indexPath.section][indexPath.row][@"EmployeeName"];
    [cell.imgV sd_setImageWithURL:[NSURL URLWithString:_m_dateArray[indexPath.section][indexPath.row][@"PhotoURL"]]];
    cell.phoneAction.hidden = YES;
    NSString *str = [NSString stringWithFormat:@"%@",_m_dateArray[indexPath.section][indexPath.row][@"QuarterName"]];
    if (![str isEqualToString:@"<null>"])
    {
        cell.subTitleLab.text = str;
    }
    else
    {
        cell.subTitleLab.text = @"无";
    }
    cell.tagLab.text = [NSString stringWithFormat:@"%@|%@|%@",_m_dateArray[indexPath.section][indexPath.row][@"DeptName"],_m_dateArray[indexPath.section][indexPath.row][@"EmployeeName"],_m_dateArray[indexPath.section][indexPath.row][@"QuarterName"]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewFriendGroupCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.block)
    {
        self.block(cell.tagLab.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)seachBtnAction
{
    SeachFriendViewController *sub = [[SeachFriendViewController alloc] init];
    sub.hidesBottomBarWhenPushed = YES;
    [_tableView reloadData];
    [self.navigationController pushViewController:sub animated:YES];
}
- (void)pushBtnAction
{
    ChatListViewController *sub = [[ChatListViewController alloc] init];
    sub.title = @"我的群组";
    sub.isOnlyGroup = 1;
    [_tableView reloadData];
    [self.navigationController pushViewController:sub animated:YES];
    
}
- (void)pushBtnAction2
{
    ChatListViewController *sub = [[ChatListViewController alloc] init];
    sub.title = @"最近联系人";
    sub.isOnlyGroup = 2;
    [_tableView reloadData];
    [self.navigationController pushViewController:sub animated:YES];
}
- (void)cellBtnAction:(UIButton *)btn
{
    if (btn.tag != 0)
    {
        NSString *num = [[NSString alloc] initWithFormat:@"tel://%ld",btn.tag]; //number为号码字符串
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
    }
    else
    {
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该同事没有联系电话消息，请与后台工作人员沟通" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [al show];
    }
}
@end

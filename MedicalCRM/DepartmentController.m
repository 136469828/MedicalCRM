//
//  DepartmentController.m
//  MedicalCRM
//
//  Created by admin on 16/8/2.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "DepartmentController.h"
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
#import "DepartmentController.h"
@interface DepartmentController ()<UITableViewDataSource,UITableViewDelegate,CNContactPickerDelegate,UIAlertViewDelegate,UISearchControllerDelegate>
{
    UISearchDisplayController *searchDisplayController;
    NSMutableArray *datas;
    NSArray *filterData;
}
@property (nonatomic ,strong) NSMutableArray *m_fansListsArray;
@property (nonatomic, strong) NSMutableArray *m_dateArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DepartmentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    JCKLog(@"%@",self.datas);
    [self reloadDatas];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    _tableView.tag = 6002;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
    [self setHearView];
}
- (void)reloadDatas
{
    [datas removeAllObjects];
    for (int i = 0; i<self.datas.count; i++)
    {
        FriendListModel *model = self.datas[i];
        if (!datas) {
            datas = [[NSMutableArray alloc] initWithCapacity:0];
        }
        [datas addObject:model.EmployeeName];
    }
}
- (void)setHearView
{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth , 44)];
    searchBar.placeholder = @"搜索";
    
    // 添加 searchbar 到 headerview
    self.tableView.tableHeaderView = searchBar;
    
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
    if (tableView == self.tableView)
    {
        return datas.count;
    }else{
        // 谓词搜索
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@",searchDisplayController.searchBar.text];
        filterData =  [[NSArray alloc] initWithArray:[datas filteredArrayUsingPredicate:predicate]];
        return filterData.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section // 返回组的头宽
{

    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FriendListRightCell *cell = [FriendListRightCell selectedCell:tableView];
    cell.selectedBtn.hidden = YES;
    FriendListModel *model = self.datas[indexPath.row];
    cell.tagLab.text = [NSString stringWithFormat:@"%@",model.UserID];
    if (tableView == self.tableView)
    {
        cell.nameLab.text = datas[indexPath.row];
    }else{
        cell.nameLab.text = filterData[indexPath.row];
    }
    cell.tagLab.textColor = [UIColor clearColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendListRightCell *cell = (FriendListRightCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    ChatViewController *conversationVC = [[ChatViewController alloc]init];
    conversationVC.conversationType =ConversationType_PRIVATE;
    conversationVC.targetId = cell.tagLab.text; //这里模拟自己给自己发消息，您可以替换成其他登录的用户的UserId 110
    conversationVC.title = cell.nameLab.text;
    conversationVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:conversationVC animated:YES];
}

@end

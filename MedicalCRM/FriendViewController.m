//
//  FriendViewController.m
//  MedicalCRM
//
//  Created by admin on 16/7/18.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "FriendViewController.h"
#import "KeyboardToolBar.h"
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

@interface FriendViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    
    UIView *hearView;
    NSString *keywork;
    UITextField *seachTextField;
    NetManger *manger;
    
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation FriendViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    manger = [NetManger shareInstance];
    manger.keywork = @"";
    [manger loadData:RequestOfSeachrongclouduserpagelist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDatas) name:@"getrongclouduserpagelist" object:nil];
    // Do any additional setup after loading the view.
    [self setTableView];
}
- (void)reloadDatas
{
    [self.tableView reloadData];
}
#pragma mark -
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //iOS 8开始的自适应高度，可以不需要实现定义高度的方法
    self.tableView.rowHeight = 55;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
    [self setTop];
}
- (void)setTop
{
    hearView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    hearView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:hearView];
    seachTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 5, SCREEN_WIDTH - 80, 30)];
    seachTextField.delegate = self;
    seachTextField.layer.borderColor = [UIColor lightGrayColor].CGColor; // set color as you want.
    seachTextField.layer.borderWidth = 1.0; // set borderWidth as you want.
    seachTextField.layer.cornerRadius=8.0f;
    seachTextField.layer.masksToBounds=YES;
    [KeyboardToolBar registerKeyboardToolBar:seachTextField];
    [hearView addSubview:seachTextField];
    
    UIButton *seachBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [seachBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [seachBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    seachBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    seachBtn.frame = CGRectMake(SCREEN_WIDTH - 55, 10, 40, 20);
    [seachBtn addTarget:self action:@selector(seachOnSeach) forControlEvents:UIControlEventTouchDown];
    [hearView addSubview:seachBtn];
    self.tableView.tableHeaderView = hearView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return manger.clouduserpagelist.count;
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
    cell.tagLab.textColor = [UIColor clearColor];
    FriendListModel *model = manger.clouduserpagelist[indexPath.row];
    cell.nameLab.text = model.EmployeeName;
    cell.tagLab.text = model.UserID;
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
- (void)seachOnSeach
{
    manger.keywork = seachTextField.text;
    [manger loadData:RequestOfSeachrongclouduserpagelist];
}
@end

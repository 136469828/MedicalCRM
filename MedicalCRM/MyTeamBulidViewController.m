//
//  MyTeamBulidViewController.m
//  MedicalCRM
//
//  Created by admin on 16/8/12.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "MyTeamBulidViewController.h"
#import "NetManger.h"
#import "FriendListRightCell.h"
#import "FriendListModel.h"
#import <RongIMKit/RongIMKit.h>
#import "UIImageView+WebCache.h"
@interface MyTeamBulidViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UISearchControllerDelegate>

{
    NetManger *manger;
    NSArray *data;
    NSArray *filterData;
    UISearchDisplayController *searchDisplayController;
    
}
@property (nonatomic, strong) UITableView *m_tableView;
@property (nonatomic ,strong) NSMutableArray *m_fansListsArray;
@property (nonatomic, strong) NSMutableArray *m_dateArray;
@property (nonatomic, strong) NSMutableArray *m_date;

@end

@implementation MyTeamBulidViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    manger = [NetManger shareInstance];
    manger.keywork = @"";
    [manger loadData:RequestOfGetrongclouduserpagelist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createTableView) name:@"getrongclouduserpagelist" object:nil];
    //    [self createTableView];
    if (_m_date == nil)
    {
        _m_date = [NSMutableArray array];
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
    self.m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
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
            FriendListModel *fansModel = manger.clouduserpagelist[i];
            //            fansModel.EmployeeName = [NSString stringWithFormat:@"张连伟%d",i];
            NSLog(@"UserID - %@",fansModel.EmployeeID);
            [_m_dateArray addObject:fansModel];
        }
    }
    
    return _m_dateArray;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.m_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FriendListRightCell *cell = (FriendListRightCell *)[self.m_tableView cellForRowAtIndexPath:indexPath];
    FriendListModel *model = self.m_dateArray[indexPath.row];
    model.m_chooseBtn = !model.isChooseBtn;
    if (model.m_chooseBtn)
    { //选择了
        NSString *str = [NSString stringWithFormat:@"%@",model.EmployeeName];
        [self.m_date addObject:str];
        [self.m_fansListsArray addObject:model.EmployeeID];
        
    }
    else
    { //取消
        NSString *str = [NSString stringWithFormat:@"%@",model.EmployeeName];
        [self.m_date addObject:str];
        [self.m_fansListsArray removeObject:model.EmployeeID];
        
    }
    
    [cell rowSelected];
    NSLog(@"%@ %@",self.m_fansListsArray,_m_date);
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
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@",searchDisplayController.searchBar.text];
        filterData =  [[NSArray alloc] initWithArray:[_m_date filteredArrayUsingPredicate:predicate]];
        return filterData.count;
    }
    //    return self.m_dateArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendListRightCell *cell = [FriendListRightCell selectedCell:tableView];
    cell.tagLab.hidden = YES;
    if (tableView == self.m_tableView)
    {
        FriendListModel *model = self.m_dateArray[indexPath.row];
        cell.hearImg.layer.cornerRadius = 5;
        [cell.hearImg sd_setImageWithURL:[NSURL URLWithString:model.PhotoURL]];
        cell.m_model = model;
        cell.hearImg.layer.masksToBounds= YES;
        return cell;
    }
    else
    {
        FriendListModel *model = filterData[indexPath.row];
        cell.hearImg.layer.cornerRadius = 5;
        [cell.hearImg sd_setImageWithURL:[NSURL URLWithString:model.PhotoURL]];
        cell.m_model = model;
        cell.hearImg.layer.masksToBounds= YES;
        return cell;
    }
    
}
- (void)popCtr
{
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"请输入团队名"
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
            // 新建团队
            NSArray *users = self.m_fansListsArray;
            manger.myTeamBulids = users;
            manger.myTeamBulidName = nameField.text;
            [manger loadData:RequestOfEmployeeteamsave];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popCtrs) name:@"employeeteamsave" object:nil];
        }
    }
    else
    {
     [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (void)popCtrs
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end

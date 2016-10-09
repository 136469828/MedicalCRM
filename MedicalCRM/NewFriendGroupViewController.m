//
//  NewFriendGroupViewController.m
//  MedicalCRM
//
//  Created by admin on 16/8/6.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "NewFriendGroupViewController.h"
#import "NewFriendGroupCell.h"
#import "NetManger.h"
#import "MJExtension.h"
#import "NewFriendModel.h"
#import "AddFriendListViewController.h"
#import "ChatViewController.h"
#import <RongIMKit/RongIMKit.h>
@interface NewFriendGroupViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchControllerDelegate>
{
    NSArray *filterData;
    UISearchDisplayController *searchDisplayController;
    NetManger *manger;
    
}
@property (nonatomic, strong) NSMutableArray *m_datas;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation NewFriendGroupViewController
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
    // Do any additional setup after loading the view.
    manger = [NetManger shareInstance];
    manger.keywork = @"";
    [manger loadData:RequestOfGetrongclouduserpagelist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodatas) name:@"getrongclouduserpagelist" object:nil];
#pragma mark - 设置navigationItem右侧按钮
    UIButton *meassageBut = ({
        UIButton *meassageBut = [UIButton buttonWithType:UIButtonTypeCustom];
        meassageBut.frame = CGRectMake(0, 0, 20, 20);
        [meassageBut addTarget:self action:@selector(pushBulidCtr) forControlEvents:UIControlEventTouchDown];
        [meassageBut setImage:[UIImage imageNamed:@"addIcon"]forState:UIControlStateNormal];
        meassageBut;
    });
    
    UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithCustomView:meassageBut];
    self.navigationItem.rightBarButtonItem = rBtn;
}
- (void)relodatas
{
    for (NSDictionary *dic in manger.theNewFriendLists) {
        NewFriendModel *model = [NewFriendModel mj_objectWithKeyValues:dic];
        if (!_m_datas) {
            _m_datas = [NSMutableArray array];
        }
        [_m_datas addObject:[NSString stringWithFormat:@"%@,%@,%@",model.EmployeeName,model.UserID,model.DeptName]];
    }
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
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width
                                                                           , 44)];
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


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView)
    {
        return _m_datas.count;
    }else{
        // 谓词搜索
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@",searchDisplayController.searchBar.text];
        filterData =  [[NSArray alloc] initWithArray:[_m_datas filteredArrayUsingPredicate:predicate]];
        return filterData.count;
    }
//    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView)
    {
        // NSArray *array = [string componentsSeparatedByString:@"A"]; //从字符A中分隔成2个元素的数组
        NewFriendGroupCell *cell = [NewFriendGroupCell selectedCell:tableView];
        NSArray *datas = [[NSString stringWithFormat:@"%@",_m_datas[indexPath.row]] componentsSeparatedByString:@","];
        cell.subTitleLab.text = datas[2];
        cell.nameLab.text = datas[0];
        cell.tagLab.text = datas[1];
        return cell;
    }else{
        
        NewFriendGroupCell *cell = [NewFriendGroupCell selectedCell:tableView];
        NSArray *datas = [[NSString stringWithFormat:@"%@",filterData[indexPath.row]] componentsSeparatedByString:@","];
        cell.nameLab.text = datas[0];
        cell.subTitleLab.text = datas[2];
        cell.tagLab.text = datas[1];
        return cell;
    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewFriendGroupCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    ChatViewController *conversationVC = [[ChatViewController alloc]init];
    conversationVC.conversationType =ConversationType_PRIVATE;
    conversationVC.targetId = cell.tagLab.text; //这里模拟自己给自己发消息，您可以替换成其他登录的用户的UserId 110
    conversationVC.title = cell.nameLab.text;
    conversationVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:conversationVC animated:YES];
}
- (void)pushBulidCtr
{
    AddFriendListViewController *sub = [[AddFriendListViewController alloc] init];
    sub.title = @"选择好友";
    sub.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sub animated:YES];

}
@end

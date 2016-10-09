//
//  MyLeadershipTeamListController.m
//  MedicalCRM
//
//  Created by admin on 16/9/10.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "MyLeadershipTeamListController.h"
#import "NetManger.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "MyTeamListModel.h"
#import "MyteamInfoViewController.h"
@interface MyLeadershipTeamListController ()<UITableViewDataSource,UITableViewDelegate>
{
    NetManger *manger;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *m_datas;
@property (nonatomic, strong) NSMutableArray *m_users;

@end

@implementation MyLeadershipTeamListController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    manger = [NetManger shareInstance];
    manger.sType2 = @"1";
    manger.sType = @"0";
    [manger loadData:RequestOfGetpersonallinkmanpagelist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodatas) name:@"getpersonallinkmanpagelist" object:nil];
}
- (void)relodatas
{
    [_m_datas removeAllObjects];
    [_m_users removeAllObjects];
    for (NSDictionary *dic in manger.getpersonallinkmanpagelists)
    {
        MyTeamListModel *model = [MyTeamListModel mj_objectWithKeyValues:dic];
        if (!_m_datas)
        {
            _m_datas = [NSMutableArray array];
        }
        [_m_datas addObject:model];
//        for (NSDictionary *users_dic in model.users)
//        {
//            NSString *PersonName = users_dic[@"PersonName"];
//            if (!_m_users) {
//                _m_users = [NSMutableArray array];
//            }
//            [_m_users addObject:PersonName];
//        }
    }
    [self setTableView];
}
#pragma mark -
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 69) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //iOS 8开始的自适应高度，可以不需要实现定义高度的方法
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [_tableView.header endRefreshing];
    }];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [_tableView.footer endRefreshing];
    }];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _m_datas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *allCell = @"cell";
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:allCell];
        cell.selectionStyle = UITableViewCellAccessoryNone;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    MyTeamListModel *model = _m_datas[indexPath.row];
    cell.textLabel.text  = model.LinkmanName;
//    if (_m_users)
//    {
//        cell.detailTextLabel.text  = [NSString stringWithFormat:@"团队成员: %@",[_m_users componentsJoinedByString:@","]];
//    }
//    else
//    {
//        cell.detailTextLabel.text  = @"无成员";
//    }

    cell.tag = [model.UserId integerValue];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    manger.otherUserCode = [NSString stringWithFormat:@"%ld",cell.tag];
    manger.otherUserName = cell.textLabel.text;
    manger.userOtherID = manger.otherUserCode;
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end

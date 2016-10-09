//
//  ExhibitionListViewController.m
//  MedicalCRM
//
//  Created by admin on 16/8/5.
//  Copyright © 2016年 JCK. All rights reserved.
//RequestOfGetsellexhibitionpagelist

#import "ExhibitionListViewController.h"
#import "MJRefresh.h"
#import "ExhibitionbuildViewController.h"
#import "ExhibitionListCell.h"
#import "NetManger.h"
#import "MJExtension.h"
#import "ExhibitionListModel.h"
#import "ExhibitionInfoViewController.h"
@interface ExhibitionListViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchControllerDelegate>
{
    UISearchDisplayController *searchDisplayController;
    NetManger *manger;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *m_datas;
@end

@implementation ExhibitionListViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    manger = [NetManger shareInstance];
    [manger loadData:RequestOfGetsellexhibitionpagelist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloaddatas) name:@"getsellexhibitionpagelist" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
- (void)reloaddatas
{
//    manger.zhanhuis
    [_m_datas removeAllObjects];
    for (NSDictionary *dic in manger.zhanhuis)
    {
        ExhibitionListModel *model = [ExhibitionListModel mj_objectWithKeyValues:dic];
        if (!_m_datas) {
            _m_datas = [NSMutableArray array];
        }
        [_m_datas addObject:model];
    }
    [self setTableView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 69) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //iOS 8开始的自适应高度，可以不需要实现定义高度的方法
//    self.tableView.estimatedRowHeight = 200;
//    self.tableView.rowHeight = 120;
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

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _m_datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExhibitionListCell *cell = [ExhibitionListCell selectedCell:tableView];
    ExhibitionListModel *model = _m_datas[indexPath.row];
    cell.timeLab.text = [NSString stringWithFormat:@"%@ 至 %@",[model.ExhibitionStartDate substringToIndex:16],[model.ExhibitionEndDate substringToIndex:16]];
    cell.addressLab.text = model.Address;
    cell.titleLab.text = model.Title;
    cell.linkManLab.text = model.LinkManName;
    cell.cTimeLab.text = model.CreateDate;
    cell.tag = [model.ID integerValue];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExhibitionListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    ExhibitionInfoViewController *sub = [[ExhibitionInfoViewController alloc] init];
    sub.title = @"展会详情";
    sub.Id = [NSString stringWithFormat:@"%ld",cell.tag];
    [self.navigationController pushViewController:sub animated:YES];

}
- (void)pushBulidCtr
{
    ExhibitionbuildViewController *sub = [[ExhibitionbuildViewController alloc] init];
    sub.title = @"展会申请单";
    sub.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sub animated:YES];
}
@end

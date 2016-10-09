//
//  CustomerListViewController.m
//  MedicalCRM
//
//  Created by admin on 16/7/19.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "CustomerListViewController.h"
#import "NetManger.h"
#import "CustpagelistModel.h"
#import "CustlinkmanlistViewController.h"
#import "CustinfosaveViewController.h"
#import "MJRefresh.h"

@interface CustomerListViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchControllerDelegate>
{
    NetManger *manger;
    NSMutableArray *data;
    NSArray *filterData;
    UISearchDisplayController *searchDisplayController;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation CustomerListViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    manger = [NetManger shareInstance];
    [manger loadData:RequestOfGetminecustpagelist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloDatas) name:@"getminecustpagelist" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setTableView];
}
- (void)reloDatas
{
    [data removeAllObjects];
    for (int i = 0; i<manger.getminecustpagelist.count; i++) {
        CustpagelistModel *model = manger.getminecustpagelist[i];
        if (!data) {
            data = [NSMutableArray array];
        }
        [data addObject:model.CustName];
    }
    [self.tableView reloadData];
}
#pragma mark -
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-56) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //iOS 8开始的自适应高度，可以不需要实现定义高度的方法
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self reloDatas];
        [_tableView.mj_header endRefreshing];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self reloDatas];
        [_tableView.mj_footer endRefreshing];
    }];
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
//    return manger.getminecustpagelist.count;
    
    if (tableView == self.tableView) {
        return data.count;
    }else{
        // 谓词搜索
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@",searchDisplayController.searchBar.text];
        filterData =  [[NSArray alloc] initWithArray:[data filteredArrayUsingPredicate:predicate]];
        return filterData.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section // 返回组的头宽
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *allCell = @"cell";
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:allCell];
        cell.selectionStyle = UITableViewCellAccessoryNone;
    }
    CustpagelistModel *model = manger.getminecustpagelist[indexPath.row];
    if (tableView == self.tableView)
    {
        cell.textLabel.text = data[indexPath.row];
    }else{
        cell.textLabel.text = filterData[indexPath.row];
    }
    cell.tag = [model.ID integerValue];
    cell.detailTextLabel.text = model.CustNo;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:11];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头  
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (self.block)
    {
        self.block(cell.tag,cell.textLabel.text,cell.detailTextLabel.text,cell.detailTextLabel.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)pushCutonBuild
{
    CustinfosaveViewController *sub = [[CustinfosaveViewController alloc] init];
    sub.title = @"新建客户档案";
    sub.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sub animated:YES];

}
@end

//
//  TheNewSigninSelectCustorController.m
//  MedicalCRM
//
//  Created by admin on 16/8/25.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "TheNewSigninSelectCustorController.h"
#import "NetManger.h"
#import "MJExtension.h"
#import "TheNewCustomer.h"
#import "MJRefresh.h"
#import "TheNewCustomerListCell.h"
@interface TheNewSigninSelectCustorController ()<UITableViewDataSource,UITableViewDelegate,UISearchControllerDelegate>
{
    NetManger *manger;
    NSArray *data;
    NSArray *filterData;
    UISearchDisplayController *searchDisplayController;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *m_datas;
@property (nonatomic, strong) NSMutableArray *m_seachdatas;

@end

@implementation TheNewSigninSelectCustorController
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
    manger.keywork = @"";
    [manger loadData:RequestOfGetminelinkmanpagelist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodatas) name:@"getminelinkmanpagelist" object:nil];
}
- (void)relodatas
{
    [_m_seachdatas removeAllObjects];
    [_m_datas removeAllObjects];
    for (NSDictionary *dic in manger.theNewCustomList)
    {
        TheNewCustomer *model = [TheNewCustomer mj_objectWithKeyValues:dic];
        if (!_m_datas)
        {
            _m_datas = [NSMutableArray array];
        }
        [_m_datas addObject:model];
        if (!_m_seachdatas)
        {
            _m_seachdatas = [NSMutableArray array];
        }
        if ([model.CustName isEqualToString:@"待定"]) {
            model.CustName = @"未填写";
        }
        [_m_seachdatas addObject:[NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|%@",model.LinkManName,model.WorkTel,model.ID,model.CustName,model.CustID,model.Department,model.Position]];
        
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
    //    self.tableView.rowHeight = 60;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        
    }];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [_tableView.footer endRefreshing];
    }];
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
    
    if (tableView == self.tableView) {
        return _m_datas.count;
    }else{
        // 谓词搜索
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@",searchDisplayController.searchBar.text];
        filterData =  [[NSArray alloc] initWithArray:[_m_seachdatas filteredArrayUsingPredicate:predicate]];
        return filterData.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.tableView)
    {
        TheNewCustomerListCell *cell = [TheNewCustomerListCell selectedCell:tableView];
        TheNewCustomer *model = _m_datas[indexPath.row];
        cell.nameLab.text = model.LinkManName;
        cell.phoneLab.text = model.WorkTel;
        cell.tagLab.text = model.ID;
        cell.CompanyName.text = model.CustName;
        cell.zhiwuLab.text = model.Position;
        cell.keshiLab.text = model.Department;
        cell.tag = [model.CustID integerValue];
        return cell;
    }
    else
    {
        TheNewCustomerListCell *cell = [TheNewCustomerListCell selectedCell:tableView];
        data = [filterData[indexPath.row] componentsSeparatedByString:@"|"];
        cell.nameLab.text = data[0];
        cell.phoneLab.text = data[1];
        cell.tagLab.text = data[2];
        cell.CompanyName.text = data[3];
        cell.tag = [data[4] integerValue];
        cell.zhiwuLab.text = data[5];
        cell.keshiLab.text = data[6];
        return cell;
    }
    //    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TheNewCustomerListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //    JCKLog(@"%@,%@,%@",cell.nameLab.text,cell.phoneLab.text,cell.tagLab.text);
    //(NSString *name, NSString *phone , NSString *hospitalName,NSString *keshi,NSString *zhiwu, NSString *ID ,NSString *cusId);
    if (self.block)
    {
        self.block(cell.nameLab.text,cell.phoneLab.text,cell.CompanyName.text,cell.keshiLab.text,cell.zhiwuLab.text,cell.tagLab.text,[NSString stringWithFormat:@"%ld",cell.tag]);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end

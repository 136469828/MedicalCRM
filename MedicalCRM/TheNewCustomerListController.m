//
//  TheNewCustomerListController.m
//  MedicalCRM
//
//  Created by admin on 16/8/11.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "TheNewCustomerListController.h"
#import "NetManger.h"
#import "MJExtension.h"
#import "TheNewCustomer.h"
#import "MJRefresh.h"
#import "TheNewCustomerListCell.h"
#import "TheNewCustomInfoViewController.h"
#import "CustinfosaveViewController.h"
#import "TheNewCustomerSeachController.h"
@interface TheNewCustomerListController ()<UITableViewDataSource,UITableViewDelegate,UISearchControllerDelegate>
{
    NetManger *manger;
    NSArray *data;
    NSArray *filterData;
    int pag;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *m_datas;
@property (nonatomic, strong) NSMutableArray *m_seachdatas;

@end

@implementation TheNewCustomerListController
// 销毁通知中心
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    if (!manger.theNewCustomList)
    {
        manger = [NetManger shareInstance];
        manger.keywork = @"";
        pag = 20;
        manger.PageSize = [NSString stringWithFormat:@"%d",pag];
        [manger loadData:RequestOfGetminelinkmanpagelist];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodatas) name:@"getminelinkmanpagelist" object:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    manger = [NetManger shareInstance];
    manger.keywork = @"";
    pag = 20;
    manger.PageSize = [NSString stringWithFormat:@"%d",pag];
    [manger loadData:RequestOfGetminelinkmanpagelist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodatas) name:@"getminelinkmanpagelist" object:nil];
    [self hearView];
#pragma mark - 设置navigationItem右侧按钮
    UIButton *meassageBut = ({
        UIButton *meassageBut = [UIButton buttonWithType:UIButtonTypeCustom];
        meassageBut.frame = CGRectMake(0, 0, 20, 20);
        [meassageBut addTarget:self action:@selector(bulidAction) forControlEvents:UIControlEventTouchDown];
        [meassageBut setImage:[UIImage imageNamed:@"addIcon"]forState:UIControlStateNormal];
        meassageBut;
    });
    
    UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithCustomView:meassageBut];
    self.navigationItem.rightBarButtonItem = rBtn;
}
#pragma mark -
- (void)hearView{
#pragma - mark 中间搜索栏
    UIButton *seachButton = ({
        UIButton *seachButton = [UIButton buttonWithType:UIButtonTypeCustom];
        seachButton.layer.borderWidth = 1.0; // set borderWidth as you want.
        seachButton.layer.cornerRadius = 3.0f;
        seachButton.layer.masksToBounds=YES;
        seachButton.layer.borderColor = RGB(245, 245, 245).CGColor;
        seachButton.backgroundColor = RGB(245, 245, 245);
        seachButton.frame = CGRectMake(0, 0, ScreenWidth/1.3, 25);
        seachButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [seachButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [seachButton setTitle:[NSString stringWithFormat:@"搜索客户"]  forState:UIControlStateNormal];
        [seachButton addTarget:self action:@selector(pushSeachVC) forControlEvents:UIControlEventTouchDown];
        seachButton;
    });
    self.navigationItem.titleView = seachButton;
}
- (void)relodatas
{
    [_m_datas removeAllObjects];
    [_m_seachdatas removeAllObjects];
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
        [_m_seachdatas addObject:[NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@",model.LinkManName,model.WorkTel,model.ID,model.CustName,model.Position,model.Department]];
    }
    if (_tableView)
    {
        [_tableView reloadData];
    }
    else
    {
        [self setTableView];
    }
    
}
#pragma mark -
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 69) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //iOS 8开始的自适应高度，可以不需要实现定义高度的方法
    //    self.tableView.estimatedRowHeight = 200;
    //    self.tableView.rowHeight = 60;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [_tableView reloadData];
        [_tableView.header endRefreshing];
    }];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        manger.keywork = @"";
        pag = pag +10;
        manger.PageSize = [NSString stringWithFormat:@"%d",pag];
        [manger loadData:RequestOfGetminelinkmanpagelist];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodatas) name:@"getminelinkmanpagelist" object:nil];
        [_tableView.footer endRefreshing];
    }];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.tableView setBackgroundColor:RGB(239, 239, 244)];
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
        if ([model.CustName isEqualToString:@"待定"])
        {
            model.CustName = @"";
        }
        cell.CompanyName.text = model.CustName;
        cell.zhiwuLab.text = model.Position;
        cell.keshiLab.text = model.Department;
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
        cell.zhiwuLab.text = data[4];
        cell.keshiLab.text = data[5];
        return cell;
    }
    //    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.tableView)
    {
        TheNewCustomerListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        TheNewCustomInfoViewController *sub = [[TheNewCustomInfoViewController alloc] init];
        sub.title = @"客户详情";
        sub.ID = cell.tagLab.text;
//        TheNewCustomer *model2 = _m_datas[indexPath.row];
//        sub.model = model2;
        [self.navigationController pushViewController:sub animated:YES];
    }
    else
    {
        TheNewCustomerListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        TheNewCustomInfoViewController *sub = [[TheNewCustomInfoViewController alloc] init];
        sub.title = @"客户详情";
        sub.ID = cell.tagLab.text;
//        TheNewCustomer *model = [[TheNewCustomer alloc] init];
//        model.LinkManName = cell.nameLab.text;
//        model.WorkTel = cell.phoneLab.text;
//        model.CustName =  cell.CompanyName.text;
//        model.Department = cell.keshiLab.text;
//        model.Position = cell.zhiwuLab.text;
//        sub.model = model;
        [self.navigationController pushViewController:sub animated:YES];
    }
    
}
- (void)bulidAction
{
    CustinfosaveViewController *sub = [[CustinfosaveViewController alloc] init];
    sub.title = @"新建客户档案";
    [self.navigationController pushViewController:sub animated:YES];

}
- (void)pushSeachVC
{
    TheNewCustomerSeachController *sub = [[TheNewCustomerSeachController alloc] init];
    [self.navigationController pushViewController:sub animated:YES];

}
@end

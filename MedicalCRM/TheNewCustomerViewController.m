//
//  TheNewCustomerViewController.m
//  MedicalCRM
//
//  Created by admin on 16/8/11.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "TheNewCustomerViewController.h"
#import "NetManger.h"
#import "MJExtension.h"
#import "TheNewCustomer.h"
#import "MJRefresh.h"
#import "TheNewCustomerListCell.h"
#import "KeyboardToolBar.h"
#import "SigninSelectHospitalViewController.h"
@interface TheNewCustomerViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NetManger *manger;
    NSArray *data;
    NSArray *filterData;
    UITextField *seachTextField;
    int pag;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *m_datas;
@property (nonatomic, strong) NSMutableArray *m_seachdatas;
@end

@implementation TheNewCustomerViewController
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
    manger.PageSize = @"30";
    [manger loadData:RequestOfGetminelinkmanpagelist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodatas) name:@"getminelinkmanpagelist" object:nil];
    [self setTableView];
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
        if (model.Operation.length == 0) {
            model.Operation = @"";
        }
        [_m_seachdatas addObject:[NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|%@",model.LinkManName,model.WorkTel,model.ID,model.CustName,model.CustID,model.Department,model.Operation]];
        
    }
    [_tableView reloadData];
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
        [_tableView.mj_header endRefreshing];
    }];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        manger.keywork = @"";
        pag = pag +30;
        manger.PageSize = [NSString stringWithFormat:@"%d",pag];
        [manger loadData:RequestOfGetminelinkmanpagelist];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodatas) name:@"getminelinkmanpagelist" object:nil];
        [_tableView.footer endRefreshing];
    }];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
    [self hearView];
}
#pragma mark - tableView头视图
- (void)hearView{
    
    UIView *hearView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    //    hearView.backgroundColor = [UIColor redColor];
    seachTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 13, SCREEN_WIDTH - 80, 25)];
    seachTextField.layer.borderColor = [UIColor lightGrayColor].CGColor; // set color as you want.
    seachTextField.layer.borderWidth = 1.0; // set borderWidth as you want.
    seachTextField.layer.cornerRadius=8.0f;
    seachTextField.layer.masksToBounds=YES;
    seachTextField.font = [UIFont systemFontOfSize:13];
    seachTextField.backgroundColor = [UIColor whiteColor];
    [KeyboardToolBar registerKeyboardToolBar:seachTextField];
    [hearView addSubview:seachTextField];
    
    UIButton *seachBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [seachBtn setTitle:@"搜索" forState:UIControlStateNormal];
    seachBtn.frame = CGRectMake(SCREEN_WIDTH - 55, 13, 40, 25);
    seachBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    seachBtn.layer.borderColor = [UIColor lightGrayColor].CGColor; // set color as you want.
    seachBtn.layer.borderWidth = 1.0; // set borderWidth as you want.
    seachBtn.layer.cornerRadius=5.0f;
    seachBtn.layer.masksToBounds=YES;
    seachBtn.backgroundColor = [UIColor whiteColor];
    [seachBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [seachBtn addTarget:self action:@selector(seachOnSeach) forControlEvents:UIControlEventTouchDown];
    [hearView addSubview:seachBtn];
    _tableView.tableHeaderView = hearView;
    
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
        cell.zhiwuLab.text = model.Operation;
        cell.keshiLab.text = model.Department;
        cell.CompanyName.text = model.CustName;
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
        cell.keshiLab.text = data[5];
        cell.zhiwuLab.text = data[6];
        return cell;
    }
//    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TheNewCustomerListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    JCKLog(@"%@,%@,%@",cell.nameLab.text,cell.phoneLab.text,cell.tagLab.text);

    if (self.block)
    {
        self.block(cell.nameLab.text,cell.tagLab.text,cell.phoneLab.text,cell.CompanyName.text,[NSString stringWithFormat:@"%ld",cell.tag]);
    }
    [self.navigationController popViewControllerAnimated:YES];

}
- (void)seachOnSeach
{
    manger.keywork = seachTextField.text;
    pag = pag +30;
    manger.PageSize = [NSString stringWithFormat:@"%d",pag];
    [manger loadData:RequestOfGetminelinkmanpagelist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodatas) name:@"getminelinkmanpagelist" object:nil];
    [_tableView.footer endRefreshing];
}
@end

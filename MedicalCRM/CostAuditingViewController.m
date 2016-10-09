//
//  CostAuditingViewController.m
//  MedicalCRM
//
//  Created by admin on 16/8/13.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "CostAuditingViewController.h"
#import "MJExtension.h"
#import "CostAuditingListModel.h"
#import "MJRefresh.h"


#import "AuditClassViewController.h"
#import "AuditViewController.h"
#import "NetManger.h"
#import "MJExtension.h"
#import "CostAuditingListCell.h"
#import "WebModel.h"
#import "WebViewController.h"
#import "FiltrateView.h"
@interface CostAuditingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NetManger *manger;
    UIScrollView *mainScrollView;
}
@property (nonatomic, strong) NSMutableArray *m_datas;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation CostAuditingViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
}
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    manger = [NetManger shareInstance];
    manger.sType = @"1";
    [manger loadData:RequestOfGetfeeapplypagelistforcheck];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodatas) name:@"getfeeapplypagelistforcheck" object:nil];
}
- (void)relodatas
{
    [_m_datas removeAllObjects];
    JCKLog(@"%ld",manger.getfeeapplypagelistforchecks.count);
    for (NSDictionary *dic in manger.getfeeapplypagelistforchecks) {
        CostAuditingListModel *model = [CostAuditingListModel mj_objectWithKeyValues:dic];
        if (_m_datas.count == 0)
        {
            _m_datas = [[NSMutableArray alloc] initWithCapacity:0];
        }
        [_m_datas addObject:model];
    }
    //    JCKLog(@"%ld",_m_datas.count);
    if (_tableView)
    {
        [_tableView reloadData];
    }
    else
    {
        [self setTableView];
        [self setDateView];
    }

}
#pragma mark -
- (void)setTableView
{
    // setScrollView
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, ScreenWidth, ScreenHeight - 49-44)];
    mainScrollView.contentSize = CGSizeMake(1430, ScreenHeight - 49-44);
    [self.view addSubview:mainScrollView];

    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 1430, ScreenHeight - 69) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //iOS 8开始的自适应高度，可以不需要实现定义高度的方法
//        self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = 30;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [_tableView.mj_header endRefreshing];
    }];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [_tableView.footer endRefreshing];
    }];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
   [mainScrollView addSubview:_tableView];
}
- (void)setDateView
{
    NSArray *titleArr = @[@"时间",@"类型"];
    NSArray *firstDataArr = @[@"不限",@"最近一年",@"最近季度",@"最近一个月",@"最近一周",@"今天"];
    NSArray *secondDataArr = @[@"未审",@"通过",@"不通过",@"全部"];
    NSArray *dataArr = @[firstDataArr,secondDataArr];
    
    FiltrateView *filtreteView = [[FiltrateView alloc]initWithCount:2 withTitleArr:titleArr withDataArr:dataArr];
    filtreteView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    filtreteView.delegate = self;
    [self.view addSubview:filtreteView];
    //    return filtreteView;
}
//返回所点击内容
- (void)completionArr:(NSArray *)dataArr
{
    JCKLog(@"%@ %@",dataArr[0],dataArr[1]);
    if ([dataArr[0] isEqualToString:@"最近一年"])
    {
        manger.sType = @"5";
    }
    if ([dataArr[0] isEqualToString:@"最近季度"])
    {
        manger.sType = @"4";
    }
    if ([dataArr[0] isEqualToString:@"最近一个月"])
    {
        manger.sType = @"3";
    }
    if ([dataArr[0] isEqualToString:@"最近一周"])
    {
        manger.sType = @"2";
    }
    if ([dataArr[0] isEqualToString:@"今天"])
    {
        manger.sType = @"1";
    }
    if ([dataArr[1] isEqualToString:@"未审"])
    {
        manger.sType = @"1";
    }
    if ([dataArr[1] isEqualToString:@"通过"])
    {
        manger.sType = @"0";
    }
    if ([dataArr[1] isEqualToString:@"不通过"])
    {
        manger.sType = @"2";
    }
    if ([dataArr[1] isEqualToString:@"全部"])
    {
        manger.sType = @"-1";
    }
    //    JCKLog(@"%@-%@",manger.sType,manger.sType3);
    [manger loadData:RequestOfGetfeeapplypagelistforcheck];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodatas) name:@"getfeeapplypagelistforcheck" object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_m_datas.count == 0)
    {
        //初始化提示框；
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"暂无需要您审核的事项" preferredStyle: UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //点击按钮的响应事件；
            
        }]];
        
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
        return 0;
    }
    else
    {
        return _m_datas.count +1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CostAuditingListCell *cell = [CostAuditingListCell selectedCell:tableView];
    if (indexPath.row != 0 )
    {
//        model.ProjectName.leng
//        if (<#condition#>) {
//            <#statements#>
//        }
        CostAuditingListModel *model = _m_datas[indexPath.row - 1];
        if (model.ProjectName.length != 0)
        {
            //        cell.titleLab.text = model.Title;
            cell.priceLab.text = model.TotalAmount;
            cell.projectLab.text = model.ProjectName;
            cell.timeLab.text=model.CreateDate;
            cell.resonLab.text =model.Reason;
            cell.nameLab.text =model.CreatorName;
            cell.costNo.text = model.ExpCode;
            cell.shangwu.text = model.BusinessCheckMan;
            cell.daqu.text = model.BigAreaCheckMan;
            cell.zongjingli.text = model.SaleManagerCheckMan;
            cell.lindao.text = model.CompanyLeaderCheckMan;
            cell.paragraphLab.text = model.AcceptMoneyDate;
            cell.chengguochi.text = model.ChenGuo;
            cell.caiwu.text = model.FinanceCheckMan;
            cell.tag = [model.ID integerValue];
        }
       
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0)
    {
        CostAuditingListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        //    CostAuditingListModel *models = _m_datas[indexPath.row];
        //    AuditViewController *sub = [[AuditViewController alloc] init];
        //    sub.title = @"审批详情";
        //    sub.model2 = models;
        //    sub.stye = 1;
        //    sub.ID = [NSString stringWithFormat:@"%ld",cell.tag];
        //    [self.navigationController pushViewController:sub animated:YES];
        NSString *url = [NSString stringWithFormat:@"http://beaconapi.meidp.com/Mobi/CheckCenter/FeeApplyCheck?Id=%@&code=%@",[NSString stringWithFormat:@"%ld",cell.tag],[NetManger shareInstance].userCode];
        WebModel *model = [[WebModel alloc] initWithUrl:url];
        WebViewController *SVC = [[WebViewController alloc] init];
        SVC.title = @"费用审批详情";
        SVC.hidesBottomBarWhenPushed = YES;
        [SVC setModel:model];
        [self.navigationController pushViewController:SVC animated:YES];
    }

    
}
#pragma mark - pushBuild
- (void)pushBuild
{
    AuditClassViewController *sub = [[AuditClassViewController alloc] init];
    sub.title = @"选择报审类别";

    [self.navigationController pushViewController:sub animated:YES];
    
}

@end

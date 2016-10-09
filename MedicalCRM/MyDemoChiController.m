//
//  MyDemoChiController.m
//  MedicalCRM
//
//  Created by admin on 16/7/30.
//  Copyright © 2016年 JCK. All rights reserved.
//getsellsamplepagelist

#import "MyDemoChiController.h"
#import "MJRefresh.h"
#import "NetManger.h"
#import "MyDemoModel.h"
#import "MJExtension.h"
#import "FuntionObj.h"
#import "MyDemoChiCell.h"
#import "DemoMachineSaveController.h"
#import "PayInfoViewController.h"
#import "KeyboardToolBar.h"
#import "WebModel.h"
#import "WebViewController.h"
@interface MyDemoChiController ()<UITableViewDataSource,UITableViewDelegate>
{
    NetManger *manger;
    NSMutableArray *data;
    NSArray *filterData;
    NSString *proLinkMan;
    UIScrollView *mainScrollView;
        UITextField *seachTextField;
}
@property (nonatomic, strong) NSMutableArray *m_datas;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation MyDemoChiController
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
    [manger loadData:RequestOfGetsellsamplepagelist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodatas) name:@"getsellsamplepagelist" object:nil];
    [self setTableView];
//#pragma mark - 设置navigationItem右侧按钮
//    UIButton *meassageBut = ({
//        UIButton *meassageBut = [UIButton buttonWithType:UIButtonTypeCustom];
//        meassageBut.frame = CGRectMake(0, 0, 20, 20);
//        [meassageBut addTarget:self action:@selector(pushBulidCtr) forControlEvents:UIControlEventTouchDown];
//        [meassageBut setImage:[UIImage imageNamed:@"addIcon"]forState:UIControlStateNormal];
//        meassageBut;
//    });
//    
//    UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithCustomView:meassageBut];
//    self.navigationItem.rightBarButtonItem = rBtn;
}
- (void)relodatas
{
    [_m_datas removeAllObjects];
    [data removeAllObjects];
    for (NSDictionary *dic in manger.getsellsamplepagelist) {
        MyDemoModel *model = [MyDemoModel mj_objectWithKeyValues:dic];
        if (!_m_datas) {
            _m_datas = [NSMutableArray array];
        }
        [_m_datas addObject:model];
        if ([FuntionObj isNullDic:dic Key:@"ProductName"])
        {
            model.ProductName = dic[@"ProductName"];
        }
        else
        {
            model.ProductName = @"未填写";
        }
        if (!data) {
            data = [NSMutableArray array];
        }
        [data addObject:model.Title];
    }
    
    [_tableView reloadData];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setBackgroundColor:RGB(239, 239, 244)];
}
#pragma mark -
- (void)setTableView
{
    // setScrollView
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth, ScreenHeight - 49-0)];
    mainScrollView.contentSize = CGSizeMake(676, ScreenHeight - 49-40);
    [self.view addSubview:mainScrollView];
    

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 676, ScreenHeight - 69) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.backgroundColor = RGB(239, 239, 244);
    //iOS 8开始的自适应高度，可以不需要实现定义高度的方法
//    self.tableView.estimatedRowHeight = 200;
//    self.tableView.rowHeight = 120;//UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [_tableView.mj_header endRefreshing];
    }];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [_tableView.footer endRefreshing];
    }];
    [self hearView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [mainScrollView addSubview:_tableView];
}
#pragma mark - tableView头视图
- (void)hearView{
    
    UIView *hearView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    //    hearView.backgroundColor = [UIColor redColor];
    seachTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 5, SCREEN_WIDTH - 80, 30)];
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
    seachBtn.frame = CGRectMake(SCREEN_WIDTH - 55, 5, 40, 30);
    seachBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    seachBtn.layer.borderColor = [UIColor lightGrayColor].CGColor; // set color as you want.
    seachBtn.layer.borderWidth = 1.0; // set borderWidth as you want.
    seachBtn.layer.cornerRadius=5.0f;
    seachBtn.layer.masksToBounds=YES;
    seachBtn.backgroundColor = [UIColor whiteColor];
    [seachBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [seachBtn addTarget:self action:@selector(seachOnSeach) forControlEvents:UIControlEventTouchDown];
    [hearView addSubview:seachBtn];
    [self.view addSubview:hearView];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _m_datas.count+1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 31;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyDemoChiCell *cell = [MyDemoChiCell selectedCell:tableView];
    if (indexPath.row != 0)
    {
        MyDemoModel *model = _m_datas[indexPath.row-1];
        proLinkMan = model.CreatorName;
        cell.productName.text = model.ProductName;
        cell.timeLab.text =    [model.CreateDate substringToIndex:16];
        cell.cusName.text = model.CustName;
        cell.priceLab.text = model.TotalFee;
        cell.productNo.text = model.ApplyNo;
        cell.productCount.text = model.ProductCount;
        cell.tag = [model.ID integerValue];
    }

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0)
    {
        // "http://beaconapi.meidp.com/Mobi/Order/SellSample?Id=" + id + "&UserId=" + userId;
        MyDemoChiCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        MyDemoModel *model = _m_datas[indexPath.row];
//        PayInfoViewController *sub = [[PayInfoViewController alloc] init];
//        sub.title = @"样机详情";
//        sub.ProjectName = model.ProjectName;
//        sub.FlowStatusName = model.FlowStatusName;
//        sub.ID = [NSString stringWithFormat:@"%ld",cell.tag];
//        [self.navigationController pushViewController:sub animated:YES];
        NSString *url = [NSString stringWithFormat:@"http://beaconapi.meidp.com/Mobi/Order/SellSample?Id=%@&UserId=%@",[NSString stringWithFormat:@"%ld",cell.tag],[NetManger shareInstance].userOtherID];
        WebModel *model = [[WebModel alloc] initWithUrl:url];
        WebViewController *SVC = [[WebViewController alloc] init];
        SVC.title = @"样机详情";
        SVC.hidesBottomBarWhenPushed = YES;
        [SVC setModel:model];
        [self.navigationController pushViewController:SVC animated:YES];
        
    }

}
- (void)pushBulidCtr
{
    DemoMachineSaveController *sub = [[DemoMachineSaveController alloc] init];
    sub.title = @"样机申请";
    sub.ID = @(0);
    [self.navigationController pushViewController:sub animated:YES];

}
- (void)seachOnSeach
{
    manger.keywork = seachTextField.text;
    [manger loadData:RequestOfGetsellsamplepagelist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodatas) name:@"getsellsamplepagelist" object:nil];
}
@end

//
//  StockUpListViewController.m
//  MedicalCRM
//
//  Created by admin on 16/8/16.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "StockUpListViewController.h"
#import "NetManger.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "StopckUpListModel.h"
#import "StockUpListCell.h"
#import "StockUpInfoViewController.h"
#import "SVProgressHUD.h"
#import "KeyboardToolBar.h"
#import "WebModel.h"
#import "WebViewController.h"
#import "FiltrateView.h"
@interface StockUpListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NetManger *manger;
     UITextField *tf;
    UIScrollView *mainScrollView;
    
    int page;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *m_datas;
@end

@implementation StockUpListViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view .backgroundColor = [UIColor whiteColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    manger = [NetManger shareInstance];
    manger.sType = @"1";
    manger.keywork = @"";
    page = 20;
    manger.PageSize = [NSString stringWithFormat:@"%d",page];
    [manger loadData:RequestOfGetsellorderpagelistforcheck];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloaddatas) name:@"getsellorderpagelistforcheck" object:nil];
    UIButton *meassageBut = ({
        UIButton *meassageBut = [UIButton buttonWithType:UIButtonTypeCustom];
        meassageBut.frame = CGRectMake(0, 0, 40, 20);
        meassageBut.titleLabel.font = [UIFont systemFontOfSize:15];
        [meassageBut setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [meassageBut addTarget:self action:@selector(seachBtn) forControlEvents:UIControlEventTouchDown];
        [meassageBut setTitle:@"搜索" forState:UIControlStateNormal];
        meassageBut;
    });
    
    UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithCustomView:meassageBut];
    self.navigationItem.rightBarButtonItem = rBtn;
    tf = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth*0.6, 25)];
    tf.placeholder = @"请输入...";
    tf.font = [UIFont systemFontOfSize:12];
    tf.backgroundColor = RGB(245, 245, 245);
    tf.layer.cornerRadius = 5;
    tf.layer.borderColor = RGB(245, 245, 245).CGColor;
    tf.layer.borderWidth = 1;
    tf.layer.masksToBounds = YES;
    [KeyboardToolBar registerKeyboardToolBar:tf];
    self.navigationItem.titleView = tf;
    
}
- (void)reloaddatas
{
    [_m_datas removeAllObjects];
    for (NSDictionary *dic in manger.sellorderpagelistforcheck)
    {
        StopckUpListModel *model = [StopckUpListModel mj_objectWithKeyValues:dic];
        if (!_m_datas) {
            _m_datas = [NSMutableArray array];
        }
        [_m_datas addObject:model];
    }
    if (_tableView)
    {
        [_tableView reloadData];
    }
    else
    {
        [self setTableView];
        [self setDateView];
    }

    [SVProgressHUD dismiss];
}
#pragma mark -
- (void)setTableView
{
    // setScrollView
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, ScreenWidth, ScreenHeight - 49-44)];
    mainScrollView.contentSize = CGSizeMake(1000, ScreenHeight - 49-44);
    [self.view addSubview:mainScrollView];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 1000, ScreenHeight - 69) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //iOS 8开始的自适应高度，可以不需要实现定义高度的方法
//    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = 30;
//    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        // 进入刷新状态后会自动调用这个block
//        
//    }];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page = page+5;
//        manger.keywork = @"";
        manger.PageSize = [NSString stringWithFormat:@"%d",page];
        [manger loadData:RequestOfGetsellorderpagelistforcheck];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloaddatas) name:@"getsellorderpagelistforcheck" object:nil];
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
    JCKLog(@"%@-%@",manger.sType,manger.sType3);
    manger.keywork = @"";
    [manger loadData:RequestOfGetsellorderpagelistforcheck];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloaddatas) name:@"getsellorderpagelistforcheck" object:nil];
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
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"暂无您的备货信息" preferredStyle: UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //点击按钮的响应事件；
            
        }]];
        
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
        return 0;
    }
    else
    {
        return _m_datas.count + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StockUpListCell *cell = [StockUpListCell selectedCell:tableView];
    if (indexPath.row != 0)
    {
        StopckUpListModel *model = _m_datas[indexPath.row - 1];
        if (![model.ProductID isEqualToString:@"0"])
        {
            cell.productNoLab.text = model.OrderNo;
            cell.priceLab.text = model.TotalFee;
            cell.cusLab.text = model.CustName;
            cell.timeLab.text = [model.CreateDate substringToIndex:16];
            cell.productNameLab.text = model.ProjectName;
            cell.creName.text = model.CreatorName;
            cell.tag = [model.ID integerValue];
            cell.updateTimeLab.text = [model.CreateDate substringToIndex:16];
        }
        

    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0)
    {
        StockUpListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        StockUpInfoViewController *sub = [[StockUpInfoViewController alloc] init];
//        sub.title = @"价格审批详情";
//        sub.isAudit = self.isAduit;
//        sub.ID = [NSString stringWithFormat:@"%ld",cell.tag];
//        [self.navigationController pushViewController:sub animated:YES];
        NSString *url = [NSString stringWithFormat:@"http://beaconapi.meidp.com/Mobi/CheckCenter/OrderPriceCheck?Id=%@&code=%@",[NSString stringWithFormat:@"%ld",cell.tag],[NetManger shareInstance].userCode];
        WebModel *model = [[WebModel alloc] initWithUrl:url];
        WebViewController *SVC = [[WebViewController alloc] init];
        SVC.title = @"价格审批详情";
        SVC.hidesBottomBarWhenPushed = YES;
        [SVC setModel:model];
        [self.navigationController pushViewController:SVC animated:YES];
    }
}
- (void)seachBtn
{
    manger.sType = @"-1";
    manger.keywork = tf.text;
    [manger loadData:RequestOfGetsellorderpagelistforcheck];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloaddatas) name:@"getsellorderpagelistforcheck" object:nil];
    
}
@end

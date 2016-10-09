//
//  DayPlanListViewController.m
//  MedicalCRM
//
//  Created by admin on 16/8/2.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "DayPlanListViewController.h"
#import "DayPlanController.h"
#import "MJRefresh.h"
#import "FiltrateView.h"
#import "DayPlanListCell.h"
#import "NetManger.h"
#import "MJExtension.h"
#import "DayPlantListModel.h"
#import "DayPlantInfoViewController.h"
@interface DayPlanListViewController ()<UITableViewDataSource,UITableViewDelegate,FiltrateViewDelegate>
{
    UILabel *selectedDayLabel;
    NetManger *manger;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;
@end

@implementation DayPlanListViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    manger = [NetManger shareInstance];
    manger.sType = @"-1";
    manger.keywork = @"";
    [manger loadData:RequestOfGetplanaimpagelist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodatas) name:@"getplanaimpagelist" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
#pragma mark - 设置navigationItem右侧按钮
    UIButton *meassageBut = ({
        UIButton *meassageBut = [UIButton buttonWithType:UIButtonTypeCustom];
        meassageBut.frame = CGRectMake(0, 0, 20, 20);
        [meassageBut addTarget:self action:@selector(newPlan) forControlEvents:UIControlEventTouchDown];
        [meassageBut setImage:[UIImage imageNamed:@"addIcon"]forState:UIControlStateNormal];
        meassageBut;    });
    
    UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithCustomView:meassageBut];
    self.navigationItem.rightBarButtonItem = rBtn;
}
- (void)relodatas
{

//    for (int i = 0; i<manger.getplanaimpagelist.count; i++) {
//        day
//    }
    [self.datas removeAllObjects];
    for (NSDictionary *dic in manger.getplanaimpagelist)
    {
        DayPlantListModel *model = [DayPlantListModel mj_objectWithKeyValues:dic];
        if (!self.datas) {
            self.datas = [[NSMutableArray alloc] initWithCapacity:0];
        }
        [self.datas addObject:model];
    }
    [self setTableView];
}
- (UIView *)setDateView
{
    NSArray *titleArr = @[@"时间",@"类型"];
    NSArray *firstDataArr = @[@"不限",@"最近一年",@"最近一个月",@"最近一周",@"更多"];
    NSArray *secondDataArr = @[@"重要",@"一般"];
    NSArray *dataArr = @[firstDataArr,secondDataArr];
    
    
    FiltrateView *filtreteView = [[FiltrateView alloc]initWithCount:2 withTitleArr:titleArr withDataArr:dataArr];
    filtreteView.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
    filtreteView.delegate = self;
//    [self.view addSubview:filtreteView];
    return filtreteView;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSDate *day = change[NSKeyValueChangeNewKey];
    
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:day];
    //输出currentDateString
    NSLog(@"%@",currentDateString);
    
    
    selectedDayLabel.text =  currentDateString;//[NSDateFormatter localizedStringFromDate:day dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
    
}

#pragma mark -
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 69) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //iOS 8开始的自适应高度，可以不需要实现定义高度的方法
//    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = 80;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [_tableView.mj_header endRefreshing];
    }];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [_tableView.footer endRefreshing];
    }];
//    _tableView.tableHeaderView = [self setDateView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    _tableView.tableHeaderView = [self setDateView];
    [self.view addSubview:_tableView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - FiltrateViewDelegate
//返回所点击内容
- (void)completionArr:(NSArray *)dataArr
{
    for (NSString *str in dataArr)
    {
        NSLog(@"%@",str);
        if ([str isEqualToString:@"不限"])
        {
            manger.sType = @"-1";
            manger.keywork = @"";
        }
        else if ([str isEqualToString:@"最近一年"])
        {
            manger.sType = @"5";
            manger.keywork = @"";
        }
        else if ([str isEqualToString:@"最近一个月"])
        {
            manger.sType = @"3";
            manger.keywork = @"";
        }
        else if ([str isEqualToString:@"最近一周"])
        {
            manger.sType = @"2";
            manger.keywork = @"";
        }
        else if ([str isEqualToString:@"重要"])
        {
            manger.sType = @"-1";
            manger.keywork = @"4";
        }
        else if ([str isEqualToString:@"一般"])
        {
            manger.sType = @"-1";
            manger.keywork = @"2";
        }
        else if ([str isEqualToString:@"更多"])
        {
            manger.sType = @"1";
            manger.keywork = @"";
        }
        [manger loadData:RequestOfGetplanaimpagelist];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodatas) name:@"getplanaimpagelist" object:nil];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DayPlantListModel *model = self.datas[indexPath.row];
    DayPlanListCell *cell = [DayPlanListCell selectedCell:tableView DataModel:model];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DayPlantInfoViewController *sub = [[DayPlantInfoViewController alloc] init];
    sub.title = @"计划内容";
    DayPlantListModel *model = self.datas[indexPath.row];
    sub.datas = @[model.AimTitle,model.AimDirectionName,model.StartDate,model.EndDate,model.AimSortName,model.AimContent];
    [self.navigationController pushViewController:sub animated:YES];

}
- (void)newPlan
{
    DayPlanController *sub = [[DayPlanController alloc] init];
    sub.title = @"新建工作计划";
    [self.navigationController pushViewController:sub animated:YES];

}
@end

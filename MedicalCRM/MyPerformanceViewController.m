//
//  MyPerformanceViewController.m
//  MedicalCRM
//
//  Created by admin on 16/7/23.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "MyPerformanceViewController.h"
#import "ChartLineInfoView.h"
#import "PNChart.h"
#import "CONST.h"
#import "LQRadarChart.h"
#import "NetManger.h"
#import "PerformanceModel.h"
#import "MyPerformanceTableViewCell.h"
#import "KeyboardToolBar.h"
@interface MyPerformanceViewController ()<LQRadarChartDataSource,LQRadarChartDelegate,UITableViewDataSource,UITableViewDelegate>
{
    ChartLineInfoView *lineView;
    NetManger *manger;
    UITextField *tf;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) PNPieChart *pieChart;
@end

@implementation MyPerformanceViewController
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
    // Do any additional setup after loading the view, typically from a nib.
    manger = [NetManger shareInstance];
    manger.starDate = @"2016-01-01";
    manger.endDate = [self getData];
    [manger loadData:RequestOfGetmyachievement];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodatas) name:@"getmyachievement" object:nil];
    
    UIButton *meassageBut = ({
        UIButton *meassageBut = [UIButton buttonWithType:UIButtonTypeCustom];
        meassageBut.frame = CGRectMake(0, 0, 40, 20);
        meassageBut.titleLabel.font = [UIFont systemFontOfSize:15];
        [meassageBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [meassageBut addTarget:self action:@selector(seachBtn) forControlEvents:UIControlEventTouchDown];
        [meassageBut setTitle:@"搜索" forState:UIControlStateNormal];
        meassageBut;
    });
    
    UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithCustomView:meassageBut];
    self.navigationItem.rightBarButtonItem = rBtn;
    tf = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth*0.6, 25)];
    tf.placeholder = @"请输入...";
    tf.font = [UIFont systemFontOfSize:12];
    tf.backgroundColor = RGB(234, 234, 234);
    tf.layer.cornerRadius = 5;
    tf.layer.borderColor = RGB(234, 234, 234).CGColor;
    tf.layer.borderWidth = 1;
    tf.layer.masksToBounds = YES;
    [KeyboardToolBar registerKeyboardToolBar:tf];
    //    [tf becomeFirstResponder];
    self.navigationItem.titleView = tf;
}
- (void)relodatas
{
    [self setTableView];
}
#pragma mark -
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,ScreenHeight-56) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //iOS 8开始的自适应高度，可以不需要实现定义高度的方法
    self.tableView.rowHeight = 150;
    
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyPerformanceTableViewCell *cell = [MyPerformanceTableViewCell selectedCell:tableView];
    if (indexPath.row == 1)
    {
        cell.namelab.text = @"王显宁(市场2部)";
        cell.titmeLab.text = @"起止时间: 2016-02-06 ~ 2016-08-02";
        cell.totlePrice.text = @"项目总费用: 300,000,00";
    }
        return cell;
}

#pragma - mark 折线图
- (UIView *)view1
{
    lineView = [[ChartLineInfoView alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth-10, 200)];
    lineView.backgroundColor = [UIColor clearColor];
    lineView.leftDataArr =  @[@"0.2",@"0.4",@"0.5",@"0.2",@"0.7",@"0.5"];
    lineView.rightDataArr = @[@"0.2",@"0.0",@"0.4",@"0.7",@"0.3",@"0.5"];
    return lineView;
}

#pragma mark - 饼图
-(UIView *)createTableView
{

    float expenseTotal = [manger.expenseTotal floatValue];
    float sellTotal = [manger.sellTotal floatValue]; 
    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:expenseTotal color:PNLightGreen description:@"总报销费用"],
                       [PNPieChartDataItem dataItemWithValue:sellTotal color:PNFreshGreen description:@"总到款数"],
//                       [PNPieChartDataItem dataItemWithValue:20 color:PNDeepGreen description:@"未结项目"],
                       ];
    
    self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(APPW/2.0 - 100, 10, 200.0, 200.0) items:items];
    self.pieChart.descriptionTextColor = [UIColor whiteColor];
    self.pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
    self.pieChart.descriptionTextShadowColor = [UIColor clearColor];
    self.pieChart.showAbsoluteValues = NO;
    self.pieChart.showOnlyValues = NO;
    [self.pieChart strokeChart];
    self.pieChart.legendStyle = PNLegendItemStyleStacked;
    self.pieChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
    
    UIView *legend = [self.pieChart getLegendWithMaxWidth:200];
    [legend setFrame:CGRectMake(0, 220, legend.frame.size.width, legend.frame.size.height)];
    [self.pieChart addSubview:legend];
    
    return  self.pieChart;
}
#pragma mark -
- (UIView *)view3
{
    //    CGFloat w = self.view.frame.size.width;
    LQRadarChart * chart = [[LQRadarChart alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
    chart.center = CGPointMake(SCREEN_WIDTH/2, 150);
    chart.radius = 300 / 3;
    chart.delegate = self;
    chart.dataSource = self;
    [chart reloadData];
    return chart;
}
- (NSInteger)numberOfStepForRadarChart:(LQRadarChart *)radarChart
{
    return 5;
}
- (NSInteger)numberOfRowForRadarChart:(LQRadarChart *)radarChart
{
    return 6;
}
- (NSInteger)numberOfSectionForRadarChart:(LQRadarChart *)radarChart
{
    return 2;
}
- (NSString *)titleOfRowForRadarChart:(LQRadarChart *)radarChart row:(NSInteger)row
{
    NSArray * title = @[@"时间成本",@"费用成本",@"成功率",@"项目周期",@"客户满意度",@"项目质量"];
    return title[row];
}
- (CGFloat)valueOfSectionForRadarChart:(LQRadarChart *)radarChart row:(NSInteger)row section:(NSInteger)section
{
    if (section == 0 ){
        return (CGFloat)(MAX(MIN(row + 1, 4), 3));
    } else {
        return 3;
    }
}



- (UIColor *)colorOfTitleForRadarChart:(LQRadarChart *)radarChart
{
    return [UIColor blackColor];
    
}
- (UIColor *)colorOfLineForRadarChart:(LQRadarChart *)radarChart
{
    return [UIColor colorWithRed:0.337 green:0.847 blue:0.976 alpha:1];
    
}
- (UIColor *)colorOfFillStepForRadarChart:(LQRadarChart *)radarChart step:(NSInteger)step
{
    UIColor * color = [UIColor whiteColor];
    switch (step) {
        case 1:
            color = [UIColor colorWithRed:0.545 green:0.906 blue:0.996 alpha:1];
            break;
        case 2:
            color = [UIColor colorWithRed:0.706 green:0.929 blue:0.988 alpha:1];
            break;
        case 3:
            color = [UIColor colorWithRed:0.831 green:0.949 blue:0.984 alpha:1];
            break;
        case 4:
            color = [UIColor colorWithRed:0.922 green:0.976 blue:0.998 alpha:1];
            break;
            
        default:
            break;
    }
    return color;
}
- (UIColor *)colorOfSectionFillForRadarChart:(LQRadarChart *)radarChart section:(NSInteger)section
{
    if (section == 0) {
        return [UIColor colorWithRed:1 green:0.867 blue:0.012 alpha:0.4];
    }else{
        return [UIColor colorWithRed:0 green:0.788 blue:0.543 alpha:0.4];
    }
}
- (UIColor *)colorOfSectionBorderForRadarChart:(LQRadarChart *)radarChart section:(NSInteger)section
{
    if (section == 0) {
        return [UIColor colorWithRed:1 green:0.867 blue:0.012 alpha:0.4];
    }else{
        return [UIColor colorWithRed:0 green:0.788 blue:0.543 alpha:0.4];
    }
    
}
- (UIFont *)fontOfTitleForRadarChart:(LQRadarChart *)radarChart
{
    return [UIFont systemFontOfSize:11];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)seachBtn
{
    [_tableView reloadData];
}
#pragma mark - Tool
- (NSString *)getData
{
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    
    return locationString;
}
@end

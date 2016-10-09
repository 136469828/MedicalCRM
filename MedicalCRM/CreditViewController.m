//
//  CreditViewController.m
//  MedicalCRM
//
//  Created by admin on 16/7/14.
//  Copyright © 2016年 JCK. All rights reserved.
//诚信度=我的成交/（我失败的+我成交的）

#import "CreditViewController.h"
#import "LXCircleAnimationView.h"
#import "UIView+Extensions.h"
#import "CredlitCell.h"
#import "NetManger.h"
@interface CreditViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString *FinishProejct;
    NSString *MyProperty;
    NSString *PrjectTotalCount;
    NSString *ProjectGathering;
    NSString *ProjectReimburse;
    NSString *ProjectTotalMoney;
}
@property (nonatomic, strong) LXCircleAnimationView *circleProgressView;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation CreditViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    UIButton *stareButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    stareButton.frame = CGRectMake(10.f,ScreenHeight -69- 38, SCREEN_WIDTH - 20.f, 38.f);
//    [stareButton addTarget:self action:@selector(onStareButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [stareButton setTitle:@"开始评价我的信用" forState:UIControlStateNormal];
//    [stareButton setBackgroundColor:RGB(97, 125, 255)];
//    stareButton.layer.masksToBounds = YES;
//    stareButton.layer.cornerRadius = 4.f;
//    [self.view addSubview:stareButton];
    NetManger *manger = [NetManger shareInstance];
    [manger loadData:RequestOfGetachievementtotal];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloaddatas:) name:@"getachievementtotal" object:nil];
}
- (void)reloaddatas:(NSNotification *)obj
{
    JCKLog(@"%@",obj.object);
    /*
     FinishProejct = 0;
     MyProperty = 0;
     PrjectTotalCount = 3;
     ProjectGathering = 0;
     ProjectReimburse = 0;
     ProjectTotalMoney = 151000;
     */
    NSDictionary *dic = obj.object;
//    JCKLog(@"%@",dic[@"data"][@"FinishProejct"]);
    FinishProejct = [NSString stringWithFormat:@"%@",dic[@"data"][@"FinishProejct"]];
    MyProperty = [NSString stringWithFormat:@"%@",dic[@"data"][@"MyProperty"]];
    PrjectTotalCount = [NSString stringWithFormat:@"%@",dic[@"data"][@"PrjectTotalCount"]];
    ProjectGathering = [NSString stringWithFormat:@"%@",dic[@"data"][@"ProjectGathering"]];
    ProjectReimburse = [NSString stringWithFormat:@"%@",dic[@"data"][@"ProjectReimburse"]];
    ProjectTotalMoney = [NSString stringWithFormat:@"%@ 元",dic[@"data"][@"ProjectTotalMoney"]];


    [self setTableView];
}
#pragma mark -
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = RGB(239, 239, 244);
    //iOS 8开始的自适应高度，可以不需要实现定义高度的方法
//    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = 200;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section // 返回组的头宽
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;// 返回组的尾宽
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     FinishProejct = 0;
     MyProperty = 0;
     PrjectTotalCount = 3;
     ProjectGathering = 0;
     ProjectReimburse = 0;
     ProjectTotalMoney = 151000;
     */
    if (indexPath.row == 0)
    {
        static NSString *allCell = @"cell";
        UITableViewCell *cell = nil;
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:allCell];
            cell.selectionStyle = UITableViewCellAccessoryNone;
        }
        self.view.backgroundColor = [UIColor whiteColor];
        self.circleProgressView = [[LXCircleAnimationView alloc] initWithFrame:CGRectMake(50.f, 0, SCREEN_WIDTH - 100.f, SCREEN_WIDTH - 100.f)];
        self.circleProgressView.bgImage = [UIImage imageNamed:@"backgroundImage"];
        self.circleProgressView.percent = [FinishProejct floatValue] / [PrjectTotalCount floatValue];
        [cell.contentView addSubview:self.circleProgressView];

        return cell;
    }
    CredlitCell *cell = [CredlitCell selectedCell:tableView];
    cell.FinishProejct.text = FinishProejct;
    cell.MyProperty.text = MyProperty;
    cell.PrjectTotalCount.text = PrjectTotalCount;
    cell.ProjectReimburse.text = ProjectReimburse;
    cell.ProjectTotalMoney.text = ProjectTotalMoney;
    return cell;
}
- (void)setProjectView
{
    UIView *projcetView = [[UIView alloc] initWithFrame:CGRectMake(0, 120, ScreenWidth, 100)];
    projcetView.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:projcetView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onStareButtonClick {
    
    self.circleProgressView.percent = [FinishProejct floatValue] / [PrjectTotalCount floatValue];
}

@end

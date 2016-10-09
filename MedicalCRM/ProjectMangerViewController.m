//
//  ProjectMangerViewController.m
//  MedicalCRM
//
//  Created by admin on 16/7/13.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "ProjectMangerViewController.h"
#import "ProjectInfoController.h"
#import "ProjectMangerCell.h"
#import "MJRefresh.h"
#import "NetManger.h"
#import "GetprojectpagelistModel.h"
#import "ProjectBuildViewController.h"
#import "FiltrateView.h"
#import "SeachViewController.h"
@interface ProjectMangerViewController ()<UITableViewDataSource,UITableViewDelegate,FiltrateViewDelegate>
{
    NetManger *manger;
    int pag;
    
    UIScrollView *mainScrollView;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ProjectMangerViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (pag == 0)
    {
        pag = 15;
        manger = [NetManger shareInstance];
        manger.sType = @"";
        manger.keywork = @"";
        manger.sType2 = @"";
        manger.sType3 = @"-1";
        manger.PageSize = [NSString stringWithFormat:@"%d",pag];
        if ([self.sType isEqualToString:@"1"])
        {
            [manger loadData:RequestOfGetpublicprojectpagelist];
        }
        else if ([self.sType isEqualToString:@"2"])
        {
            manger.sType3 = @"5";
            [manger loadData:RequestOfgetprojectpagelist];
        }
        else
        {
            [manger loadData:RequestOfgetprojectpagelist];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDatas) name:@"getprojectpagelist" object:nil];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    [self setTableView];
    [self hearView];
    
}
- (void)reloadDatas
{
    [self.tableView reloadData];
    if (manger.getprojectpagelist.count == 0)
    {
        //初始化提示框；
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"暂无相关数据" preferredStyle: UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //点击按钮的响应事件；
        }]];
        
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }
}
#pragma mark -
- (void)setTableView
{
    // setScrollView
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, ScreenWidth, ScreenHeight - 49-44)];
    mainScrollView.contentSize = CGSizeMake(746, ScreenHeight - 49-44);
    [self.view addSubview:mainScrollView];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 746, ScreenHeight-49-44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
//        manger.sType = self.sType;
//        [manger loadData:RequestOfgetprojectpagelist];
        [self.tableView.mj_header endRefreshing];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        manger.sType = self.sType;
//        [manger loadData:RequestOfgetprojectpagelist];
//        manger = [NetManger shareInstance];
//        manger.sType = @"";
//        manger.keywork = @"";
//        manger.sType2 = @"";
//        manger.sType3 = @"";
        pag = pag +10;
        manger.sType2 = @"";
        manger.sType3 = @"-1";
        manger.PageSize = [NSString stringWithFormat:@"%d",pag];
        if ([self.sType isEqualToString:@"1"])
        {
            [manger loadData:RequestOfGetpublicprojectpagelist];
        }
        else if ([self.sType isEqualToString:@"2"])
        {
            manger.sType3 = @"5";
            [manger loadData:RequestOfgetprojectpagelist];
        }
        else
        {
            [manger loadData:RequestOfgetprojectpagelist];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDatas) name:@"getprojectpagelist" object:nil];
        [self.tableView.mj_footer endRefreshing];
    }];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setDateView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
     [self.tableView setBackgroundColor:RGB(239, 239, 244)];
    [mainScrollView addSubview:_tableView];
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
        [seachButton setTitle:[NSString stringWithFormat:@"搜索项目"]  forState:UIControlStateNormal];
        [seachButton addTarget:self action:@selector(pushSeachVC) forControlEvents:UIControlEventTouchDown];
        seachButton;
    });
    self.navigationItem.titleView = seachButton;
}
- (void)setDateView
{
    NSArray *titleArr = @[@"时间",@"类型"];
    NSArray *firstDataArr = @[@"不限",@"最近一年",@"最近季度",@"最近一个月",@"最近一周",@"今天"];
    NSArray *secondDataArr = @[@"申报项目",@"样机申请",@"招标参数准备",@"中标",@"合同",@"备货",@"发货",@"付款",@"完结",@"全部"];
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
    if ([dataArr[1] isEqualToString:@"申报项目"])
    {
        manger.sType3 = @"0";
    }
    if ([dataArr[1] isEqualToString:@"样机申请"])
    {
        manger.sType3 = @"1";
    }
    if ([dataArr[1] isEqualToString:@"招标参数准备"])
    {
        manger.sType3 = @"6";
    }
    if ([dataArr[1] isEqualToString:@"中标"])
    {
        manger.sType3 = @"7";
    }
    if ([dataArr[1] isEqualToString:@"合同"])
    {
        manger.sType3 = @"8";
    }
    if ([dataArr[1] isEqualToString:@"备货"])
    {
        manger.sType3 = @"2";
    }
    if ([dataArr[1] isEqualToString:@"发货"])
    {
        manger.sType3 = @"3";
    }
    if ([dataArr[1] isEqualToString:@"付款"])
    {
        manger.sType3 = @"4";
    }
    if ([dataArr[1] isEqualToString:@"完结"])
    {
        manger.sType3 = @"5";
    }
    if ([dataArr[1] isEqualToString:@"终止"])
    {
        manger.sType3 = @"9";
    }
    if ([dataArr[1] isEqualToString:@"全部"])
    {
        manger.sType3 = @"-1";
    }
    JCKLog(@"%@-%@",manger.sType,manger.sType3);
    manger.keywork = @"";
    if ([self.sType isEqualToString:@"1"])
    {
        [manger loadData:RequestOfGetpublicprojectpagelist];
    }
    else
    {
        [manger loadData:RequestOfgetprojectpagelist];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDatas) name:@"getprojectpagelist" object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return manger.getprojectpagelist.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectMangerCell *cell = [ProjectMangerCell selectedCell:tableView];
    if (indexPath.row != 0)
    {
        GetprojectpagelistModel *model = manger.getprojectpagelist[indexPath.row-1];
        cell.nameLab.text = model.ProjectName;
        cell.ProjectNo.text = model.ProjectNo;
        cell.timeLab.text = [model.CreateDate substringToIndex:16];
        cell.stateLab.text = model.StatusName;
        cell.custorLab.text = model.CustName;
        cell.successLab.text = model.SuccessRate;
        cell.priceLab.text = model.AcceptMoney;
//        JCKLog(@"%d",[model.SuccessRateNum floatValue]);
        float x = [model.SuccessRateNum floatValue];
        if ([model.StatusName isEqualToString:@"出货"])
        {
            cell.nameLab.backgroundColor = RGB(0,226,195);
            cell.ProjectNo.backgroundColor = RGB(0,226,195);
            cell.timeLab.backgroundColor = RGB(0,226,195);
            cell.stateLab.backgroundColor = RGB(0,226,195);
            cell.custorLab.backgroundColor = RGB(0,226,195);
            cell.stateLab.backgroundColor = RGB(0,226,195);
            cell.priceLab.backgroundColor = RGB(0,226,195);
            cell.successLab.backgroundColor = RGB(0,226,195);
        }

        else if ([model.StatusName isEqualToString:@"付款"])
        {
            cell.nameLab.backgroundColor = RGB(59,221,87);
            cell.ProjectNo.backgroundColor = RGB(59,221,87);
            cell.timeLab.backgroundColor = RGB(59,221,87);
            cell.stateLab.backgroundColor = RGB(59,221,87);
            cell.custorLab.backgroundColor = RGB(59,221,87);
            cell.stateLab.backgroundColor = RGB(59,221,87);
            cell.priceLab.backgroundColor = RGB(59,221,87);
            cell.successLab.backgroundColor = RGB(59,221,87);
        }
        else if ([model.StatusName isEqualToString:@"合同"])
        {
            cell.nameLab.backgroundColor = RGB(255,151,0);
            cell.ProjectNo.backgroundColor = RGB(255,151,0);
            cell.timeLab.backgroundColor = RGB(255,151,0);
            cell.stateLab.backgroundColor = RGB(255,151,0);
            cell.custorLab.backgroundColor = RGB(255,151,0);
            cell.stateLab.backgroundColor = RGB(255,151,0);
            cell.priceLab.backgroundColor = RGB(255,151,0);
            cell.successLab.backgroundColor = RGB(255,151,0);
        }
        else if ([model.StatusName isEqualToString:@"中标"])
        {
            cell.nameLab.backgroundColor = RGB(255,207,0);
            cell.ProjectNo.backgroundColor = RGB(255,207,0);
            cell.timeLab.backgroundColor = RGB(255,207,0);
            cell.stateLab.backgroundColor = RGB(255,207,00);
            cell.custorLab.backgroundColor = RGB(255,207,0);
            cell.stateLab.backgroundColor = RGB(255,207,0);
            cell.priceLab.backgroundColor = RGB(255,207,0);
            cell.successLab.backgroundColor = RGB(255,207,0);
        }
        if (x >= 0.8)
        {
            cell.successLab.backgroundColor = RGB(157,255,171);
        }
        else if (x >= 0.6 && x <= 0.8)
        {
            cell.successLab.backgroundColor = RGB(196,244,204);
        }
        //    static NSString *allCell = @"cell";
        //    UITableViewCell *cell = nil;
        //    if (!cell) {
        //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:allCell];
        //        cell.selectionStyle = UITableViewCellAccessoryNone;
        //    }
        //    cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)",model.CustName,model.ProjectName];
        //    cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        cell.tag = [model.ID integerValue];
    }

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 31;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        ProjectInfoController *sub = [[ProjectInfoController alloc] init];
        sub.title = @"项目详细";
        if ([self.sType isEqualToString:@"0"]) {
            sub.isPublic = NO;
        }
        else
        {
            sub.isPublic = YES;
        }
        sub.ID = cell.tag;
        
        [self.navigationController pushViewController:sub animated:YES];
    }


}
#pragma mark - pushBulidCtr
- (void)pushBulidCtr
{
    ProjectBuildViewController *sub = [[ProjectBuildViewController alloc] init];
    sub.title = @"项目申报";
    [self.navigationController pushViewController:sub animated:YES];

}
- (void)pushSeachVC
{
    SeachViewController *sub = [[SeachViewController alloc] init];
    sub.state = self.sType;
    [self.navigationController pushViewController:sub animated:YES];
    
}
@end

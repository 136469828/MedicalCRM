//
//  TheNewAuditListViewController.m
//  MedicalCRM
//
//  Created by admin on 16/8/22.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "TheNewAuditListViewController.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"
#import "AuditClassViewController.h"
#import "AuditViewController.h"
#import "NetManger.h"
#import "MJExtension.h"
#import "GetsellsamplepagelistforcheckModel.h"
#import "AreaViewCell.h"
#import "FiltrateView.h"

#import "CostAuditingListModel.h"
#import "CostAuditingListCell.h"

#import "StopckUpListModel.h"
#import "StockUpListCell.h"
#import "StockUpInfoViewController.h"
@interface TheNewAuditListViewController ()<UITableViewDataSource,UITableViewDelegate,FiltrateViewDelegate>
{
    NetManger *manger;
    UITextField *tf;
    NSArray *titles;
    int state;
}
@property (nonatomic, strong) NSMutableArray *m_datas;
@property (nonatomic, strong) NSMutableArray *m_datas2;
@property (nonatomic, strong) NSMutableArray *m_datas3;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TheNewAuditListViewController
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
    titles = @[@"样机审核",@"费用审核",@"备货审核"];
    manger = [NetManger shareInstance];
    manger.sType = @"1";
    [manger loadData:GetsellsamplepagelistforcheckGetsellsample];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodatas) name:@"getsellsamplepagelistforcheck" object:nil];
    manger.sType = @"1";
    [manger loadData:RequestOfGetfeeapplypagelistforcheck];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodatas) name:@"getfeeapplypagelistforcheck" object:nil];
    manger.sType = @"1";
    [manger loadData:RequestOfGetsellorderpagelistforcheck];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodatas) name:@"getsellorderpagelistforcheck" object:nil];
    
}
- (void)reloaddatas3
{
    for (NSDictionary *dic in manger.sellorderpagelistforcheck)
    {
        StopckUpListModel *model = [StopckUpListModel mj_objectWithKeyValues:dic];
        if (!_m_datas3) {
            _m_datas3 = [NSMutableArray array];
        }
        [_m_datas3 addObject:model];
    }
    [self setTableView];
}
- (void)relodatas2
{
    JCKLog(@"%ld",manger.getfeeapplypagelistforchecks.count);
    for (NSDictionary *dic in manger.getfeeapplypagelistforchecks) {
        CostAuditingListModel *model = [CostAuditingListModel mj_objectWithKeyValues:dic];
        if (_m_datas2.count == 0)
        {
            _m_datas2 = [[NSMutableArray alloc] initWithCapacity:0];
        }
        [_m_datas2 addObject:model];
    }
    //    JCKLog(@"%ld",_m_datas.count);
    [self setTableView];
}
- (void)relodatas
{
    JCKLog(@"%ld",manger.getsellsamplepagelistforchecks.count);
    [_m_datas3 removeAllObjects];
    [_m_datas2 removeAllObjects];
    [_m_datas removeAllObjects];
    if (manger.getsellsamplepagelistforchecks.count != 0)
    {
        for (NSDictionary *dic in manger.getsellsamplepagelistforchecks) {
            GetsellsamplepagelistforcheckModel *model = [GetsellsamplepagelistforcheckModel mj_objectWithKeyValues:dic];
            if (_m_datas.count == 0)
            {
                _m_datas = [[NSMutableArray alloc] initWithCapacity:0];
            }
            [_m_datas addObject:model];
        }
    }

    if (manger.sellorderpagelistforcheck.count != 0)
    {
        for (NSDictionary *dic in manger.sellorderpagelistforcheck)
        {
            StopckUpListModel *model = [StopckUpListModel mj_objectWithKeyValues:dic];
            if (!_m_datas3) {
                _m_datas3 = [NSMutableArray array];
            }
            [_m_datas3 addObject:model];
        }
    }

    if (manger.getfeeapplypagelistforchecks.count != 0) {
        for (NSDictionary *dic in manger.getfeeapplypagelistforchecks) {
            CostAuditingListModel *model = [CostAuditingListModel mj_objectWithKeyValues:dic];
            if (_m_datas2.count == 0)
            {
                _m_datas2 = [[NSMutableArray alloc] initWithCapacity:0];
            }
            [_m_datas2 addObject:model];
        }
    }
    state ++;
    JCKLog(@"state = %d",state);
    if (state == 3)
    {
        [self setTableView];
    }
    
    
}
#pragma mark -
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, ScreenWidth, ScreenHeight - 69-44) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.tableHeaderView = [self setDateView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
    [SVProgressHUD dismiss];
    [self setDateView];
}
- (void )setDateView
{
    NSArray *titleArr = @[@"时间",@"状态"];
    NSArray *firstDataArr = @[@"不限",@"最近一年",@"最近季度",@"最近一个月",@"最近一周",@"今天"];
    NSArray *secondDataArr = @[@"待审批",@"审批不通过",@"审批通过"];
    NSArray *dataArr = @[firstDataArr,secondDataArr];
    
    FiltrateView *filtreteView = [[FiltrateView alloc]initWithCount:2 withTitleArr:titleArr withDataArr:dataArr];
    filtreteView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    filtreteView.delegate = self;
    [self.view addSubview:filtreteView];
    state = 0;
//    return filtreteView;
}
//返回所点击内容
- (void)completionArr:(NSArray *)dataArr
{
    JCKLog(@"%@ %@",dataArr[0],dataArr[1]);
    if ([dataArr[0] isEqualToString:@"最近一年"])
    {
//        manger.sType1 = @"5";
    }
    if ([dataArr[0] isEqualToString:@"最近季度"])
    {
//        manger.sType1 = @"4";
    }
    if ([dataArr[0] isEqualToString:@"最近一个月"])
    {
//        manger.sType1 = @"3";
    }
    if ([dataArr[0] isEqualToString:@"最近一周"])
    {
//        manger.sType1 = @"2";
    }
    if ([dataArr[0] isEqualToString:@"今天"])
    {
//        manger.sType1 = @"1";
    }
    if ([dataArr[1] isEqualToString:@"待审批"])
    {
        manger.sType = @"1";
    }
    if ([dataArr[1] isEqualToString:@"审批通过"])
    {
        manger.sType = @"0";
    }
    if ([dataArr[1] isEqualToString:@"审批不通过"])
    {
        manger.sType = @"2";
    }
    [_m_datas3 removeAllObjects];
    [_m_datas2 removeAllObjects];
    [_m_datas removeAllObjects];
    JCKLog(@"%@-%@",manger.sType,manger.sType3);
    manger.keywork = @"";
    [manger loadData:GetsellsamplepagelistforcheckGetsellsample];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodatas) name:@"getsellsamplepagelistforcheck" object:nil];
    [manger loadData:RequestOfGetfeeapplypagelistforcheck];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodatas) name:@"getfeeapplypagelistforcheck" object:nil];
    [manger loadData:RequestOfGetsellorderpagelistforcheck];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodatas) name:@"getsellorderpagelistforcheck" object:nil];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section; // 返回组名
//{
//    if (tableView == _tableView)
//    {
//        return titles[section];
//    }
//    else
//    {
//        return nil;
//    }
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView // 一个表视图里面有多少组
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        if (_m_datas.count == 0)
        {
            return 0;
        }
        else
        {
            return _m_datas.count;
        }

    }
   else if (section == 1)
   {
       if (_m_datas2.count == 0)
       {
           return 0;
       }
       else
       {
           return _m_datas2.count;
       }
       
       
   }
    
   else if (section == 2)
   {
       if (_m_datas3.count == 0)
       {
           return 0;
       }
       else
       {
           return _m_datas3.count;
       }

   }
    if (_m_datas.count == 0 && _m_datas2.count == 0 && _m_datas3.count == 0 && state == 3)
    {
        //初始化提示框；
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"暂无需要您审批的申请" preferredStyle: UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //点击按钮的响应事件；
        }]];
        
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
        return 0;
    }
    return 0;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section // 返回组的头宽
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section// 返回组的尾宽
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (_m_datas.count == 0)
        {
            static NSString *allCell = @"cell";
            UITableViewCell *cell = nil;
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:allCell];
                cell.selectionStyle = UITableViewCellAccessoryNone;
            }
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.textLabel.text = @"暂无您需要审核的样机申请";
            return cell;
        }
        else
        {
            GetsellsamplepagelistforcheckModel *model = _m_datas[indexPath.row];
            AreaViewCell *cell = [AreaViewCell selectedCell:tableView];
            return cell;
        }

    }
    if (indexPath.section == 1)
    {
        if (_m_datas2.count == 0)
        {
            static NSString *allCell = @"cell";
            UITableViewCell *cell = nil;
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:allCell];
                cell.selectionStyle = UITableViewCellAccessoryNone;
            }
            cell.textLabel.text = @"暂无您需要审核的费用申请";
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            return cell;
        }
        else
        {
            CostAuditingListModel *model = _m_datas2[indexPath.row];
            CostAuditingListCell *cell2 = [CostAuditingListCell selectedCell:tableView];
//            if (!model.ProjectName)
//            {
//                cell2.titleLab.text = model.Title;
//            }
//            else
//            {
//                cell2.titleLab.text = model.ProjectName;//model.Title;
//            }
//             cell2.titleLab.text = model.Title;
            cell2.priceLab.text = model.TotalAmount;
            cell2.projectLab.text = model.ProjectName;
            cell2.timeLab.text=model.AriseDate;
            cell2.resonLab.text =model.Reason;
            cell2.nameLab.text =model.CreatorName;
//            cell2.FlowStatusName.text = model.FlowStatusName;
            cell2.tag = [model.ID integerValue];
            return cell2;
        }
    }
    if (_m_datas3.count == 0)
    {
        static NSString *allCell = @"cell";
        UITableViewCell *cell = nil;
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:allCell];
            cell.selectionStyle = UITableViewCellAccessoryNone;
        }
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.text = @"暂无您需要审核的备货申请";
        return cell;
    }
    else
    {
        StockUpListCell *cell3 = [StockUpListCell selectedCell:tableView];
//        StopckUpListModel *model = _m_datas3[indexPath.row];
//        cell3.timeLab.text = model.CreatorName;//model.Title;
//        cell3.countLab.text = model.CountTotal;
//        cell3.cusLab.text = model.CustName;
//        cell3.timeLab.text = [model.CreateDate substringToIndex:16];
//        cell3.stateLab.text = model.CheckStatusName;
//        cell3.creName.text = model.CreatorName;
//        cell3.tag = [model.ID integerValue];
        return cell3;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (_m_datas.count == 0)
        {
            
        }
        else
        {
            GetsellsamplepagelistforcheckModel *models = _m_datas[indexPath.row];
            AuditViewController *sub = [[AuditViewController alloc] init];
            sub.title = @"样机审批详情";
            sub.model = models;
            sub.ID = models.ApplyNo;
            [self.navigationController pushViewController:sub animated:YES];
        }


    }
    else if (indexPath.section == 1)
    {
        if (_m_datas2.count == 0)
        {
            
        }
        else
        {
            CostAuditingListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            CostAuditingListModel *models = _m_datas2[indexPath.row];
            AuditViewController *sub = [[AuditViewController alloc] init];
            sub.title = @"审核费用报销详情";
            sub.model2 = models;
            sub.stye = 1;
            sub.ID = [NSString stringWithFormat:@"%ld",cell.tag];
            [self.navigationController pushViewController:sub animated:YES];
        }
    }
    else if (indexPath.section == 2)
    {
        if (_m_datas3.count == 0)
        {
            
        }
        else
        {
            StockUpListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            StockUpInfoViewController *sub = [[StockUpInfoViewController alloc] init];
            sub.title = @"备货审批详情";
            sub.ID = [NSString stringWithFormat:@"%ld",cell.tag];
            [self.navigationController pushViewController:sub animated:YES];
        }
    }

    
}

@end

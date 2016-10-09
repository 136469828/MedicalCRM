//
//  SigninSelectHospitalViewController.m
//  MedicalCRM
//
//  Created by admin on 16/9/5.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "SigninSelectHospitalViewController.h"
#import "NetManger.h"
#import "CustpagelistModel.h"
#import "CustlinkmanlistViewController.h"
#import "CustinfosaveViewController.h"
#import "MJRefresh.h"
#import "KeyboardToolBar.h"
#import "ProjectInfoModel.h"
#import "ProjectBuildViewController.h"
#import "SigninSelectProjectViewController.h"
#import "FuntionObj.h"
#import "MJExtension.h"
@interface SigninSelectHospitalViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchControllerDelegate>
{
    NetManger *manger;
    NSMutableArray *data;
    NSArray *filterData;
    UITextField *seachTextField;
    NSInteger pag;
    NSMutableArray *items;
    
    int *indexPaths;
    NSArray *linkMandatas;

}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SigninSelectHospitalViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    manger = [NetManger shareInstance];
//    manger.CustNo = @"";
//    manger.CustLinkManID = @"";
//    manger.keywork = @"";
//    pag = 15;
//    manger.PageSize =[NSString stringWithFormat:@"%ld",pag];
//    [manger loadData:RequestOfGetminecustpagelist];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloDatas) name:@"getminecustpagelist" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTableView];
}
- (void)reloDatas
{
    [data removeAllObjects];
    for (int i = 0; i<manger.getminecustpagelist.count; i++)
    {
        CustpagelistModel *model = manger.getminecustpagelist[i];
        if (!data) {
            data = [NSMutableArray array];
        }
        for (NSDictionary *dic in model.ProjectsProject)
        {
            JCKLog(@"%@",dic[@"ProjectName"]);
        }
        [data addObject:model.CustName];
    }

    if (pag > 0)
    {
        [self.tableView reloadData];

    }
    else
    {
        [self.tableView reloadData];
    }
    
}
#pragma mark -
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-56) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //iOS 8开始的自适应高度，可以不需要实现定义高度的方法
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self reloDatas];
        [_tableView.mj_header endRefreshing];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        pag = pag + 5;
        manger.PageSize = [NSString stringWithFormat:@"%ld",pag];
        [manger loadData:RequestOfGetminecustpagelist];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloDatas) name:@"getminecustpagelist" object:nil];
        [_tableView.mj_footer endRefreshing];
    }];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
    [self hearView];
}
#pragma mark - tableView头视图
- (void)hearView{
    
    UIView *hearView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    //    hearView.backgroundColor = [UIColor redColor];
    seachTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 1, SCREEN_WIDTH - 80, 38)];
    seachTextField.layer.borderColor = [UIColor lightGrayColor].CGColor; // set color as you want.
    seachTextField.layer.borderWidth = 1.0; // set borderWidth as you want.
    seachTextField.layer.cornerRadius=8.0f;
    seachTextField.layer.masksToBounds=YES;
    seachTextField.font = [UIFont systemFontOfSize:13];
    seachTextField.backgroundColor = [UIColor whiteColor];
    seachTextField.placeholder = @"请输入关键字";
    [KeyboardToolBar registerKeyboardToolBar:seachTextField];
    [hearView addSubview:seachTextField];
    
    UIButton *seachBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [seachBtn setTitle:@"搜索" forState:UIControlStateNormal];
    seachBtn.frame = CGRectMake(SCREEN_WIDTH - 60, 1, 50, 38);
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
    return data.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section // 返回组的头宽
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *allCell = @"cell";
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:allCell];
        cell.selectionStyle = UITableViewCellAccessoryNone;
    }
    CustpagelistModel *model = manger.getminecustpagelist[indexPath.row];
    if (tableView == self.tableView)
    {
        cell.textLabel.text = data[indexPath.row];
    }else{
        cell.textLabel.text = filterData[indexPath.row];
    }
    cell.tag = [model.ID integerValue];
    NSString *ProjectName;
    for (NSDictionary *dic in model.ProjectsProject)
    {
        ProjectName = dic[@"ProjectName"];
        break;
    }
    if (ProjectName.length != 0)
    {
        cell.tag = [model.ID integerValue];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ 等%ld个项目",ProjectName,model.ProjectsProject.count];
    }
//    else
//    {
//        cell.detailTextLabel.textColor = [UIColor orangeColor];
//        cell.detailTextLabel.text = @"该医院暂无合作项目,请点击申报";
//    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    CustpagelistModel *custpagelistModel = manger.getminecustpagelist[indexPath.row];
    if (custpagelistModel.ProjectsProject.count == 0) // 没有项目
    {
        if (custpagelistModel.ProjectsLinMans.count == 0) // 没有联系人
        {
             linkMandatas = @[@"",@"",@"",@"",@"",@"",@""];
            self.block(custpagelistModel.CustNo, // ProjectNo
                       @"", // ProjectName
                       custpagelistModel.CustName, // CompanyName
                       @"", // Department
                       @"", // StatusName
                       @"", // successRate
                       @"", // ProjcetId
                       linkMandatas, // linkMandatas
                       [NSString stringWithFormat:@"%ld",cell.tag], // custID
                       @"",// ProductName
                       @""); // ProductCount
        }
        else // 有联系人没有项目
        {
            for (NSDictionary *dic in custpagelistModel.ProjectsLinMans)
            {
                NSString *Position;
                if ([FuntionObj isNullDic:dic Key:@"Position"])
                {
                    Position = dic[@"Position"];
                }
                else
                {
                    Position = @"无";
                }
                linkMandatas = @[@"",dic[@"Department"],Position,dic[@"LinkManName"],dic[@"WorkTel"],@"",dic[@"ID"]];

                self.block(custpagelistModel.CustNo, // ProjectNo
                           @"", // ProjectName
                           custpagelistModel.CustName, // CompanyName
                           @"", // Department
                           @"", // StatusName
                           @"", // successRate
                           @"", // ProjcetId
                           linkMandatas, // linkMandatas
                           [NSString stringWithFormat:@"%ld",cell.tag], // custID
                           @"",// ProductName
                           @""); // ProductCount

                break;
            }
           
        }

    }
    else //  已有项目
    {
        /* NSString *ProjectNo,
         NSString *ProjectName,
         NSString *CompanyName,
         NSString *Department,
         NSString *successRate,
         NSString *ProjcetId,
         NSArray *linkMandatas,
         NSString *custID,
         NSString *ProductName,
         NSString *ProductCount
         */
        NSString *ProjectNo;
        NSString *ProjectName;
        NSString *CompanyName;
        NSString *Department;
        NSString *successRate;
        NSString *ProjcetId;
        NSString *custID;
        NSString *ProductName;
        NSString *ProductCount;
        NSString *StatusName;
        NSString *ProductID;
        for (NSDictionary *dic in custpagelistModel.ProjectsProject)
        {
            ProjectName = dic[@"ProjectName"];
            ProjectNo = dic[@"ProjectNo"];
            CompanyName = custpagelistModel.CustName;
            Department = dic[@"DepartmentName"];
            successRate = dic[@"SuccessRate"];
            ProjcetId = dic[@"ID"];
            custID = dic[@""];
            StatusName = dic[@"StatusName"];
            manger.ID = ProjcetId;
            [manger loadData:RequestOfGetproject];
//            for (NSDictionary *dic2 in dic[@"ProductList"]) // 有样机
//            {
//                ProductName = dic2[@"ProductName"];
//                ProductID  = dic2[@"ProductID"];
//                ProductCount = [NSString stringWithFormat:@"%@",dic2[@"ProductCount"]]; //[NSString stringWithFormat:@"%@",dic2[@"ProductCount"]];
//                break;
//            }
            if (custpagelistModel.ProjectsLinMans.count != 0 ) // 有项目有联系人
            {
                for (NSDictionary *dic in custpagelistModel.ProjectsLinMans)
                {
                    NSString *Position;
                    if ([FuntionObj isNullDic:dic Key:@"Position"])
                    {
                        Position = dic[@"Position"];
                    }
                    else
                    {
                        Position = @"无";
                    }
                    linkMandatas = @[@"",dic[@"Department"],Position,dic[@"LinkManName"],dic[@"WorkTel"],@"",dic[@"ID"]];
                    
                    self.block(custpagelistModel.CustNo, // ProjectNo
                               ProjectName, // ProjectName
                               custpagelistModel.CustName, // CompanyName
                               Department, // Department
                               StatusName,
                               successRate, // successRate
                               ProjcetId, // ProjcetId
                               linkMandatas, // linkMandatas
                               [NSString stringWithFormat:@"%ld",cell.tag], // custID
                               ProductName,// ProductName
                               ProductCount); // ProductCount
                    
                    break;
                    
                }

            }
            else // 有项目，没联系人
            {
                linkMandatas = @[@"",@"",@"",@"",@"",@"",@""];
                self.block(custpagelistModel.CustNo, // ProjectNo
                           ProjectName, // ProjectName
                           custpagelistModel.CustName, // CompanyName
                           Department, // Department
                           StatusName,
                           successRate, // successRate
                           ProjcetId, // ProjcetId
                           linkMandatas, // linkMandatas
                           [NSString stringWithFormat:@"%ld",cell.tag], // custID
                           ProductName,// ProductName
                           ProductCount); // ProductCount
            }
            break;
            
            
        }

    }
    [self.navigationController popViewControllerAnimated:YES];

}
//- (void)receiveData
//{
//    JCKLog(@"%@",manger.constructionDetails);
//    for (NSDictionary *dic in manger.constructionDetails)
//    {
//        ProjectInfoModel *model = [ProjectInfoModel mj_objectWithKeyValues:dic];
//        JCKLog(@"PlanDate%@ ProcessId%@ ProcessName%@",model.PlanDate,model.ProcessId,model.ProcessName);
//    }
//}
- (void)seachOnSeach
{
    manger = [NetManger shareInstance];
    manger.keywork = seachTextField.text;
    pag = 10;
    manger.sType = self.sType;
    manger.PageSize = [NSString stringWithFormat:@"%d",pag];
    [manger loadData:RequestOfGetminecustpagelist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloDatas) name:@"getminecustpagelist" object:nil];
}
@end

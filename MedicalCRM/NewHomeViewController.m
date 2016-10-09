//
//  NewHomeViewController.m
//  MedicalCRM
//
//  Created by admin on 16/8/8.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "NewHomeViewController.h"
#import "NetManger.h"
#import "NewHomeCell.h"
#import "MJRefresh.h"

#import "SigninViewController.h" // 签到
#import "ProjectMangerViewController.h" // 项目管理
#import "MyPayViewController.h" // 费用
#import "MyDemoChiController.h" // 样机
#import "WebModel.h"
#import "WebViewController.h"
#import "MyPerformanceViewController.h" // 业绩
#import "AssessmentViewController.h" // 我的价值
#import "CreditViewController.h" // 诚信度
#import "LifeNavigationViewController.h" // 人生导航
#import "MyPartnerViewController.h"
#import "AuditClassViewController.h"
#import "ExhibitionListViewController.h"
#import "ProjectBuildViewController.h"
#import "DemoMachineSaveController.h"
#import "TheNewCustomerListController.h"
#import "AddFriendListViewController.h"
#import "CLDropDownMenu.h"
#import "SubEnterpriseCultureViewController.h"
#import "ImportantItemsListViewController.h"
#import "TheNewAuditListViewController.h"
#import "StockUpListViewController.h"
#import "TheNewSigninViewController.h"
@interface NewHomeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NetManger *manger;
    NSArray *titles;
    NSArray *imgs;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation NewHomeViewController
// 销毁通知中心
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)reloadDatas
{
    JCKLog(@"%@",manger.NoCheckTotalCount);
    [_tableView reloadData];
//    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:1];
//    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    manger = [NetManger shareInstance];
    [manger loadData:RequestOfGetnochecktotal];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDatas) name:@"getnochecktotal" object:nil];
    self.title = @"工作";
    titles = @[@[@"我的人生导航"],
               @[@"拜访医院",@"拜访合作伙伴",@"我的项目",@"我的样机",@"审批管理"],
               @[@"我的成交",@"我的成本"],
               @[@"我的诚信度",@"我的勤奋度",@"我对公司的热爱",@"我的专业水平",@"我的一伙人"],
               @[@"部门重要制度",@"部门重要事项",@"部门职责",@"部门指标",@"部门流程",@"专业知识"],
               @[@"展会管理",@"公海池"]
               ];
    imgs = @[@[@"我的人生导航"],
             @[@"我的拜访",@"合伙人拜访",@"我的项目",@"我的样机",@"我的审批"],
             @[@"我的成交",@"我的成本"],
             @[@"我的诚信度",@"我的勤奋度",@"我对公司的热爱",@"我的专业水平",@"一伙人"],
             @[@"部门重要制度",@"部门重要事项",@"部门职责",@"部门指标",@"部门流程",@"专业知识"],
             @[@"展会管理",@"公海池"]
             ];
    [self setTableView];
    UIButton *settingBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingBtn2 addTarget:self action:@selector(setDownMenu:) forControlEvents:UIControlEventTouchUpInside];
    [settingBtn2 setImage:[UIImage imageNamed:@"tianjiaIcon"] forState:UIControlStateNormal];
    [settingBtn2 sizeToFit];
    settingBtn2.frame = CGRectMake(0, 0, 25, 25);
    UIBarButtonItem *settingBtnItem2 = [[UIBarButtonItem alloc] initWithCustomView:settingBtn2];
    self.navigationItem.rightBarButtonItems  = @[settingBtnItem2];
}
- (void)setDownMenu:(UIButton *)sender
{
//    AddFriendListViewController *sub = [[AddFriendListViewController alloc] init];
//    sub.title = @"选择好友";
//    sub.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:sub animated:YES];

    CLDropDownMenu *dropMenu = [[CLDropDownMenu alloc] initWithBtnPressedByWindowFrame:CGRectMake(ScreenWidth-110, -50, 100, 40) Pressed:^(NSInteger index) {
        
        NSLog(@"点击了第%ld个btn",index);
        switch (index) {
            case 0:
            {
                SigninViewController *sub = [[SigninViewController alloc] init];
                sub.title = @"医院拜访";
                sub.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:sub animated:YES];
            }
                break;
            case 1:
            {
                AddFriendListViewController *sub = [[AddFriendListViewController alloc] init];
                sub.title = @"选择好友";
                sub.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:sub animated:YES];
            }
                break;
            case 2:
            {
                ProjectBuildViewController *sub = [[ProjectBuildViewController alloc] init];
                sub.title = @"项目申报";
                sub.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:sub animated:YES];
            }
                break;
//            case 3:
//            {
//
//                DemoMachineSaveController *sub = [[DemoMachineSaveController alloc] init];
//                sub.title = @"样机申请";
//                sub.ID = @(0);
//                sub.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:sub animated:YES];
//
//            }
//                break;
                
            default:
                break;
        }
        sender.selected = !sender.selected;
        
    }];
    
    dropMenu.direction = CLDirectionTypeBottom;
    dropMenu.titleList = @[@"医院拜访",@"创建聊天",@"申报项目"];
    
    if (!sender.selected)
    {
        [self.view addSubview:dropMenu];
        sender.selected = !sender.selected;
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"closeMenu" object:nil];
        sender.selected = !sender.selected;
    }
}
#pragma mark -
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 69) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //iOS 8开始的自适应高度，可以不需要实现定义高度的方法
//    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = 50;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [_tableView.mj_header endRefreshing];
    }];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [_tableView.footer endRefreshing];
    }];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
//    [self setADView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITableViewDataSource
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section   // 返回一个UIView作为头视图
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(38, 5, ScreenWidth, 20)];
    switch (section) {
        case 0:
        {
            lb.text = @"我的人生导航";
        }
            break;
        case 1:
        {
            lb.text = @"我的奋斗历程";
        }
            break;
        case 2:
        {
            lb.text = @"我的价值";
        }
            break;
        case 3:
        {
            lb.text = @"我的行为表现";
        }
            break;
        case 4:
        {
            lb.text = @"部门事项";
        }
            break;
        case 5:
        {
            lb.text = @"其他";
        }
            break;
            
        default:
            break;
    }
    lb.font = [UIFont systemFontOfSize:14];
    lb.textColor = RGB(157, 157, 157);
    [bgView addSubview:lb];
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
    imgV.image = [UIImage imageNamed:@"Artboard 26"];
    [bgView addSubview:imgV];
    return bgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section // 返回组的头宽
{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section// 返回组的尾宽
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return 4;
    }
    if (section == 2) {
        return 2;
    }
    else if (section == 3)
    {
        return 5;
    }
    else if (section == 4)
    {
        return 6;
    }
    return 2;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; // 一个表视图里面有多少组
{
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewHomeCell *cell = [NewHomeCell selectedCell:tableView];
    cell.titleLab.text = [NSString stringWithFormat:@"%@",titles[indexPath.section][indexPath.row]];
    cell.imgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imgs[indexPath.section][indexPath.row]]];
    if (indexPath.section == 1 && indexPath.row == 4)
    {
        // 未读标记
        UILabel *readLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-40,44/2-10, 20, 20)];
        readLab.layer.cornerRadius = 10;
        readLab.layer.masksToBounds = YES;
        readLab.text = [NSString stringWithFormat:@"%@",manger.NoCheckTotalCount];
        if ([readLab.text isEqualToString:@"0"])
        {
            readLab.hidden = YES;
        }
        readLab.textAlignment = NSTextAlignmentCenter;
        readLab.font = [UIFont systemFontOfSize:10];
        readLab.textColor = [UIColor whiteColor];
        readLab.backgroundColor = [UIColor redColor];
        [cell.contentView addSubview:readLab];

    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   /*
    titles = @[@[@"我的人生导航"],
    @[@"我的拜访",@"我的样机",@"审批管理"],
    @[@"我的项目",@"我的成交",@"我的成本"],
    @[@"我的诚信度",@"我的勤奋度",@"我对公司的热爱",@"我的专业水平"],
    @[@"部门重要制度",@"部门重要事项",@"部门指标",@"部门流程",@"专业知识"],
    @[@"展会管理",@"公海池"]
    */
    switch (indexPath.section) {
        case 0:
        {
            NSString *url = [NSString stringWithFormat:@"http://beaconapi.meidp.com/Mobi/Office/EmployeeNav?UserId=%@",[NetManger shareInstance].userID];
            WebModel *model = [[WebModel alloc] initWithUrl:url];
            WebViewController *SVC = [[WebViewController alloc] init];
            SVC.title = @"人生导航";
            SVC.hidesBottomBarWhenPushed = YES;
            [SVC setModel:model];
            [self.navigationController pushViewController:SVC animated:YES];
        }
            break;
        case 1:
        {
            if (indexPath.row == 0)
            {
                SigninViewController *sub = [[SigninViewController alloc] init];
                sub.title = @"拜访医院";
                [self.navigationController pushViewController:sub animated:YES];
            }
            else if (indexPath.row == 1)
            {
                TheNewSigninViewController *sub = [[TheNewSigninViewController alloc] init];
                sub.title = @"拜访合作伙伴";
                [self.navigationController pushViewController:sub animated:YES];
            }
            else if (indexPath.row == 2)
            {
                ProjectMangerViewController *sub = [[ProjectMangerViewController alloc] init];
                sub.title = @"我的项目";
                sub.sType = @"0";
                sub.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:sub animated:YES];
            }
            else if (indexPath.row == 3)
            {
                MyDemoChiController *sub = [[MyDemoChiController alloc] init];
                sub.title = @"我的样机";
                sub.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:sub animated:YES];
//                ProjectMangerViewController *sub = [[ProjectMangerViewController alloc] init];
//                sub.title = @"项目管理";
//                sub.sType = @"0";
//                sub.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:sub animated:YES];
            }
            else if (indexPath.row == 4)
            {
                TheNewAuditListViewController *sub = [[TheNewAuditListViewController alloc] init];
                sub.title = @"审批列表";
                sub.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:sub animated:YES];
            }

        }
            break;
        case 2:
        {

            if (indexPath.row == 0)
            {
//                StockUpListViewController*sub = [[StockUpListViewController alloc] init];
//                sub.title = @"备货管理";
//                sub.hidesBottomBarWhenPushed = YES;
//                sub.isAduit = 2;
//                [self.navigationController pushViewController:sub animated:YES];
                ProjectMangerViewController *sub = [[ProjectMangerViewController alloc] init];
                sub.title = @"我的成交";
                sub.sType = @"2";
                sub.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:sub animated:YES];
            }
            else if (indexPath.row == 1)
            {
                MyPayViewController *sub = [[MyPayViewController alloc] init];
                sub.title = @"我的成本";
                sub.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:sub animated:YES];
            }

        }
            break;
        case 3:
        {
            if (indexPath.row == 0) //
            {
                CreditViewController *sub = [[CreditViewController alloc] init];
                sub.title = @"我的诚信度";
                sub.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:sub animated:YES];
            }
            else if (indexPath.row == 4)
            {
                MyPartnerViewController *sub = [[MyPartnerViewController alloc] init];
                sub.title = @"我的一伙人";
                [self.navigationController pushViewController:sub animated:YES];
            }
        }
            break;
        case 4:
        {
            if (indexPath.row == 0) //
            {
                NSString *url = [NSString stringWithFormat:@"http://beaconapi.meidp.com/mobi/office/deptinfo?UserId=%@&sType=4",[NetManger shareInstance].userID];
                WebModel *model = [[WebModel alloc] initWithUrl:url];
                WebViewController *SVC = [[WebViewController alloc] init];
                SVC.title = @"部门重要制度";
                SVC.hidesBottomBarWhenPushed = YES;
                [SVC setModel:model];
                [self.navigationController pushViewController:SVC animated:YES];

            }
            else if (indexPath.row == 1)
            {
                ImportantItemsListViewController *sub = [[ImportantItemsListViewController alloc] init];
                sub.title = @"重要事项";
                [self.navigationController pushViewController:sub animated:YES];
            }
            else if (indexPath.row == 2)
            {
                NSString *url = [NSString stringWithFormat:@"http://beaconapi.meidp.com/Mobi/Office/DeptInfo?UserId=%@&sType=1",[NetManger shareInstance].userID];
                WebModel *model = [[WebModel alloc] initWithUrl:url];
                WebViewController *SVC = [[WebViewController alloc] init];
                SVC.title = @"部门职责";
                SVC.hidesBottomBarWhenPushed = YES;
                [SVC setModel:model];
                [self.navigationController pushViewController:SVC animated:YES];
            }
            else if (indexPath.row == 3)
            {
                NSString *url = [NSString stringWithFormat:@"http://beaconapi.meidp.com/Mobi/Office/DeptInfo?UserId=%@&sType=2",[NetManger shareInstance].userID];
                WebModel *model = [[WebModel alloc] initWithUrl:url];
                WebViewController *SVC = [[WebViewController alloc] init];
                SVC.title = @"部门指标";
                SVC.hidesBottomBarWhenPushed = YES;
                [SVC setModel:model];
                [self.navigationController pushViewController:SVC animated:YES];
            }
            else if (indexPath.row == 4)
            {
                NSString *url = [NSString stringWithFormat:@"http://beaconapi.meidp.com/Mobi/Office/DeptInfo?UserId=%@&sType=3",[NetManger shareInstance].userID];
                WebModel *model = [[WebModel alloc] initWithUrl:url];
                WebViewController *SVC = [[WebViewController alloc] init];
                SVC.title = @"部门流程";
                SVC.hidesBottomBarWhenPushed = YES;
                [SVC setModel:model];
                [self.navigationController pushViewController:SVC animated:YES];
            }
            else if (indexPath.row == 5)
            {
                SubEnterpriseCultureViewController *sub = [[SubEnterpriseCultureViewController alloc] init];
                sub.title = @"专业知识";
                sub.ID = 7;
                [self.navigationController pushViewController:sub animated:YES];
            }
            
        }
            break;
        case 5:
        {
            if (indexPath.row == 0)
            {
                ExhibitionListViewController *sub = [[ExhibitionListViewController alloc] init];
                sub.title = @"展会管理";
                sub.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:sub animated:YES];
                
            }
            else if (indexPath.row == 1)
            {
                ProjectMangerViewController  *sub = [[ProjectMangerViewController alloc] init];
                sub.title = @"项目公海池";
                sub.sType = @"1";
                sub.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:sub animated:YES];
                
            }
        }
            break;
        default:
            break;
    }
}
@end

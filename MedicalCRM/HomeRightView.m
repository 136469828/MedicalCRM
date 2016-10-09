//
//  HomeRightView.m
//  MedicalCRM
//
//  Created by admin on 16/9/7.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "HomeRightView.h"
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
#import "HistoryViewController.h"
#import "MyLeadershipTeamListController.h"
#import "AdvicesendpagelistViewController.h"
#import "AuditListViewController.h" //样机
#import "CostAuditingViewController.h" // 费用
#import "StockUpListViewController.h" // 备货
@implementation HomeRightView
{
    NSArray *titles;
}
- (id)initWithFrame:(CGRect)frame{
    titles = @[@"我的财富、事业目标",@"我的行动",@"我的机会",@"我预期实现的结果"];
    self = [super initWithFrame:frame ];
    if (self) {
        [self _initTableView];
    }
    return self;
}
- (void)_initTableView{
    _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:firstPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    [_tableView registerNib:[UINib nibWithNibName:@"MyTableVCell" bundle:nil] forCellReuseIdentifier:@"MyTableVCell"];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self addSubview:_tableView];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titles.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *allCell = @"cell";
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:allCell];
        cell.selectionStyle = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = titles[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    return cell;
}
//获取View所在的Viewcontroller方法
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *tagStr = cell.textLabel.text;
     // @"我的财富、事业目标",@"我的行动",@"我的机会",@"我预期实现的结果"
    if ([tagStr isEqualToString:@"我的财富、事业目标"] )
    {
        NSString *url = [NSString stringWithFormat:@"http://beaconapi.meidp.com/Mobi/Office/PersonNav?UserId=%@&sType=1",[NetManger shareInstance].userOtherID];
        WebModel *model = [[WebModel alloc] initWithUrl:url];
        WebViewController *SVC = [[WebViewController alloc] init];
        SVC.title = tagStr;
        SVC.hidesBottomBarWhenPushed = YES;
        [SVC setModel:model];
        [[self viewController].navigationController pushViewController:SVC animated:YES];
    }
    else if ([tagStr isEqualToString:@"我的行动"])
    {
        NSString *url = [NSString stringWithFormat:@"http://beaconapi.meidp.com/Mobi/Office/PersonNav?UserId=%@&sType=3",[NetManger shareInstance].userOtherID];
        WebModel *model = [[WebModel alloc] initWithUrl:url];
        WebViewController *SVC = [[WebViewController alloc] init];
        SVC.title = tagStr;
        SVC.hidesBottomBarWhenPushed = YES;
        [SVC setModel:model];
        [[self viewController].navigationController pushViewController:SVC animated:YES];
    }
    else if ([tagStr isEqualToString:@"我预期实现的结果"])
    {
        NSString *url = [NSString stringWithFormat:@"http://beaconapi.meidp.com/Mobi/Office/PersonNav?UserId=%@&sType=4",[NetManger shareInstance].userOtherID];
        WebModel *model = [[WebModel alloc] initWithUrl:url];
        WebViewController *SVC = [[WebViewController alloc] init];
        SVC.title = tagStr;
        SVC.hidesBottomBarWhenPushed = YES;
        [SVC setModel:model];
        [[self viewController].navigationController pushViewController:SVC animated:YES];
    }
    else if ([tagStr isEqualToString:@"我的机会"])
    {
        NSString *url = [NSString stringWithFormat:@"http://beaconapi.meidp.com/Mobi/Office/PersonNav?UserId=%@&sType=2",[NetManger shareInstance].userOtherID];
        WebModel *model = [[WebModel alloc] initWithUrl:url];
        WebViewController *SVC = [[WebViewController alloc] init];
        SVC.title = tagStr;
        SVC.hidesBottomBarWhenPushed = YES;
        [SVC setModel:model];
        [[self viewController].navigationController pushViewController:SVC animated:YES];
    }
    
    else if ([tagStr isEqualToString:@"医院拜访"])
    {
        SigninViewController *sub = [[SigninViewController alloc] init];
        sub.title = @"医院拜访";
        [[self viewController].navigationController pushViewController:sub animated:YES];
    }
    else if ([tagStr isEqualToString:@"合作伙伴拜访"])
    {
        TheNewSigninViewController *sub = [[TheNewSigninViewController alloc] init];
        sub.title = @"合作伙伴拜访";
        [[self viewController].navigationController pushViewController:sub animated:YES];
    }
    else if ([tagStr isEqualToString:@"我的项目"])
    {
        ProjectMangerViewController *sub = [[ProjectMangerViewController alloc] init];
        sub.title = @"我的项目";
        sub.sType = @"0";
        sub.hidesBottomBarWhenPushed = YES;
        [[self viewController].navigationController pushViewController:sub animated:YES];

    }
    else if ([tagStr isEqualToString:@"我借用的样机"])
    {
        MyDemoChiController *sub = [[MyDemoChiController alloc] init];
        sub.title = @"我借用的样机";
        sub.hidesBottomBarWhenPushed = YES;
        [[self viewController].navigationController pushViewController:sub animated:YES];
    }
    else if ([tagStr isEqualToString:@"我的审批"])
    {
        TheNewAuditListViewController *sub = [[TheNewAuditListViewController alloc] init];
        sub.title = @"我的审批";
        sub.hidesBottomBarWhenPushed = YES;
        [[self viewController].navigationController pushViewController:sub animated:YES];
    }else if ([tagStr isEqualToString:@"我成交的业绩"]||[tagStr isEqualToString:@"我的成果"])
    {
        ProjectMangerViewController *sub = [[ProjectMangerViewController alloc] init];
        sub.title = @"我成交的业绩";
        sub.sType = @"2";
        sub.hidesBottomBarWhenPushed = YES;
        [[self viewController].navigationController pushViewController:sub animated:YES];
    }
    else if ([tagStr isEqualToString:@"我的费用"])
    {
        MyPayViewController *sub = [[MyPayViewController alloc] init];
//        sub.title = @"我的费用";
//        sub.hidesBottomBarWhenPushed = YES;
//        [[self viewController].navigationController pushViewController:sub animated:YES];
        NSString *url = [NSString stringWithFormat:@"http://beaconapi.meidp.com/Mobi/Report/FeeAccount?code=%@",[NetManger shareInstance].userCode];
        WebModel *model = [[WebModel alloc] initWithUrl:url];
        WebViewController *SVC = [[WebViewController alloc] init];
        SVC.title = @"我的费用";
        SVC.hidesBottomBarWhenPushed = YES;
        [SVC setModel:model];
        [[self viewController].navigationController pushViewController:SVC animated:YES];

    }
//    else if ([tagStr isEqualToString:@"我的诚信度"])
//    {
//        CreditViewController *sub = [[CreditViewController alloc] init];
//        sub.title = @"我的诚信度";
//        sub.hidesBottomBarWhenPushed = YES;
//        [[self viewController].navigationController pushViewController:sub animated:YES];
//    }
    else if ([tagStr isEqualToString:@"费用报销"])
    {
        CostAuditingViewController *sub = [[CostAuditingViewController alloc] init];
        sub.title = @"费用报销";
        sub.hidesBottomBarWhenPushed = YES;
        [[self viewController].navigationController pushViewController:sub animated:YES];
    }
//    else if ([tagStr isEqualToString:@"我对公司的热爱"])
//    {
//        
//    }
    else if ([tagStr isEqualToString:@"团队的个人表现"])
    {
        MyLeadershipTeamListController *sub = [[MyLeadershipTeamListController alloc] init];
        sub.title = @"团队的个人表现";
        sub.hidesBottomBarWhenPushed = YES;
        [[self viewController].navigationController pushViewController:sub animated:YES];

    }
    else if ([tagStr isEqualToString:@"我的一伙人伙伴"])
    {
        MyPartnerViewController *sub = [[MyPartnerViewController alloc] init];
        sub.title = @"我的一伙人伙伴";
        [[self viewController].navigationController pushViewController:sub animated:YES];
    }
    else if ([tagStr isEqualToString:@"部门重要制度"])
    {
        NSString *url = [NSString stringWithFormat:@"http://beaconapi.meidp.com/mobi/office/deptinfo?UserId=%@&sType=4",[NetManger shareInstance].userID];
        WebModel *model = [[WebModel alloc] initWithUrl:url];
        WebViewController *SVC = [[WebViewController alloc] init];
        SVC.title = @"部门重要制度";
        SVC.hidesBottomBarWhenPushed = YES;
        [SVC setModel:model];
        [[self viewController].navigationController pushViewController:SVC animated:YES];

    }
    else if ([tagStr isEqualToString:@"部门重要事项"])
    {
        ImportantItemsListViewController *sub = [[ImportantItemsListViewController alloc] init];
        sub.title = @"重要事项";
        [[self viewController].navigationController pushViewController:sub animated:YES];
    }
    else if ([tagStr isEqualToString:@"部门职责"])
    {
        NSString *url = [NSString stringWithFormat:@"http://beaconapi.meidp.com/Mobi/Office/DeptInfo?UserId=%@&sType=1",[NetManger shareInstance].userID];
        WebModel *model = [[WebModel alloc] initWithUrl:url];
        WebViewController *SVC = [[WebViewController alloc] init];
        SVC.title = @"部门职责";
        SVC.hidesBottomBarWhenPushed = YES;
        [SVC setModel:model];
        [[self viewController].navigationController pushViewController:SVC animated:YES];
    }
    else if ([tagStr isEqualToString:@"部门指标"])
    {
        NSString *url = [NSString stringWithFormat:@"http://beaconapi.meidp.com/Mobi/Office/DeptInfo?UserId=%@&sType=2",[NetManger shareInstance].userID];
        WebModel *model = [[WebModel alloc] initWithUrl:url];
        WebViewController *SVC = [[WebViewController alloc] init];
        SVC.title = @"部门指标";
        SVC.hidesBottomBarWhenPushed = YES;
        [SVC setModel:model];
        [[self viewController].navigationController pushViewController:SVC animated:YES];
    }
    else if ([tagStr isEqualToString:@"部门流程"])
    {
        NSString *url = [NSString stringWithFormat:@"http://beaconapi.meidp.com/Mobi/Office/DeptInfo?UserId=%@&sType=3",[NetManger shareInstance].userID];
        WebModel *model = [[WebModel alloc] initWithUrl:url];
        WebViewController *SVC = [[WebViewController alloc] init];
        SVC.title = @"部门流程";
        SVC.hidesBottomBarWhenPushed = YES;
        [SVC setModel:model];
        [[self viewController].navigationController pushViewController:SVC animated:YES];

    }
//    else if ([tagStr isEqualToString:@"我的专业水平"])
//    {
//        SubEnterpriseCultureViewController *sub = [[SubEnterpriseCultureViewController alloc] init];
//        sub.title = @"我的专业水平";
//        sub.ID = 7;
//        [[self viewController].navigationController pushViewController:sub animated:YES];
//    }
    else if ([tagStr isEqualToString:@"公海池"])
    {
        ProjectMangerViewController  *sub = [[ProjectMangerViewController alloc] init];
        sub.title = @"项目公海池";
        sub.sType = @"1";
        sub.hidesBottomBarWhenPushed = YES;
        [[self viewController].navigationController pushViewController:sub animated:YES];
    }
    else if ([tagStr isEqualToString:@"我的展会"])
    {
        ExhibitionListViewController *sub = [[ExhibitionListViewController alloc] init];
        sub.title = @"我的展会";
        sub.hidesBottomBarWhenPushed = YES;
        [[self viewController].navigationController pushViewController:sub animated:YES];
    }
    else if ([tagStr isEqualToString:@"我的拜访记录"])
    {
        HistoryViewController *sub = [[HistoryViewController alloc] init];
        sub.title = @"我的拜访记录";
        [[self viewController].navigationController pushViewController:sub animated:YES];
    }
    else if ([tagStr isEqualToString:@"我的问题反馈"])
    {
        AdvicesendpagelistViewController *sub = [[AdvicesendpagelistViewController alloc] init];
        sub.title = @"我的问题反馈";
        [[self viewController].navigationController pushViewController:sub animated:YES];
    }
    else if ([tagStr isEqualToString:@"样机审批"])
    {
        AuditListViewController *sub = [[AuditListViewController alloc] init];
        sub.title = @"样机审批";
        [[self viewController].navigationController pushViewController:sub animated:YES];
    }
    else if ([tagStr isEqualToString:@"价格审批"])
    {
        StockUpListViewController *sub = [[StockUpListViewController alloc] init];
        sub.title = @"价格审批";
        [[self viewController].navigationController pushViewController:sub animated:YES];
    }

    else
    {
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"提示" message:@"开发中" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        [al show];
    }

}
- (void)changeData:(NSInteger )index
{
    JCKLog(@"%ld",index);
    switch (index) {
        case 0:
        {
            titles = @[@"我的财富、事业目标",@"我的行动",@"我的机会",@"我预期实现的结果",@"我对自己的承诺"];
        }
            break;
        case 10:
        {
            titles = @[@"医院拜访",@"合作伙伴拜访",@"我的拜访记录"];
        }
            break;
        case 11:
        {
            titles = @[@"样机审批",@"费用报销",@"价格审批",@"我的问题反馈",@"我的展会",@"出差审批",@"我的建议",@"我的待办事项"];
        }
            break;
        case 12:
        {
            titles = @[@"团队的个人表现"];
        }
            break;
        case 20:
        {
            titles = @[@"我的项目",@"我借用的样机",@"我的费用",@"我成交的业绩",@"我的成果池"];
        }
            break;
        case 21:
        {
            titles =  @[@"我的一伙人伙伴",@"我的专业水平",@"我的诚信度",@"我的勤奋度",@"我的展会表现",@"我的执行力"];
        }
            break;
        case 22:
        {
            titles = @[@"公司活动的表现",@"部门活动的表现",@"问题反馈的表现",@"公司建议的表现",@"在公司各个群的表现"];
        }
            break;
//        case 23:
//        {
//            titles = @[@"展会管理",@"公海池"];
//        }
//            break;
            
        default:
            break;
    }
    [_tableView reloadData];
}

@end

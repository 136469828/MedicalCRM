//
//  MeViewController.m
//  MedicalCRM
//
//  Created by admin on 16/7/8.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "MeViewController.h"
#import "CreditViewController.h"
#import "MyPayViewController.h"
#import "MyProjectViewController.h"
#import "PropertyViewController.h"
#import "ProjectMangerViewController.h"
#import "InfoViewController.h"
#import "MeTableViewCell.h"
#import "MeCell.h"
#import "MMZCViewController.h"
#import "UIImageView+WebCache.h"
#import "NetManger.h"
#import "ProjectModel.h"
#import "MJRefresh.h"
#import "CustomerListViewController.h"
@interface MeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *titles;
    NSArray *imgs;
    NetManger *manger;
    NSString *imgUrl;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation MeViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
    }];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 马上进入刷新状态
    [self.tableView.header beginRefreshing];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"个人信息";
    titles = @[@[@"",@"我的项目",@"我的业绩",@"我的诚信度",@"我的费用",@"我的成果池",@"我的财产",@"我的历史拜访记录"],@[@"退出登录"]];
    imgs = @[@[@"",@"xiangmu",@"yeji",@"chengxin",@"feiyong",@"chengguo",@"chaichang",@"weizhi"],@[@"shezhi"]];
    [self setTableView];
}
- (void)loadNewData
{
    manger = [NetManger shareInstance];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    manger.userName = [userDefaults objectForKey:@"userName"]; manger.userPWD = [userDefaults objectForKey:@"passWord"];
    [manger loadData:RequestOfLogin];
    [self.tableView reloadData];
    [self.tableView.header endRefreshing];
}
#pragma mark -
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView // 一个表视图里面有多少组
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section // 返回组的头宽
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==1) {
        return 1;
    }
    return 8;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 80;
    }
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && indexPath.section == 0) {
        MeTableViewCell *mecell = [MeTableViewCell selectedCell:tableView];
        ProjectModel *model = [NetManger shareInstance].logins[indexPath.row];
        mecell.nameLab.text = model.EmployeeName;
        mecell.zhiwuLab.text = model.DeptName;
        imgUrl = model.PhotoURL;
        mecell.imgV.layer.cornerRadius = 8;
        [mecell.imgV sd_setImageWithURL:[NSURL URLWithString:model.PhotoURL]];
        return mecell;
    }
    MeCell *cell = [MeCell selectedCell:tableView];
    cell.titleLab.text = [NSString stringWithFormat:@"%@",titles[indexPath.section][indexPath.row]];
    cell.imgv.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imgs[indexPath.section][indexPath.row]]];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0) {
            InfoViewController *sub = [[InfoViewController alloc] init];
            sub.title = @"更改个人资料";
            sub.imgUrl = imgUrl;
            sub.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sub animated:YES];
            
        }
        else if (indexPath.row == 1) {

            ProjectMangerViewController  *sub = [[ProjectMangerViewController alloc] init];
            sub.title = @"项目管理";
            sub.sType = @"0";
            sub.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sub animated:YES];
            
        }
        else if (indexPath.row == 3) {
            CreditViewController *sub = [[CreditViewController alloc] init];
            sub.title = @"我的信用";
            sub.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sub animated:YES];
            
        }
        else if (indexPath.row == 4) {
            MyPayViewController *sub = [[MyPayViewController alloc] init];
            sub.title = @"我的费用";
            sub.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sub animated:YES];
            
        }
        else if (indexPath.row == 5) {
            MyProjectViewController *sub = [[MyProjectViewController alloc] init];
            sub.title = @"我的项目";
            sub.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sub animated:YES];
            
        }
        else if (indexPath.row == 6) {
            PropertyViewController *sub = [[PropertyViewController alloc] init];
            sub.title = @"我的财产";
            sub.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sub animated:YES];
            
        }
        else if (indexPath.row == 7) {
            CustomerListViewController *sub = [[CustomerListViewController alloc] init];
            sub.title = @"官方教程";
            sub.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sub animated:YES];

        }
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        MMZCViewController *login = [[MMZCViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
        [self.navigationController presentModalViewController:nav animated:YES];
    }

}
@end

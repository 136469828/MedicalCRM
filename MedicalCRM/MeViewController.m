//
//  MeViewController.m
//  MedicalCRM
//
//  Created by admin on 16/7/8.
//  Copyright © 2016年 JCK. All rights reserved.
//ZhiWu

#import "MeViewController.h"
#import "CreditViewController.h"
#import "MyPayViewController.h"
#import "MyProjectViewController.h"
#import "PropertyViewController.h"
#import "ProjectMangerCollectViewController.h"
#import "AssessmentViewController.h"
#import "InfoViewController.h"
#import "MeTableViewCell.h"
#import "MeCell.h"
#import "MMZCViewController.h"
#import "UIImageView+WebCache.h"
#import "NetManger.h"
#import "ProjectModel.h"
#import "MJRefresh.h"
#import "HistoryViewController.h"
#import "MyPerformanceViewController.h"
#import "ProjectMangerViewController.h"
#import "MyDemoChiController.h"
#import "FeedbackController.h"
#import "WebModel.h"
#import "WebViewController.h"
#import "AdvicesendpagelistViewController.h"
#import "MyTeamListViewController.h"
#import "AboutViewController.h"
#import "JPUSHService.h"
#import "NewTeamListViewController.h"
#import "TeamListViewController.h"
#import "PasswordViewController.h"
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
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self.tableView.mj_header endRefreshing];
    }];
    [_tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    manger = [NetManger shareInstance];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"个人信息";
    titles = @[@[@""],@[@"我发展的团队",@"修改密码"],@[@"勿扰模式",@"关于"],@[@"退出"]];
    imgs = @[@[@""],@[@"mejiantuan",@"memima"],@[@"mewurao",@"meguanyu",@"chengguo"],@[@"退出",@"baifang",@"baifang"]];
    [self setTableView];
}

#pragma mark -
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-54) style:UITableViewStyleGrouped];
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
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section // 返回组的头宽
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    if (section==2) {
        return 2;
    }
    if (section == 3) {
        return 1;
    }
    return 2;
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
        if (model.ZhiWu.length == 0) {
            model.ZhiWu = @"(未填写)";
        }
        if (manger.userInfos != 0)
        {
            mecell.phoneLab.text = manger.userInfos[1];
        }
        else
        {
            mecell.phoneLab.text = model.Mobile;
        }
        mecell.nameLab.text = [NSString stringWithFormat:@"%@",model.EmployeeName];
        mecell.parkMentLab.text = model.DeptName;
        if (model.DeptName.length == 0) {
            model.DeptName = @"(未填写)";
        }
        mecell.zhiwuLab.text = model.ZhiWu;
        if (manger.userNewPhoto.length == 0 || [manger.userNewPhoto isEqualToString:@"http://beacon.meidp.com"])
        {
            imgUrl = @"http://g.hiphotos.baidu.com/exp/whcrop=160,120/sign=5027788b7ed98d1076815a734e4f853f/14ce36d3d539b6004409e1c0eb50352ac75cb786.jpg";
        }
        else
        {
            imgUrl = manger.userNewPhoto;
        }
        mecell.imgV.layer.cornerRadius = 8;
        [mecell.imgV sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
        return mecell;
    }
    MeCell *cell = [MeCell selectedCell:tableView];
    cell.titleLab.text = titles[indexPath.section][indexPath.row];
    cell.imgv.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imgs[indexPath.section][indexPath.row]]];
    if (indexPath.section == 2 && indexPath.row == 0)
    {
        UISwitch *switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(ScreenWidth-70, 5, 20, 10)];
        [switchButton setOn:YES];
        [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:switchButton];
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0)
    {
        MeTableViewCell *cell = (MeTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        if (indexPath.row == 0) {
            InfoViewController *sub = [[InfoViewController alloc] init];
            sub.title = @"更改个人资料";
            sub.imgUrl = imgUrl;
            sub.infos = @[cell.nameLab.text,cell.parkMentLab.text,cell.phoneLab.text];
            sub.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sub animated:YES];
            
        }
        
    }
    if (indexPath.section == 1)
    {
        if (indexPath.row == 0) {
//            MyTeamListViewController  *sub = [[MyTeamListViewController alloc] init];
//            sub.title = @"我的团队";
////            sub.sType = @"0";
//            //            sub.isPayManger = YES;
//            sub.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:sub animated:YES];
            TeamListViewController *sub = [[TeamListViewController alloc] init];
            sub.title = @"我发展的团队";
            sub.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sub animated:YES];

            
        }
        else if (indexPath.row == 1)
        {
//            UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请联系管理员修改密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [al show];

            PasswordViewController  *sub = [[PasswordViewController alloc] init];
            sub.title = @"修改密码";
            sub.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sub animated:YES];
            
        }
        else if (indexPath.row == 2)
        {
            
//            CreditViewController *sub = [[CreditViewController alloc] init];
//            sub.title = @"我的信用";
//            sub.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:sub animated:YES];
//            
        }
        else if (indexPath.row == 3) {
            // 关于
            AboutViewController *sub = [[AboutViewController alloc] init];
            sub.title = @"关于";
            [self.navigationController pushViewController:sub animated:YES];
        }
        else if (indexPath.row == 4)
        {
            WebModel *model = [[WebModel alloc] initWithUrl:@"https://www.baidu.com/"];
            WebViewController *SVC = [[WebViewController alloc] init];
            SVC.title = @"知识百科";
            SVC.hidesBottomBarWhenPushed = YES;
            [SVC setModel:model];
            [self.navigationController pushViewController:SVC animated:YES];
            //            ProjectMangerCollectViewController  *sub = [[ProjectMangerCollectViewController alloc] init];
            //            sub.title = @"我的项目";
            //            sub.sType = @"0";
            //            //            sub.isPayManger = YES;
            //            sub.hidesBottomBarWhenPushed = YES;
            //            [self.navigationController pushViewController:sub animated:YES];
            //            //            MyProjectViewController *sub = [[MyProjectViewController alloc] init];
            //            //            sub.title = @"我的项目";
            //            //            sub.hidesBottomBarWhenPushed = YES;
            //            //            [self.navigationController pushViewController:sub animated:YES];
            
        }
        else if (indexPath.row == 5) {
            MyDemoChiController *sub = [[MyDemoChiController alloc] init];
            sub.title = @"我的财产";
            sub.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sub animated:YES];
            
        }
        else if (indexPath.row == 6) {
            HistoryViewController *sub = [[HistoryViewController alloc] init];
            sub.title = @"我的历史拜访记录";
            sub.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sub animated:YES];
            
        }
        else if (indexPath.row == 7) {
            AssessmentViewController *sub = [[AssessmentViewController alloc] init];
            sub.title = @"自我评估";
            sub.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sub animated:YES];
        }
        
    }
    if (indexPath.section == 3 && indexPath.row == 0)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否注销当前账号" preferredStyle: UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //点击按钮的响应事件；
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:@"" forKey:@"userName"];
            MMZCViewController *login = [[MMZCViewController alloc]init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
            [self.navigationController presentModalViewController:nav animated:YES];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //点击按钮的响应事件；
        }]];
        
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];

        
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 1)
        {
            // 关于
            AboutViewController *sub = [[AboutViewController alloc] init];
            sub.title = @"关于";
            [self.navigationController pushViewController:sub animated:YES];
        }
        
    }
    
}

-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
//        showSwitchValue.text = @"是";
        JCKLog(@"关闭推送");
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }else {
//        showSwitchValue.text = @"否";
        JCKLog(@"打开推送");
//        [APService registerForRemoteNotificationTypes:];
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            //可以添加自定义categories
            [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                              UIUserNotificationTypeSound |
                                                              UIUserNotificationTypeAlert)
                                                  categories:nil];
        } else {
            //categories 必须为nil
            [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                              UIRemoteNotificationTypeSound |
                                                              UIRemoteNotificationTypeAlert)
                                                  categories:nil];
        }
    }
}
@end

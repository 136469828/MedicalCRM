//
//  NewFriendViewController.m
//  MedicalCRM
//
//  Created by admin on 16/8/6.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "NewFriendViewController.h"
#import "NewFriendGroupCell.h"
#import "FriendListModel.h"
#import "NetManger.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import "MJExtension.h"
#import "ChatListViewController.h"
#import "ChatViewController.h"
#import "JCKConversationViewController.h"
#import "NewFriendGroupViewController.h"
#import "UIImageView+WebCache.h"
#import "SeachFriendViewController.h"
#import "SigninViewController.h" // 签到
#import "ProjectMangerViewController.h" // 项目管理
#import "MyPayViewController.h" // 费用
#import "MyDemoChiController.h" // 样机

#import "MyPerformanceViewController.h" // 业绩
#import "AssessmentViewController.h" // 我的价值
#import "CreditViewController.h" // 诚信度
#import "LifeNavigationViewController.h" // 人生导航
#import "AuditListViewController.h"
#import "ExhibitionListViewController.h"
#import "ProjectBuildViewController.h"
#import "DemoMachineSaveController.h"
#import "TheNewCustomerListController.h"
#import "CLDropDownMenu.h"
#import "AddFriendListViewController.h"
#import "OftenUseLinkViewController.h"

@interface NewFriendViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchControllerDelegate,CNContactPickerDelegate>
{
    NetManger *manger;
    NSArray *titles;
    NSArray *imgs1;
    NSArray *imgs2;
    NSArray *titles2;
    NSArray *data;
    NSArray *filterData;
    UISearchDisplayController *searchDisplayController;
}
@property (nonatomic, strong) NSMutableArray *m_dateArray;
@property (nonatomic, strong) NSMutableArray *m_groups;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation NewFriendViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"通讯录";
    manger = [NetManger shareInstance];
    [manger loadData:RequestOfGetdeptusers];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDatas) name:@"getdeptusers" object:nil];
   
    data = @[@"qeqweqw",@"fhfgf",@"iyiy",@"23123",@"bvcbbc",@"",@"kikiki",@"poo",@"gdfgdf"];
//    titles = @[@"行政部",@"销售部",@"生产部",@"财务部",@"技术部"];
    imgs1 = @[@"bumenIcon",@"通讯录",@"群组"];
    imgs2 = @[@"link_xingzeng",@"link_xiaoshou",@"link_shengcan",@"link_caiwu",@"link_chanpin"];
    titles2 = @[@"最近联系人",@"通讯录",@"交流群"];
    UIButton *settingBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingBtn2 addTarget:self action:@selector(setDownMenu:) forControlEvents:UIControlEventTouchUpInside];
    [settingBtn2 setImage:[UIImage imageNamed:@"menu_gruops"] forState:UIControlStateNormal];
    [settingBtn2 sizeToFit];
    settingBtn2.frame = CGRectMake(0, 0, 35, 35);
    UIBarButtonItem *settingBtnItem2 = [[UIBarButtonItem alloc] initWithCustomView:settingBtn2];
    
    
    self.navigationItem.rightBarButtonItems  = @[settingBtnItem2];
}
- (void)setDownMenu:(UIButton *)sender
{
    AddFriendListViewController *sub = [[AddFriendListViewController alloc] init];
    sub.title = @"选择好友";
    sub.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sub animated:YES];
//    CLDropDownMenu *dropMenu = [[CLDropDownMenu alloc] initWithBtnPressedByWindowFrame:CGRectMake(ScreenWidth-110, -40, 100, 40) Pressed:^(NSInteger index) {
//        
//        NSLog(@"点击了第%ld个btn",index);
//        switch (index) {
//            case 0:
//            {
//                SigninViewController *sub = [[SigninViewController alloc] init];
//                sub.title = @"医院拜访";
//                sub.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:sub animated:YES];
//            }
//                break;
//            case 1:
//            {
//                AddFriendListViewController *sub = [[AddFriendListViewController alloc] init];
//                sub.title = @"选择好友";
//                sub.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:sub animated:YES];
//            }
//                break;
//            case 2:
//            {
//                ProjectBuildViewController *sub = [[ProjectBuildViewController alloc] init];
//                sub.title = @"项目申报";
//                sub.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:sub animated:YES];
//            }
//                break;
////            case 3:
////            {
////                DemoMachineSaveController *sub = [[DemoMachineSaveController alloc] init];
////                sub.title = @"样机申请";
////                sub.ID = @(0);
////                sub.hidesBottomBarWhenPushed = YES;
////                [self.navigationController pushViewController:sub animated:YES];
////            }
////                break;
//                
//            default:
//                break;
//        }
//        sender.selected = !sender.selected;
//        
//    }];
//    
//    dropMenu.direction = CLDirectionTypeBottom;
//    dropMenu.titleList = @[@"医院拜访",@"创建聊天",@"申报项目"];
//    
//    if (!sender.selected)
//    {
//        [self.view addSubview:dropMenu];
//        sender.selected = !sender.selected;
//    }
//    else
//    {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"closeMenu" object:nil];
//        sender.selected = !sender.selected;
//    }
}
- (void)reloadDatas
{
    for (NSDictionary *dic in manger.friendLists)
    {
        if (!_m_groups) {
            _m_groups = [NSMutableArray array];
        }
        
        [_m_groups addObject:dic[@"DeptName"]];
        if (!_m_dateArray) {
            _m_dateArray = [NSMutableArray array];
        }
        
        [_m_dateArray addObject:dic[@"Users"]];
    }
//    JCKLog(@"%@",_m_dateArray);
    [self setTableView];
}
#pragma mark -
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 109) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //iOS 8开始的自适应高度，可以不需要实现定义高度的方法
//    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = 60;

    [self.view addSubview:_tableView];
    UIView *seachView = [[UIView alloc]
                         initWithFrame:CGRectMake(0, 0, ScreenWidth, 35 + 60 +65)];
    seachView.backgroundColor = [UIColor whiteColor];
    
    UIButton *seachBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    seachBtn.frame = CGRectMake(10,3,ScreenWidth-20,33);
    seachBtn.backgroundColor = RGB(238, 238, 238);
    seachBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    seachBtn.layer.cornerRadius = 3;
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-20)/2 - 28, 10, 12, 12)];
    imgv.image = [UIImage imageNamed:@"seacchIcon"];
    [seachBtn addSubview:imgv];
    [seachBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [seachBtn setTitleColor:RGB(165, 165, 165) forState:UIControlStateNormal];
    [seachBtn addTarget:self action:@selector(seachBtnAction) forControlEvents:UIControlEventTouchDown];
    [seachView addSubview:seachBtn];
    // 分割线
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth , 1)];
    line3.backgroundColor = RGB(235, 235, 235);
    [seachView addSubview:line3];
    
    // 标题1
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(12 + 45 + 8, 35+60 - 10 - 45 + 15, ScreenWidth - 12 + 45 + 8-60, 30)];
    //    titleLab.backgroundColor = [UIColor redColor];
    titleLab.font = [UIFont systemFontOfSize:15];
    titleLab.text = @"常用群组";
    [seachView addSubview:titleLab];
    // 头像1
    UIImageView *imgv2 = [[UIImageView alloc] initWithFrame:CGRectMake(12, 30+60 - 10 - 35, 45, 45)];
    imgv2.image = [UIImage imageNamed:@"群组"];
    imgv2.layer.cornerRadius = 5;
    [seachView addSubview:imgv2];
    
    // 分割线1
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(16, 35+65 - 1, ScreenWidth - 10, 1)];
    line.backgroundColor = RGB(238, 238, 238);
    [seachView addSubview:line];
    
    // btn
    UIButton *pushBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pushBtn.frame = CGRectMake(0,30,ScreenWidth,65+35 - 30);
    pushBtn.backgroundColor = [UIColor clearColor];
    [pushBtn addTarget:self action:@selector(pushBtnAction) forControlEvents:UIControlEventTouchDown];
    [seachView addSubview:pushBtn];
    
    
    
    // 标题2
    UILabel *titleLab2 = [[UILabel alloc] initWithFrame:CGRectMake(12 + 45 + 8, 35+50 - 10 - 45 + 15 + 68, ScreenWidth - 12 + 45 + 8-60, 30)];
    //    titleLab.backgroundColor = [UIColor redColor];
    titleLab2.font = [UIFont systemFontOfSize:15];
    titleLab2.text = @"常用联系人";
    [seachView addSubview:titleLab2];
    // 头像2
    UIImageView *imgv22 = [[UIImageView alloc] initWithFrame:CGRectMake(12, 30+50 - 10 - 35+70, 45, 45)];
    imgv22.image = [UIImage imageNamed:@"通讯录"];
    imgv22.layer.cornerRadius = 5;
    [seachView addSubview:imgv22];
    // btn2
    UIButton *pushBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    pushBtn2.frame = CGRectMake(0,35+65,ScreenWidth,70);
    pushBtn2.backgroundColor = [UIColor clearColor];
    [pushBtn2 addTarget:self action:@selector(pushBtnAction2) forControlEvents:UIControlEventTouchDown];
    [seachView addSubview:pushBtn2];
    
    _tableView.tableHeaderView = seachView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *datas = _m_dateArray[section];
    return datas.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView // 一个表视图里面有多少组
{
    return _m_groups.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section // 返回组的头宽
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section // 返回组的尾宽
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section // 返回组名
{
    return _m_groups[section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *allCell = @"cell";
//    UITableViewCell *cell = nil;
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:allCell];
//        cell.selectionStyle = UITableViewCellAccessoryNone;
//    }
    NewFriendGroupCell *cell = [NewFriendGroupCell selectedCell:tableView];
    cell.nameLab.text = _m_dateArray[indexPath.section][indexPath.row][@"EmployeeName"];
    [cell.imgV sd_setImageWithURL:[NSURL URLWithString:_m_dateArray[indexPath.section][indexPath.row][@"PhotoURL"]]];
//    cell.subTitleLab.text =  _m_dateArray[indexPath.section][indexPath.row][@"QuarterName"];
//
    cell.phoneLab.text = _m_dateArray[indexPath.section][indexPath.row][@"Mobile"];
    NSString *str = [NSString stringWithFormat:@"%@",_m_dateArray[indexPath.section][indexPath.row][@"QuarterName"]];
    if (![str isEqualToString:@"<null>"])
    {
        cell.subTitleLab.text = str;
    }
    else
    {
        cell.subTitleLab.text = @"无";
    }
    cell.tagLab.text = [NSString stringWithFormat:@"%@",_m_dateArray[indexPath.section][indexPath.row][@"UserID"]];
    if ([NSString stringWithFormat:@"%@",_m_dateArray[indexPath.section][indexPath.row][@"Mobile"]].length  > 9)
    {
            cell.phoneAction.tag = [_m_dateArray[indexPath.section][indexPath.row][@"Mobile"] integerValue];
    }
    else
    {
        [cell.phoneAction removeFromSuperview];
    }

    [cell.phoneAction addTarget:self action:@selector(cellBtnAction:) forControlEvents:UIControlEventTouchDown];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewFriendGroupCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    JCKConversationViewController *conversationVC = [[JCKConversationViewController alloc]init];
    conversationVC.conversationType =ConversationType_PRIVATE;
    conversationVC.targetId = cell.tagLab.text; 
    conversationVC.title = cell.nameLab.text;
    conversationVC.hidesBottomBarWhenPushed = YES;
    [_tableView reloadData];
    [self.navigationController pushViewController:conversationVC animated:YES];

}
- (void)seachBtnAction
{
    SeachFriendViewController *sub = [[SeachFriendViewController alloc] init];
    sub.hidesBottomBarWhenPushed = YES;
    [_tableView reloadData];
    [self.navigationController pushViewController:sub animated:YES];
    
}
- (void)pushBtnAction
{
    OftenUseLinkViewController *sub = [[OftenUseLinkViewController alloc] init];
    sub.title = @"常用群组";
    sub.isOnlyGroup = 1;
    [_tableView reloadData];
    [self.navigationController pushViewController:sub animated:YES];
    
}
- (void)pushBtnAction2
{
    OftenUseLinkViewController *sub = [[OftenUseLinkViewController alloc] init];
    sub.title = @"常用联系人";
    sub.isOnlyGroup = 2;
    [_tableView reloadData];
    [self.navigationController pushViewController:sub animated:YES];
    
}
- (void)cellBtnAction:(UIButton *)btn
{
    if (btn.tag != 0)
    {
        NSString *num = [[NSString alloc] initWithFormat:@"tel://%ld",btn.tag]; //number为号码字符串
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
    }
    else
    {
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该同事没有联系电话消息，请与后台工作人员沟通" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [al show];
    }

}
@end

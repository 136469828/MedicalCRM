//
//  TheCompanyViewController.m
//  MedicalCRM
//
//  Created by admin on 16/8/6.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "TheCompanyViewController.h"
#import "NormalViewController.h"
#import "TheCompanyListCell.h"
#import "NewListViewController.h"
#import "SubEnterpriseCultureViewController.h"
#import "NetManger.h"
#import "MJExtension.h"
#import "TheNewModel.h"
#import "SDCycleScrollView.h"
#import "WebModel.h"
#import "WebViewController.h"
#import "UIImageView+WebCache.h"
#import "CLDropDownMenu.h"
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
#import "AddFriendListViewController.h"
#import "TheCompanyImgViewController.h"
@interface TheCompanyViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>
{
    NSArray *titles;
    NSArray *subtitles;
    NSArray *imgs;
    NetManger *manger;
}
@property (nonatomic, strong) NSMutableArray *m_datas;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation TheCompanyViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    manger = [NetManger shareInstance];
    [manger loadData:RequestOfGetculturetypes];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTableView) name:@"getculturetypes" object:nil];
    [manger loadData:RequestOfadvertise];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setADView) name:@"getadvertiselist" object:nil];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"深圳市巨烽显示科技有限公司";
    titles = @[@"公司文化",@"公告",@"制度",@"新闻",@"活动",@"组织框架"];
    subtitles = @[@"巨烽的企业文化",@"巨烽的规章制度",@"巨烽新闻直播间",@"回顾过往活动及展会详情",@"企业组织架构一览",@"显示最新动态"];
    imgs = @[@"gongsi_qiyewenhua",@"gongsi_gonggao",@"gongsi_zhidu",@"gongsi_xinwen",@"gongsi_huodong",@"gongsi_zuzhi"];
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
}
#pragma mark -
- (void)setTableView
{
    [_m_datas removeAllObjects];
    for (NSDictionary *dic in manger.culturetypes)
    {
        TheNewModel *model = [TheNewModel mj_objectWithKeyValues:dic];
        if (self.m_datas.count == 0)
        {
            _m_datas = [NSMutableArray array];
        }
        [_m_datas addObject:model];
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 69) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //iOS 8开始的自适应高度，可以不需要实现定义高度的方法
    //    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = 60;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];


}
#pragma mark - setAD
- (void)setADView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 69) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //iOS 8开始的自适应高度，可以不需要实现定义高度的方法
    //    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = 60;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
    
    // 网络加载 --- 创建自定义图片的pageControlDot的图片轮播器
    SDCycleScrollView *cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight*0.3) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    cycleScrollView3.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
    cycleScrollView3.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
    cycleScrollView3.imageURLStringsGroup = manger.ads;
    //    [bgView addSubview:cycleScrollView3];
    
    _tableView.tableHeaderView = cycleScrollView3;
}
#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    WebModel *model = [[WebModel alloc] initWithUrl:@"http://www.beacon-display.cn/jfxc.html"];
    WebViewController *SVC = [[WebViewController alloc] init];
    SVC.title = @"详情";
    SVC.hidesBottomBarWhenPushed = YES;
    [SVC setModel:model];
    [self.navigationController pushViewController:SVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section // 返回组的头宽
{
    return 19;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section // 返回组的尾宽
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    TheCompanyListCell *cell = [TheCompanyListCell selectedCell:tableView];
    if (indexPath.row != 5)
    {
        TheNewModel *model = _m_datas[indexPath.row];
        [cell.imgV sd_setImageWithURL:[NSURL URLWithString:model.icon]];
        cell.titleLab.text = model.TypeName;
        cell.subTitleLab.text = model.LastDataTitle;
        UILabel *readLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-35, 44/2-20/2, 20, 20)];
        readLab.layer.cornerRadius = 10;
        readLab.layer.masksToBounds = YES;
        readLab.text = model.NoReadTotal;
        readLab.text = model.NoReadTotal;
        readLab.textAlignment = NSTextAlignmentCenter;
        readLab.font = [UIFont systemFontOfSize:10];
        readLab.textColor = [UIColor whiteColor];
        readLab.backgroundColor = [UIColor redColor];
        cell.tag = [model.ID integerValue];
        [cell.contentView addSubview:readLab];
        if ([model.NoReadTotal isEqualToString:@"0"])
        {
            readLab.hidden = YES;
        }
        return cell;
    }
    else
    {
        cell.imgV.image = [UIImage imageNamed:@"gongsi_zuzhi"];
        cell.titleLab.text = @"公司组织架构";
        cell.subTitleLab.text = @"企业管理架构";
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    if (indexPath.row == 5)
    {
        TheCompanyImgViewController *sub = [[TheCompanyImgViewController alloc] init];
        sub.title = @"公司组织架构";
        [self.navigationController pushViewController:sub animated:YES];

    }
    else
    {
        TheCompanyListCell *cell = (TheCompanyListCell *)[tableView cellForRowAtIndexPath:indexPath];
        SubEnterpriseCultureViewController *sub = [[SubEnterpriseCultureViewController alloc] init];
        sub.title = cell.titleLab.text;
        sub.ID = indexPath.row + 1;
        [self.navigationController pushViewController:sub animated:YES];
    }

//    switch (indexPath.row) {
//        case 0:// 企业文化
//        {
//            SubEnterpriseCultureViewController *sub = [[SubEnterpriseCultureViewController alloc] init];
//            sub.title = @"企业文化";
//            sub.ID = 9;
//            [self.navigationController pushViewController:sub animated:YES];
//        }
//            break;
//        case 1:
//        {
//            NormalViewController  *sub = [[NormalViewController alloc] init];
//            sub.title = @"公告";
//            sub.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:sub animated:YES];
//        }
//            break;
//        case 2: // 制度
//        {
//            SubEnterpriseCultureViewController *sub = [[SubEnterpriseCultureViewController alloc] init];
//            sub.title = @"公司制度";
//            sub.ID = 10;
//            [self.navigationController pushViewController:sub animated:YES];
//        }
//            break;
//        case 3:
//        {
//            NewListViewController *sub = [[NewListViewController alloc] init];
//            sub.title = @"新闻列表";
//            sub.ID = @"11";
//            sub.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:sub animated:YES];
//        }
//            break;
//        case 4:// 新闻
//        {
//            
//
//        }
//            break;
//        case 5:
//        {
//            
//        }
//            break;
//            
//        default:
//            break;
//    }
}
@end

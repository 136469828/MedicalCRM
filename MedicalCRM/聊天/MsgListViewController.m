//
//  MsgListViewController.m
//  MedicalCRM
//
//  Created by admin on 16/8/8.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "MsgListViewController.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "NetManger.h"
#import "MsgListModel.h"
#import "MsgListCell.h"
#import "PayInfoViewController.h"
#import "MyPayInfoViewController.h"
#import "ProjectInfoController.h"
#import "HistoryViewController.h"
#import "StockUpInfoViewController.h"
#import "TheNewCustomInfoViewController.h"
#import "WebModel.h"
#import "WebViewController.h"
@interface MsgListViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchControllerDelegate>
{
    NetManger *manger;
    NSArray *data;
    NSArray *filterData;
    UISearchDisplayController *searchDisplayController;
}
@property (nonatomic, strong) NSMutableArray *m_datas;
@property (nonatomic, strong) NSMutableArray *m_IDdatas;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation MsgListViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    manger = [NetManger shareInstance];
    [manger loadData:RequestOfGetjpushpagelist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodatas) name:@"getjpushpagelist" object:nil];
}
- (void)relodatas
{
    [_m_datas removeAllObjects];
    [_m_IDdatas removeAllObjects];
    for (NSDictionary *dic in manger.pushLists)
    {
        MsgListModel *model = [MsgListModel mj_objectWithKeyValues:dic];
        if (_m_datas.count == 0)
        {
            _m_datas = [NSMutableArray array];
        }
        if (_m_IDdatas.count == 0)
        {
            _m_IDdatas = [NSMutableArray array];
        }
        [_m_IDdatas addObject:dic[@"Id"]];
        NSString *str = [model.CreateTime  substringToIndex:16];
        [_m_datas addObject:[NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|%@|%@",model.Title,model.Msg,[str  substringFromIndex:5],model.BillTypeFlag,model.BillTypeCode,model.BillId,model.Status,model.PowerType]];
    }
    [self setTableView];
}
#pragma mark -
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 69) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //iOS 8开始的自适应高度，可以不需要实现定义高度的方法
//    self.tableView.estimatedRowHeight = 200;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [_tableView.header endRefreshing];
    }];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [_tableView.footer endRefreshing];
    }];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width
                                                                           , 44)];
    searchBar.placeholder = @"搜索";
    
    // 添加 searchbar 到 headerview
    self.tableView.tableHeaderView = searchBar;
    
    // 用 searchbar 初始化 SearchDisplayController
    // 并把 searchDisplayController 和当前 controller 关联起来
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    
    // searchResultsDataSource 就是 UITableViewDataSource
    searchDisplayController.searchResultsDataSource = self;
    // searchResultsDelegate 就是 UITableViewDelegate
    searchDisplayController.searchResultsDelegate = self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return _m_datas.count;
    }else{
        // 谓词搜索
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@",searchDisplayController.searchBar.text];
        filterData =  [[NSArray alloc] initWithArray:[_m_datas filteredArrayUsingPredicate:predicate]];
        return filterData.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MsgListCell *cell = [MsgListCell selectedCell:tableView];
    if (tableView == self.tableView)
    {
        NSArray *datas = [[NSString stringWithFormat:@"%@",_m_datas[indexPath.row]] componentsSeparatedByString:@"|"];
        cell.tagLab1.text = [NSString stringWithFormat:@"%@",datas[3]];
        cell.tagLab2.text = [NSString stringWithFormat:@"%@",datas[4]];
        cell.IdLab.text = [NSString stringWithFormat:@"%@",_m_IDdatas[indexPath.row]];
        cell.tabLab3.text = [NSString stringWithFormat:@"%@",datas[7]];
        if ([cell.tagLab1.text isEqualToString:@"5"] && [cell.tagLab2.text isEqualToString:@"11"]) // 样机
        {
            cell.msgImgV.image = [UIImage imageNamed:@"msg样机"];
        }
        else if ([cell.tagLab1.text isEqualToString:@"4"] && [cell.tagLab2.text isEqualToString:@"7"])// 客户
        {
            cell.msgImgV.image = [UIImage imageNamed:@"msg样机"];
        }
        else if ([cell.tagLab1.text isEqualToString:@"1"] && [cell.tagLab2.text isEqualToString:@"4"]) // 费用
        {
            cell.msgImgV.image = [UIImage imageNamed:@"msg费用"];
        }
        else if ([cell.tagLab1.text isEqualToString:@"4"] && [cell.tagLab2.text isEqualToString:@"4"]) // 拜访
        {
            cell.msgImgV.image = [UIImage imageNamed:@"msg拜访"];
        }
        else
        {
            cell.msgImgV.image = [UIImage imageNamed:@"msg广播"];
        }
        if (![[NSString stringWithFormat:@"%@",[datas lastObject]] isEqualToString:@"0"])
        {
            cell.titleLab.textColor = RGB(209, 209, 209);
            cell.contextLab.textColor = RGB(209, 209, 209);
        }
        cell.titleLab.text = datas[1];
        cell.contextLab.text = [NSString stringWithFormat:@"消息内容: %@",datas[0]];
        cell.timeLab.text = datas[2];
        cell.tag = [[NSString stringWithFormat:@"%@",datas[5]] integerValue];
    }
    else
    {
        NSArray *datas = [[NSString stringWithFormat:@"%@",filterData[indexPath.row]] componentsSeparatedByString:@"|"];
        if ([[NSString stringWithFormat:@"%@",[datas lastObject]] isEqualToString:@"0"])
        {
            cell.titleLab.textColor = RGB(209, 209, 209);
            cell.contextLab.textColor = RGB(209, 209, 209);
        }
        cell.titleLab.text = datas[1];
        cell.contextLab.text = [NSString stringWithFormat:@"消息内容: %@",datas[0]];
        cell.timeLab.text = datas[2];
        cell.tagLab1.text = [NSString stringWithFormat:@"%@",datas[3]];
        cell.tagLab2.text = [NSString stringWithFormat:@"%@",datas[4]];
        cell.tabLab3.text = [NSString stringWithFormat:@"%@",datas[7]];
        cell.IdLab.text = [NSString stringWithFormat:@"%@",_m_IDdatas[indexPath.row]];
        cell.tag = [[NSString stringWithFormat:@"%@",datas[5]] integerValue];
        if ([cell.tagLab1.text isEqualToString:@"5"] && [cell.tagLab2.text isEqualToString:@"11"]) // 样机
        {
            cell.msgImgV.image = [UIImage imageNamed:@"msg样机"];
        }
        else if ([cell.tagLab1.text isEqualToString:@"4"] && [cell.tagLab2.text isEqualToString:@"7"])// 客户
        {
            cell.msgImgV.image = [UIImage imageNamed:@"msg样机"];
        }
        else if ([cell.tagLab1.text isEqualToString:@"1"] && [cell.tagLab2.text isEqualToString:@"4"]) // 费用
        {
            cell.msgImgV.image = [UIImage imageNamed:@"msg费用"];
        }
        else if ([cell.tagLab1.text isEqualToString:@"4"] && [cell.tagLab2.text isEqualToString:@"4"]) // 拜访
        {
            cell.msgImgV.image = [UIImage imageNamed:@"msg拜访"];
        }
        else
        {
            cell.msgImgV.image = [UIImage imageNamed:@"msg广播"];
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [searchDisplayController setActive:NO animated:NO]; // 关闭搜索框
    MsgListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    manger.ID = cell.IdLab.text;
    JCKLog(@"%@", manger.ID);
    [manger loadData:RequestOfJpushreadsave];
    if ([cell.tagLab1.text isEqualToString:@"5"] && [cell.tagLab2.text isEqualToString:@"11"]) {
        
        if ([cell.tabLab3.text isEqualToString:@"1"])
        {
            PayInfoViewController *sub = [[PayInfoViewController alloc] init];
            sub.title = @"样机详情";
            sub.isAdu = 3;
            sub.ID = [NSString stringWithFormat:@"%ld",cell.tag];
            [self.navigationController pushViewController:sub animated:YES];

        }
        else
        {
            NSString *url = [NSString stringWithFormat:@"http://beaconapi.meidp.com/Mobi/Order/SellSample?Id=%@&UserId=%@",[NSString stringWithFormat:@"%ld",cell.tag],[NetManger shareInstance].userOtherID];
            WebModel *model = [[WebModel alloc] initWithUrl:url];
            WebViewController *SVC = [[WebViewController alloc] init];
            SVC.title = @"样机审批详情";
            SVC.hidesBottomBarWhenPushed = YES;
            [SVC setModel:model];
            [self.navigationController pushViewController:SVC animated:YES];
        }
        
        
    }
    if ([cell.tagLab1.text isEqualToString:@"1"] && [cell.tagLab2.text isEqualToString:@"4"]) {
        
        if ([cell.tabLab3.text isEqualToString:@"1"])
        {
            NSString *url = [NSString stringWithFormat:@"http://beaconapi.meidp.com/Mobi/CheckCenter/FeeApplyCheck?Id=%@&code=%@",[NSString stringWithFormat:@"%ld",cell.tag],[NetManger shareInstance].userCode];
            WebModel *model = [[WebModel alloc] initWithUrl:url];
            WebViewController *SVC = [[WebViewController alloc] init];
            SVC.title = @"费用审批详情";
            SVC.hidesBottomBarWhenPushed = YES;
            [SVC setModel:model];
            [self.navigationController pushViewController:SVC animated:YES];
        }
        else
        {
            MyPayInfoViewController *sub = [[MyPayInfoViewController alloc] init];
            sub.title = @"费用详情";
            sub.ID = [NSString stringWithFormat:@"%ld",cell.tag];
            [self.navigationController pushViewController:sub animated:YES];
        }

        
    }
    if ([cell.tagLab1.text isEqualToString:@"13"] && [cell.tagLab2.text isEqualToString:@"1"])//项目
    {
        ProjectInfoController *sub = [[ProjectInfoController alloc] init];
        sub.title = @"项目详细";
        sub.isPublic = NO;
        sub.ID = cell.tag;
        [self.navigationController pushViewController:sub animated:YES];
    }
    // 客户拜访
    if ([cell.tagLab1.text isEqualToString:@"4"] && [cell.tagLab2.text isEqualToString:@"3"])//
    {
        HistoryViewController *sub = [[HistoryViewController alloc] init];
        sub.title = @"历史拜访记录";
        [self.navigationController pushViewController:sub animated:YES];
    }
    // 备货申请
    if ([cell.tagLab1.text isEqualToString:@"5"] && [cell.tagLab2.text isEqualToString:@"3"])//
    {
        JCKLog(@"JCK%@-%ld",cell.tabLab3.text,cell.tag);
        if ([cell.tabLab3.text isEqualToString:@"1"])
        {
            NSString *url = [NSString stringWithFormat:@"http://beaconapi.meidp.com/Mobi/CheckCenter/OrderPriceCheck?Id=%@&code=%@",[NSString stringWithFormat:@"%ld",cell.tag],[NetManger shareInstance].userCode];
            WebModel *model = [[WebModel alloc] initWithUrl:url];
            WebViewController *SVC = [[WebViewController alloc] init];
            SVC.title = @"价格审批详情";
            SVC.hidesBottomBarWhenPushed = YES;
            [SVC setModel:model];
            [self.navigationController pushViewController:SVC animated:YES];
        }
        else
        {
            StockUpInfoViewController *sub = [[StockUpInfoViewController alloc] init];
            sub.title = @"价格详情";
            sub.ID =[NSString stringWithFormat:@"%ld",cell.tag];
            [self.navigationController pushViewController:sub animated:YES];
        }

    }
    if ([cell.tagLab1.text isEqualToString:@"4"] && [cell.tagLab2.text isEqualToString:@"7"])//客户详情
    {
        TheNewCustomInfoViewController *sub = [[TheNewCustomInfoViewController alloc] init];
        sub.title = @"客户详情";
        sub.ID =[NSString stringWithFormat:@"%ld",cell.tag];
        [self.navigationController pushViewController:sub animated:YES];
    }
    if ([cell.tagLab1.text isEqualToString:@"5"] && [cell.tagLab2.text isEqualToString:@"4"])//
    {
//        StockUpInfoViewController *sub = [[StockUpInfoViewController alloc] init];
//        sub.title = @"备货申请";
//        sub.ID =[NSString stringWithFormat:@"%ld",cell.tag];
//        [self.navigationController pushViewController:sub animated:YES];
    }
    JCKLog(@"%@,%@",cell.tagLab1.text,cell.tagLab2.text);

}
@end

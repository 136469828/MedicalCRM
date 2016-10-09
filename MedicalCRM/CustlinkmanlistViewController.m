//
//  CustlinkmanlistViewController.m
//  MedicalCRM
//
//  Created by admin on 16/7/19.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "CustlinkmanlistViewController.h"
#import "NetManger.h"
#import "CustlinkmanlistModel.h"
#import "CustlinkmansaveViewController.h"
#import "MJRefresh.h"
#import "CustInfoViewController.h"
@interface CustlinkmanlistViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NetManger *manger;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation CustlinkmanlistViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    manger = [NetManger shareInstance];
    manger.customID = [NSString stringWithFormat:@"%ld",self.ID];
    [manger loadData:RequestOfGetcustlinkmanlist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloDatas) name:@"getcustlinkmanlist" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTableView];
    
#pragma mark - 设置navigationItem右侧按钮
    UIButton *meassageBut = ({
        UIButton *meassageBut = [UIButton buttonWithType:UIButtonTypeCustom];
        meassageBut.frame = CGRectMake(0, 0, 25, 25);
        [meassageBut addTarget:self action:@selector(pushAddLinkMan) forControlEvents:UIControlEventTouchDown];
        [meassageBut setImage:[UIImage imageNamed:@"addLinkMan_icon"]forState:UIControlStateNormal];
        meassageBut;
    });
    
    UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithCustomView:meassageBut];
    self.navigationItem.rightBarButtonItem = rBtn;
}
- (void)reloDatas
{
    [self.tableView reloadData];
}
#pragma mark -
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-56) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self reloDatas];
        [_tableView.mj_header endRefreshing];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self reloDatas];
        [_tableView.mj_footer endRefreshing];
    }];
    //iOS 8开始的自适应高度，可以不需要实现定义高度的方法
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return manger.getcustlinkmanlist.count;
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:allCell];
        cell.selectionStyle = UITableViewCellAccessoryNone;
    }
    CustlinkmanlistModel *model = manger.getcustlinkmanlist[indexPath.row];
    cell.textLabel.text = model.LinkManName;
    cell.tag = [model.ID integerValue];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    UILabel *phoneLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*0.3, 0, ScreenWidth-ScreenWidth*0.3-20,44)];
    phoneLab.text = model.WorkTel;
    phoneLab.textAlignment = NSTextAlignmentRight;
    phoneLab.font = [UIFont systemFontOfSize:13];
    phoneLab.tag = [model.ID integerValue] +1000;
    [cell.contentView addSubview:phoneLab];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    UILabel *lb = (UILabel *)[tableView viewWithTag:1000+cell.tag];
    NSArray *datas = @[[NSString stringWithFormat:@"%ld",self.ID],[NSString stringWithFormat:@"%ld",cell.tag],lb.text,[NSString stringWithFormat:@" %@ %@",self.custom,cell.textLabel.text]];

    int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index -2)] animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cuNameStr" object:datas];

}
- (void)pushAddLinkMan
{
    CustlinkmansaveViewController *sub = [[CustlinkmansaveViewController alloc] init];
    sub.CustNo = self.customNo;
    sub.title = @"添加客户联系人";
    [self.navigationController pushViewController:sub animated:YES];

}
@end

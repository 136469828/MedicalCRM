//
//  TheProjectListViewController.m
//  MedicalCRM
//
//  Created by admin on 16/8/5.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "TheProjectListViewController.h"
#import "ProjectInfoController.h"
#import "ProjectMangerCell.h"
#import "MJRefresh.h"
#import "NetManger.h"
#import "GetprojectpagelistModel.h"
#import "ProjectBuildViewController.h"
#import "FiltrateView.h"
#import "SeachViewController.h"

#import "MJExtension.h"
#import "MyProjectListModel.h"
@interface TheProjectListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NetManger *manger;
}
@property (nonatomic, strong) NSMutableArray *m_datas;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation TheProjectListViewController
// 销毁通知中心
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    manger = [NetManger shareInstance];
    manger.sType = @"";
    manger.keywork = @"";
    manger.sType2 = @"";
    manger.ID = @"";
    [manger loadData:RequestOfGetMyprojectpagelist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDatas) name:@"getmyprojectpagelist" object:nil];
}
- (void)reloadDatas
{
    for (NSDictionary *dic in manger.myPorjectlists) {
        MyProjectListModel *model = [MyProjectListModel mj_objectWithKeyValues:dic];
        if (!_m_datas) {
            _m_datas = [NSMutableArray array];
        }
        [_m_datas addObject:model];
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
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        
    }];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [_tableView.footer endRefreshing];
    }];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
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
    return _m_datas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *allCell = @"cell";
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:allCell];
        cell.selectionStyle = UITableViewCellAccessoryNone;
    }
    MyProjectListModel *model = _m_datas[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:11];
    cell.textLabel.text = [NSString stringWithFormat:@"项目名:%@",model.ProjectName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"项目联系人:%@",model.CustLinkMan];
    cell.tag = [model.ID integerValue];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.textLabel.text.length != 0 )
    {
        if (self.block)
        {
            self.block(cell.textLabel.text,[NSString stringWithFormat:@"%ld",cell.tag]);
        }
    }
    else
    {
        NSLog(@"nil");
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end

//
//  ImportantItemsListViewController.m
//  MedicalCRM
//
//  Created by admin on 16/8/12.
//  Copyright © 2016年 JCK. All rights reserved.
//Getpersonaldatearrangepagelist getpersonaldatearrangepagelist

#import "ImportantItemsListViewController.h"
#import "NetManger.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "ImportantItemsListModel.h"
#import "ImportantItemsListCell.h"
#import "ImportantItemsBulidViewController.h"
#import "AnnouncementViewController.h"
@interface ImportantItemsListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NetManger *manger;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *m_datas;
@end

@implementation ImportantItemsListViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    manger = [NetManger shareInstance];
    [manger loadData:RequestOfGetpersonaldatearrangepagelist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloaddatas) name:@"getpersonaldatearrangepagelist" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

#pragma mark - 设置navigationItem右侧按钮
    UIButton *meassageBut = ({
        UIButton *meassageBut = [UIButton buttonWithType:UIButtonTypeCustom];
        meassageBut.frame = CGRectMake(0, 0, 40, 20);
        meassageBut.titleLabel.font = [UIFont systemFontOfSize:15];
        [meassageBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [meassageBut addTarget:self action:@selector(addActionBtn) forControlEvents:UIControlEventTouchDown];
        [meassageBut setTitle:@"发表" forState:UIControlStateNormal];
        meassageBut;
    });
    
    UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithCustomView:meassageBut];
    self.navigationItem.rightBarButtonItem = rBtn;
}
- (void)reloaddatas
{
    [_m_datas removeAllObjects];
    for (NSDictionary *dic in manger.importantItemsLisr)
    {
        ImportantItemsListModel *model = [ImportantItemsListModel mj_objectWithKeyValues:dic];
        if (!_m_datas) {
            _m_datas = [NSMutableArray array];
        }
        [_m_datas addObject:model];
    }
    [self setTableView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 69) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //iOS 8开始的自适应高度，可以不需要实现定义高度的方法
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [_tableView.header endRefreshing];
    }];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [_tableView.footer endRefreshing];
    }];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _m_datas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ImportantItemsListModel *model = _m_datas[indexPath.row];
    ImportantItemsListCell *cell = [ImportantItemsListCell selectedCell:tableView];
    cell.titleLab.text = [NSString stringWithFormat:@"标题: %@",model.ArrangeTItle];
    cell.contextLab.text = [NSString stringWithFormat:@"内容: %@",model.Content];
    cell.timeLab.text = model.CreateDateStr;
    cell.tag = [model.ID integerValue];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ImportantItemsListCell *cell = (ImportantItemsListCell*)[tableView cellForRowAtIndexPath:indexPath];
    AnnouncementViewController *sub = [[AnnouncementViewController alloc] init];
    sub.titleStr = [NSString stringWithFormat:@"%@\n%@",cell.titleLab.text,cell.timeLab.text];
    sub.context = cell.contextLab.text;
    sub.title = @"详细内容";
    manger.ID = [NSString stringWithFormat:@"%ld",cell.tag];
    [manger loadData:RequestOfReadsave];
    [self.navigationController pushViewController:sub animated:YES];
}
- (void)addActionBtn
{
    ImportantItemsBulidViewController *sub = [[ImportantItemsBulidViewController alloc] init];
    sub.title = @"发布重要事项";
    [self.navigationController pushViewController:sub animated:YES];

    
}
@end

//
//  SigninSelectProjectViewController.m
//  MedicalCRM
//
//  Created by admin on 16/8/25.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "SigninSelectProjectViewController.h"
#import "ProjectInfoController.h"
#import "ProjectMangerCell.h"
#import "MJRefresh.h"
#import "NetManger.h"
#import "GetprojectpagelistModel.h"
#import "ProjectBuildViewController.h"
#import "FiltrateView.h"
#import "SeachViewController.h"

#import "ProjectBuildViewController.h"
#import "MJExtension.h"
#import "MyProjectListModel.h"
@interface SigninSelectProjectViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NetManger *manger;
}
@property (nonatomic, strong) NSMutableArray *m_datas;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SigninSelectProjectViewController
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
    manger.keywork = self.keywork;
    manger.sType2 = @"";
    manger.ID = _CustId;
    [manger loadData:RequestOfGetMyprojectpagelist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDatas) name:@"getmyprojectpagelist" object:nil];
}
- (void)reloadDatas
{
    [_m_datas removeAllObjects];
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
    
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
    bg.backgroundColor = [UIColor clearColor];
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    lb.text = @"以上是公司与该客户的所有项目，是否申报新的项目?";
    lb.font = [UIFont systemFontOfSize:11];
    lb.textAlignment = NSTextAlignmentCenter;
    [bg addSubview:lb];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(40,100-45,ScreenWidth-80,40);
    btn.backgroundColor = [UIColor orangeColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.layer.cornerRadius = 5;
    [btn setTitle:@"申报项目" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buildProject) forControlEvents:UIControlEventTouchDown];
    [bg addSubview:btn];
    self.tableView.tableFooterView = bg;
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section// 返回组的头宽
{
    return 5;
}
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
    MyProjectListModel *model = _m_datas[indexPath.row];
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (model.LinkTel.length == 0)
    {
        model.LinkTel = @"";
    }
    if (model.CanViewUserName.length == 0)
    {
        model.CanViewUserName = @"";
    }
    if (model.DepartmentName)
    {
        model.DepartmentName = @"无";
    }
    if (cell.textLabel.text.length != 0 )
    {

        if (self.block)
        {

            self.block(model.ProjectName,model.ProjectDirectionName,model.CustLinkMan,model.LinkTel,model.SuccessRate,model.Investment,model.CanViewUserName,model.ID);
        }
    }
    else
    {
        NSLog(@"nil");
    }

//    NSArray *datas= @[model.ProjectName,model.ProjectDirectionName,model.CustLinkMan,model.LinkTel,model.SuccessRate,model.Investment,model.CanViewUserName,model.ID,model.DepartmentName,model.CustName];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"SigninSelectProjectViewController" object:datas];
//    int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
//    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index -2)] animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 
- (void)buildProject
{
    ProjectBuildViewController *sub = [[ProjectBuildViewController alloc] init];
    sub.title = @"申报项目";
    [self.navigationController pushViewController:sub animated:YES];

}
@end

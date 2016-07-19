//
//  ProjectMangerViewController.m
//  MedicalCRM
//
//  Created by admin on 16/7/13.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "ProjectMangerViewController.h"
#import "ProjectInfoController.h"
#import "ProjectMangerCell.h"

#import "NetManger.h"
#import "GetprojectpagelistModel.h"
@interface ProjectMangerViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NetManger *manger;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ProjectMangerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    manger = [NetManger shareInstance];
    manger.sType = self.sType;
    [manger loadData:RequestOfgetprojectpagelist];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDatas) name:@"getprojectpagelist" object:nil];
    [self setTableView];
    
    if (self.isPayManger) {
#pragma mark - 设置navigationItem右侧按钮
        UIButton *meassageBut = ({
            UIButton *meassageBut = [UIButton buttonWithType:UIButtonTypeCustom];
            meassageBut.frame = CGRectMake(0, 0, 20, 20);
//            [meassageBut addTarget:self action:@selector(pushMSG) forControlEvents:UIControlEventTouchDown];
            [meassageBut setTitle:@"特别审批" forState:UIControlStateNormal];
            meassageBut;
        });
        
        UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithCustomView:meassageBut];
        self.navigationItem.rightBarButtonItem = rBtn;
    }
}
- (void)reloadDatas
{
    [self.tableView reloadData];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return manger.getprojectpagelist.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
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
    ProjectMangerCell *cell = [ProjectMangerCell selectedCell:tableView];
    if (self.isPayManger) {
        if (indexPath.row%2)
        {
            cell.stateLab.text = @"申请中";
        }
        else
        {
            cell.stateLab.text = @"申请被拒";
            cell.stateLab.textColor = [UIColor redColor];
        }
    }
    GetprojectpagelistModel *model = manger.getprojectpagelist[indexPath.row];
    cell.nameLab.text = model.ProjectName;
    cell.ProjectNo.text = model.ProjectNo;
    cell.timeLab.text = model.CreateDate;
    cell.custorLab.text = model.CustLinkMan;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectInfoController *sub = [[ProjectInfoController alloc] init];
    sub.title = @"项目详细";
    [self.navigationController pushViewController:sub animated:YES];

}
@end

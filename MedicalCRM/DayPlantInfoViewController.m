//
//  DayPlantInfoViewController.m
//  MedicalCRM
//
//  Created by admin on 16/8/4.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "DayPlantInfoViewController.h"
#import "DayPlantInfoCell.h"
@interface DayPlantInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *titles;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation DayPlantInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    titles = @[@"标题",@"工作方向",@"开始时间",@"结束时间",@"计划类型",@"计划内容"];
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
    self.tableView.rowHeight = 60;
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
    return titles.count;
}
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DayPlantInfoCell *cell = [DayPlantInfoCell selectedCell:tableView];
    cell.titleLab.text = [NSString stringWithFormat:@"%@",titles[indexPath.row]];
    cell.contextLab.text = [NSString stringWithFormat:@"%@",self.datas[indexPath.row]];
    return cell;
}

@end

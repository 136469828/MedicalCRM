//
//  AuditClassViewController.m
//  MedicalCRM
//
//  Created by admin on 16/8/4.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "AuditClassViewController.h"
#import "AuditBuildViewController.h"
#import "CostAuditingViewController.h"
#import "AuditListViewController.h"
#import "StockUpListViewController.h"
@interface AuditClassViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *titles;
}
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation AuditClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    titles = @[@"样机审核",@"费用审核",@"备货审核"];
    [self setTableView];
}
#pragma mark -
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 69) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //iOS 8开始的自适应高度，可以不需要实现定义高度的方法
//    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = 44;
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
    static NSString *allCell = @"cell";
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:allCell];
        cell.selectionStyle = UITableViewCellAccessoryNone;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",titles[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 0)
    {
        AuditListViewController *sub = [[AuditListViewController alloc] init];
        sub.title = cell.textLabel.text;
        [self.navigationController pushViewController:sub animated:YES];

    }
    else if(indexPath.row == 1)
    {
        CostAuditingViewController *sub = [[CostAuditingViewController alloc] init];
        sub.title = cell.textLabel.text;
        [self.navigationController pushViewController:sub animated:YES];
    }
    else
    {
        StockUpListViewController *sub = [[StockUpListViewController alloc] init];
        sub.title = cell.textLabel.text;
        [self.navigationController pushViewController:sub animated:YES];

    }

   

}
@end

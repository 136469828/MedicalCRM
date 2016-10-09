//
//  AssessmentViewController.m
//  MedicalCRM
//
//  Created by admin on 16/8/3.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "AssessmentViewController.h"
#import "NetManger.h"
#import "FeedbackController.h"
@interface AssessmentViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *titles;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation AssessmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    titles = @[@[@"成功率"],@[@"负责项目数",@"完成项目数"],@[@"工作计划数",@"工作达标数"]];
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
    if (section == 0) {
        return 1;
    }
    return 2;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView // 一个表视图里面有多少组
{
    return 3;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section // 返回组的头宽
//{
//    return 5;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section // 返回组的尾宽
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *allCell = @"cell";
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:allCell];
        cell.selectionStyle = UITableViewCellAccessoryNone;
    }
    UILabel *dataLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*0.28, 0, ScreenWidth-ScreenWidth*0.28-10, 44)];
    dataLab.text = @"5";
    dataLab.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:dataLab];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",titles[indexPath.section][indexPath.row]];
    return cell;
}
- (void)pushBulidCtr
{
    FeedbackController *sub = [[FeedbackController alloc] init];
    sub.title = @"意见反馈";
    [self.navigationController pushViewController:sub animated:YES];
    
}
@end

//
//  EnterpriseCultureViewController.m
//  MedicalCRM
//
//  Created by admin on 16/8/3.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "EnterpriseCultureViewController.h"
#import "SubEnterpriseCultureViewController.h"
@interface EnterpriseCultureViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *titles;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation EnterpriseCultureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    titles = @[@"企业内刊",@"规章制度",@"信息共享"];
    [self setTableView];
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
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:allCell];
        cell.selectionStyle = UITableViewCellAccessoryNone;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",titles[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SubEnterpriseCultureViewController *sub = [[SubEnterpriseCultureViewController alloc] init];
    sub.title = @"详情";
    sub.ID = indexPath.row+9;
    [self.navigationController pushViewController:sub animated:YES];

}
@end

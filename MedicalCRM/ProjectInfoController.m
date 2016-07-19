//
//  ProjectInfoController.m
//  MedicalCRM
//
//  Created by admin on 16/7/15.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "ProjectInfoController.h"
#import "ProjectInfoCell.h"
#import "ProjectInfo2Cell.h"
@interface ProjectInfoController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *datas;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ProjectInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    datas = @[@"项目跟踪: 申请样机中",@"备注:\n    （中关村在线江苏行情）98英寸“巨幕级”大屏显示器LG 98LS95A极尽高端奢华，LG潜心研发的这款新品尺寸达98英寸，拥有3840*2160的4K超高清分辨率，不仅颠覆了传统的消费理念，还实现了极佳的体验改善。今日在“南京电盈电子”到货，售398000元，需要的朋友可以与商家联系购买。"];
    [self setTableView];
}
#pragma mark -
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
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
    if (section == 2) {
        return 2;
    }
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView // 一个表视图里面有多少组
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section // 返回组的头宽
{
    if (section == 1) {
        return 5;
    }
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section // 返回组的尾宽
{

    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ProjectInfo2Cell *cell2 = [ProjectInfo2Cell selectedCell:tableView];
        return cell2;
    }
    else if (indexPath.section == 1)
    {
        ProjectInfoCell *cell = [ProjectInfoCell selectedCell:tableView];
        return cell;
    }
    static NSString *allCell = @"cell";
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:allCell];
        cell.selectionStyle = UITableViewCellAccessoryNone;
    }
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = datas[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    return cell;
}

@end

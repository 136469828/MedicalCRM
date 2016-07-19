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
@interface CustlinkmanlistViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NetManger *manger;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation CustlinkmanlistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    manger = [NetManger shareInstance];
    manger.customID = [NSString stringWithFormat:@"%ld",self.ID];
    [manger loadData:RequestOfGetcustlinkmanlist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloDatas) name:@"getcustlinkmanlist" object:nil];
    [self setTableView];
}
- (void)reloDatas
{
    [self.tableView reloadData];
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
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSArray *datas = @[[NSString stringWithFormat:@"%ld",self.ID],[NSString stringWithFormat:@"%ld",cell.tag],[NSString stringWithFormat:@" %@ %@",self.custom,cell.textLabel.text]];

    UIViewController *viewCtl = self.navigationController.viewControllers[2];
    [self.navigationController popToViewController:viewCtl animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cuNameStr" object:datas];
}
@end

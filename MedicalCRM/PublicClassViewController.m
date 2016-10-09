//
//  PublicClassViewController.m
//  MedicalCRM
//
//  Created by admin on 16/7/23.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "PublicClassViewController.h"
#import "NetManger.h"
#import "PublictypelistModel.h"
#import "PayClassViewController.h"
@interface PublicClassViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NetManger *manger;
}
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation PublicClassViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    manger = [NetManger shareInstance];
    manger.sType = @"4";
    [manger loadData:RequestOfGetcodepublictypelist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodatas) name:@"getcodepublictypelist" object:nil];
    [self setTableView];
}
- (void)relodatas
{
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return manger.publictypelist.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *allCell = @"cell";
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:allCell];
        cell.selectionStyle = UITableViewCellAccessoryNone;
    }
    PublictypelistModel *model = manger.publictypelist[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",model.ID,model.TypeName];
    cell.tag = [model.ID integerValue];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    PayClassViewController *sub = [[PayClassViewController alloc] init];
    sub.ID = [NSString stringWithFormat:@"%ld",cell.tag];
    [self.navigationController pushViewController:sub animated:YES];

}
@end

//
//  PayClassViewController.m
//  MedicalCRM
//
//  Created by admin on 16/7/26.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "PayClassViewController.h"
#import "NetManger.h"
#import "FeetypelistModel.h"
@interface PayClassViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NetManger *manger;
}
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation PayClassViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    manger = [NetManger shareInstance];
    manger.ID = self.ID;
    [manger loadData:RequestOfGetcodefeetypelist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodatas) name:@"getcodefeetypelist" object:nil];
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
    return manger.getcodefeetypelist.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *allCell = @"cell";
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:allCell];
        cell.selectionStyle = UITableViewCellAccessoryNone;
    }
    FeetypelistModel *model = manger.getcodefeetypelist[indexPath.row];
    UILabel *tagLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    tagLb.text = [NSString stringWithFormat:@"%@,%@,%@",model.ID,model.CodeName,self.ID];
    tagLb.tag = 2000+indexPath.row;
    [cell.contentView addSubview:tagLb];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",model.ID,model.CodeName];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    UILabel *lb = (UILabel *)[tableView viewWithTag:2000+indexPath.row];
    UIViewController *viewCtl = self.navigationController.viewControllers[2];
    [self.navigationController popToViewController:viewCtl animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"classStr" object:lb.text];

}

@end

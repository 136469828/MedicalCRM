//
//  DayPlanClassController.m
//  MedicalCRM
//
//  Created by admin on 16/8/2.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "DayPlanClassController.h"
#import "NetManger.h"
#import "PublictypelistModel.h"
@interface DayPlanClassController ()
{
    NetManger *manger;
}
@end

@implementation DayPlanClassController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //    titles = @[@"3D解剖",@"一键式医疗系统",@"数字减影血管造影(DSA)",@"智能阅片",@"其他"];
    manger = [NetManger shareInstance];
    manger.sType = @"6";
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
- (void)setTableView{
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    _tableView.delegate   = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma  mark - tableDelegate
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
    cell.textLabel.text = [NSString stringWithFormat:@"%@",model.TypeName];
    cell.tag = [model.ID integerValue];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    JCKLog(@"%@ %ld",cell.textLabel.text,cell.tag);
    // 回调
    if (cell.textLabel.text.length != 0 )
    {
        if (self.block)
        {
            self.block([NSString stringWithFormat:@"%@,%ld",cell.textLabel.text,cell.tag]);
        }
    }
    else
    {
        NSLog(@"nil");
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end

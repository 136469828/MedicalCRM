//
//  LifeNavigationListController.m
//  MedicalCRM
//
//  Created by admin on 16/8/8.
//  Copyright © 2016年 JCK. All rights reserved.
// RequestOfGetpersonaldatearrangepagelist

#import "LifeNavigationListController.h"
#import "MJExtension.h"
#import "NetManger.h"
#import "LifeNavigationListModel.h"
@interface LifeNavigationListController ()<UITableViewDataSource,UITableViewDelegate>
{
    NetManger *manger;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation LifeNavigationListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    manger = [NetManger shareInstance];
    [manger loadData:RequestOfGetemployeenav];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDatas) name:@"getemployeenav" object:nil];
}
- (void)reloadDatas
{
//    JCKLog(@"%@",manger.lifeDic);
    JCKLog(@"%@",manger.lifeDic[@"data"][@"TotalMineMoneyByYear"]);//年度财富
    JCKLog(@"%@",manger.lifeDic[@"data"][@"TotalMineMoneyByFuture"]);//未来财富
    JCKLog(@"%@",manger.lifeDic[@"data"][@"TeamCountByYear"]);//成就多少人
    JCKLog(@"%@",manger.lifeDic[@"data"][@"TeamCountByFuture"]);//未来成就多少人
    JCKLog(@"%@",manger.lifeDic[@"data"][@"ChanceTypeList"]);//领域目标
    JCKLog(@"%@",manger.lifeDic[@"data"][@"VisitCountByDay"]);//每天拜访多少人
    JCKLog(@"%@",manger.lifeDic[@"data"][@"VisitCountByYear"]);//年度拜访多少人
    JCKLog(@"%@",manger.lifeDic[@"data"][@"CustomCountByYear"]);//客户成为合伙人
    JCKLog(@"%@",manger.lifeDic[@"data"][@"ProjectCountByYear"]);//年度项目数
    JCKLog(@"%@",manger.lifeDic[@"data"][@"SaleMoneyByYear"]);//年度销售数
    JCKLog(@"%@",manger.lifeDic[@"data"][@"ProjectMoneyByYear"]);//年度成果数
    JCKLog(@"%@",manger.lifeDic[@"data"][@"CreateDate"]);//创建时间
    
    LifeNavigationListModel *model = [LifeNavigationListModel shareInstance];
    
    model.TotalMineMoneyByYear = manger.lifeDic[@"data"][@"TotalMineMoneyByYear"];
    model.TotalMineMoneyByFuture = manger.lifeDic[@"data"][@"TotalMineMoneyByFuture"];
    model.TeamCountByYear = manger.lifeDic[@"data"][@"TeamCountByYear"];
    model.TeamCountByFuture = manger.lifeDic[@"data"][@"TeamCountByFuture"];
    model.ChanceTypeList = manger.lifeDic[@"data"][@"ChanceTypeList"];
    model.VisitCountByDay = manger.lifeDic[@"data"][@"VisitCountByDay"];
    model.VisitCountByYear = manger.lifeDic[@"data"][@"VisitCountByYear"];
    model.CustomCountByYear = manger.lifeDic[@"data"][@"CustomCountByYear"];
    model.ProjectCountByYear = manger.lifeDic[@"data"][@"ProjectCountByYear"];
    model.SaleMoneyByYear = manger.lifeDic[@"data"][@"SaleMoneyByYear"];
    model.ProjectMoneyByYear = manger.lifeDic[@"data"][@"ProjectMoneyByYear"];
    model.CreateDate = manger.lifeDic[@"data"][@"CreateDate"];
    model.ChanceTypeList = manger.lifeDic[@"data"][@"ChanceTypeList"];
    JCKLog(@"%@",model);

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

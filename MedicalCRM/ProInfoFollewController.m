//
//  ProInfoFollewController.m
//  MedicalCRM
//
//  Created by admin on 16/7/29.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "ProInfoFollewController.h"
#import "ProInfo3Cell.h"
#import "ProInfoFollewModel.h"
#import "FuntionObj.h"
@interface ProInfoFollewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *m_data;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ProInfoFollewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     self.view.backgroundColor = RGB(236, 237, 245);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    JCKLog(@"%@",self.datas);
    for (NSDictionary *dic in self.datas)
    {
        //        JCKLog(@"%@",dic[@"Rate"]);
        ProInfoFollewModel *model = [[ProInfoFollewModel alloc] init];
        if ([FuntionObj isNullDic:dic Key:@"Rate"])
        {
            NSString *str = dic[@"Rate"];
            model.Rate = [NSString stringWithFormat:@"%.1f%%",[str floatValue]*100.0f];
        }
        else
        {
            model.Rate = @" ";
        }
        if ([FuntionObj isNullDic:dic Key:@"SummaryName"])
        {
           model.SummaryName = dic[@"SummaryName"];
        }
        else
        {
             model.SummaryName = @"无";
        }
        if ([FuntionObj isNullDic:dic Key:@"ProcessScale"])
        {
            model.ProcessScale = dic[@"ProcessScale"];
        }
        else
        {
            model.ProcessScale = @" ";
        }
        if ([FuntionObj isNullDic:dic Key:@"PersonNum"])
        {
            model.PersonNum = dic[@"PersonNum"];
        }
        else
        {
            model.PersonNum = @" ";
        }
        model.BeginDate = dic[@"BeginDate"];
        model.EndDate = dic[@"EndDate"];
        
        if (!_m_data) {
            _m_data = [NSMutableArray array];
        }
        [_m_data addObject:model];
    }
    [self setTableView];
}
#pragma mark -
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 69) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 150;
    _tableView.backgroundColor = RGB(236, 237, 245);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    bg.backgroundColor = RGB(236, 237, 245);
    _tableView.tableFooterView = bg;
    [self.view addSubview:_tableView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _m_data.count;
}
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProInfoFollewModel *model = _m_data[indexPath.row];
    ProInfo3Cell *cell = [ProInfo3Cell selectedCell:tableView Data:model];
    return cell;
}
@end

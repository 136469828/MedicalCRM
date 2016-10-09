//
//  MyteamInfoViewController.m
//  MedicalCRM
//
//  Created by admin on 16/8/12.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "MyteamInfoViewController.h"
#import "MJExtension.h"
#import "NetManger.h"
#import "MyTeamInfoModel.h"
#import "MyTeamInfoCell.h"
#import "UIImageView+WebCache.h"
@interface MyteamInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NetManger *manger;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *m_datas;

@end

@implementation MyteamInfoViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    manger = [NetManger shareInstance];
    manger.ID = self.ID;
    [manger loadData:RequestOfGetemployeeteam];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodatas) name:@"getemployeeteam" object:nil];
}
- (void)relodatas
{
    for (NSDictionary *dic in manger.myTeamInfos)
    {
        MyTeamInfoModel *model = [MyTeamInfoModel mj_objectWithKeyValues:dic];
        if (!_m_datas) {
            _m_datas = [NSMutableArray array];
        }
        [_m_datas addObject:model];
    }
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
    self.tableView.rowHeight = 60;
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
    return _m_datas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTeamInfoCell *cell = [MyTeamInfoCell selectedCell:tableView];
    if (_m_datas)
    {
        MyTeamInfoModel *model = _m_datas[indexPath.row];
        cell.nameLab.text  = model.PersonName;
        cell.suLab.hidden = YES; //text  = [NSString stringWithFormat:@"[%@]%@",model.DeptName,model.QuarterName];
//        [cell.imgV sd_setImageWithURL:[NSURL URLWithString:model.PhotoURL]];
        cell.imgV.image = [UIImage imageNamed:@"f5test"];
    }
//    cell.textLabel.text = @"无成员";
    return cell;
}
@end

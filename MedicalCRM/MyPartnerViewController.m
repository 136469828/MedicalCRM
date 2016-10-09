//
//  MyPartnerViewController.m
//  MedicalCRM
//
//  Created by admin on 16/8/30.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "MyPartnerViewController.h"
#import "NetManger.h"
#import "TeamMenberModel.h"
#import "MJExtension.h"
#import "AddMyPartnerViewController.h"
#import "TeamInfoViewController.h"
@interface MyPartnerViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NetManger *manger;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *m_datas;
@property (nonatomic, strong) NSMutableArray *m_Namedatas;
@end

@implementation MyPartnerViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    [manger loadData:RequestOfGetpersonallinkmanpagelist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodatas) name:@"getpersonallinkmanpagelist" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!manger)
    {
        manger = [NetManger shareInstance];
        manger.sType = @"1";
        manger.sType2 = @"0";
        [manger loadData:RequestOfGetpersonallinkmanpagelist];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodatas) name:@"getpersonallinkmanpagelist" object:nil];
    }
#pragma mark - 设置navigationItem右侧按钮
    UIButton *meassageBut = ({
        UIButton *meassageBut = [UIButton buttonWithType:UIButtonTypeCustom];
        meassageBut.frame = CGRectMake(0, 0, 20, 20);
        [meassageBut addTarget:self action:@selector(bulidAction) forControlEvents:UIControlEventTouchDown];
        [meassageBut setImage:[UIImage imageNamed:@"addIcon"]forState:UIControlStateNormal];
        meassageBut;
    });
    
    UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithCustomView:meassageBut];
    self.navigationItem.rightBarButtonItem = rBtn;
    
}
- (void)relodatas
{
    [_m_datas removeAllObjects];
    [_m_Namedatas removeAllObjects];
    for (NSDictionary *dic in manger.getpersonallinkmanpagelists)
    {
        TeamMenberModel *model = [TeamMenberModel mj_objectWithKeyValues:dic];
        if (!_m_datas ) {
            _m_datas = [NSMutableArray array];
        }
        [_m_datas addObject:model];
        if (!_m_Namedatas ) {
            _m_Namedatas = [NSMutableArray array];
        }
        [_m_Namedatas addObject:dic[@"LinkmanName"]];
    }
    if (_m_datas.count == 0)
    {
        //初始化提示框；
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"暂无我的一伙人信息,请添加" preferredStyle: UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //点击按钮的响应事件；
        }]];
        
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }
    else
    {
        [self setTableView];
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _m_datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *allCell = @"cell";
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:allCell];
        cell.selectionStyle = UITableViewCellAccessoryNone;
    }
    TeamMenberModel *model = _m_datas[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.text = model.LinkmanName;
    cell.detailTextLabel.text = model.CompanyName;
    return cell;
}
-
(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TeamMenberModel *model = _m_datas[indexPath.row];
    TeamInfoViewController *sub = [[TeamInfoViewController alloc] init];
    sub.title = @"联系人详情";
    sub.model = model;
    [self.navigationController pushViewController:sub animated:YES];
    
}
- (void)bulidAction
{
    JCKLog(@"%@",_m_Namedatas);
    AddMyPartnerViewController *sub = [[AddMyPartnerViewController alloc] init];
    sub.title = @"添加我的一伙人";
    sub.names = _m_Namedatas;
    [self.navigationController pushViewController:sub animated:YES];
    
}@end

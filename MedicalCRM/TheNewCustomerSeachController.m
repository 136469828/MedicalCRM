//
//  TheNewCustomerSeachController.m
//  MedicalCRM
//
//  Created by admin on 16/8/18.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "TheNewCustomerSeachController.h"
#import "NetManger.h"
#import "MJExtension.h"
#import "TheNewCustomer.h"
#import "MJRefresh.h"
#import "TheNewCustomerListCell.h"
#import "TheNewCustomInfoViewController.h"
#import "CustlinkmansaveViewController.h"
#import "KeyboardToolBar.h"
@interface TheNewCustomerSeachController ()<UITableViewDataSource,UITableViewDelegate>
{
    NetManger *manger;
    NSArray *data;
    NSArray *filterData;
    UITextField *tf;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *m_datas;
@property (nonatomic, strong) NSMutableArray *m_seachdatas;


@end

@implementation TheNewCustomerSeachController
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
    UIButton *meassageBut = ({
        UIButton *meassageBut = [UIButton buttonWithType:UIButtonTypeCustom];
        meassageBut.frame = CGRectMake(0, 0, 40, 20);
        meassageBut.titleLabel.font = [UIFont systemFontOfSize:15];
        [meassageBut setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [meassageBut addTarget:self action:@selector(seaChBtn) forControlEvents:UIControlEventTouchDown];
        [meassageBut setTitle:@"搜索" forState:UIControlStateNormal];
        meassageBut;
    });
    
    UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithCustomView:meassageBut];
    self.navigationItem.rightBarButtonItem = rBtn;
    tf = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth*0.6, 25)];
    tf.placeholder = @"请输入...";
    tf.font = [UIFont systemFontOfSize:12];
    tf.backgroundColor = RGB(245, 245, 245);
    tf.layer.cornerRadius = 5;
    tf.layer.borderColor = RGB(245, 245, 245).CGColor;
    tf.layer.borderWidth = 1;
    tf.layer.masksToBounds = YES;
    [KeyboardToolBar registerKeyboardToolBar:tf];
    [tf becomeFirstResponder];
    self.navigationItem.titleView = tf;
    [self setTableView];
}
- (void)relodatas
{
    [_m_datas removeAllObjects];
    for (NSDictionary *dic in manger.theNewCustomList)
    {
        TheNewCustomer *model = [TheNewCustomer mj_objectWithKeyValues:dic];
        if (!_m_datas)
        {
            _m_datas = [NSMutableArray array];
        }
        [_m_datas addObject:model];
        if (!_m_seachdatas)
        {
            _m_seachdatas = [NSMutableArray array];
        }
        [_m_seachdatas addObject:[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",model.LinkManName,model.WorkTel,model.ID,model.CustName,model.Position,model.Department]];
    }
    [self setTableView];
}
#pragma mark -
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 69) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TheNewCustomerListCell *cell = [TheNewCustomerListCell selectedCell:tableView];
    TheNewCustomer *model = _m_datas[indexPath.row];
    cell.nameLab.text = model.LinkManName;
    cell.phoneLab.text = model.WorkTel;
    cell.tagLab.text = model.ID;
    cell.CompanyName.text = model.CustName;
    cell.zhiwuLab.text = model.Position;
    cell.keshiLab.text = model.Department;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    TheNewCustomerListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    TheNewCustomInfoViewController *sub = [[TheNewCustomInfoViewController alloc] init];
    sub.title = @"客户详情";
    sub.ID = cell.tagLab.text;
    [self.navigationController pushViewController:sub animated:YES];

}
- (void)seaChBtn
{
    manger = [NetManger shareInstance];
    manger.keywork = tf.text;
    manger.PageSize = @"10";
    [manger loadData:RequestOfGetminelinkmanpagelist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodatas) name:@"getminelinkmanpagelist" object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [tf resignFirstResponder];
    manger.theNewCustomList = nil;
}
@end

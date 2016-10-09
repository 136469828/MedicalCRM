//
//  SigninSelectCustomerViewController.m
//  MedicalCRM
//
//  Created by admin on 16/8/31.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "SigninSelectCustomerViewController.h"
#import "NetManger.h"
#import "MJExtension.h"
#import "TheNewCustomer.h"
#import "MJRefresh.h"
#import "TheNewCustomerListCell.h"
#import "TheNewCustomInfoViewController.h"
#import "CustlinkmansaveViewController.h"
#import "TheNewCustomerSeachController.h"
#import "SigninSelectProjectViewController.h"
#import "KeyboardToolBar.h"
@interface SigninSelectCustomerViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NetManger *manger;
    NSArray *data;
    NSArray *filterData;
    int pag;
    UITextField *seachTextField;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *m_datas;
@property (nonatomic, strong) NSMutableArray *m_seachdatas;

@end

@implementation SigninSelectCustomerViewController
// 销毁通知中心
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    manger = [NetManger shareInstance];
    manger.keywork = @"";
    pag = 10;
    manger.PageSize =[NSString stringWithFormat:@"%d",pag];
    [manger loadData:RequestOfGetminelinkmanpagelist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodatas) name:@"getminelinkmanpagelist" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    [self setTableView];
}
- (void)relodatas
{
    [_m_datas removeAllObjects];
    [_m_seachdatas removeAllObjects];
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
        if (model.Position.length == 0)
        {
            model.Position = @"";
        }
        [_m_seachdatas addObject:[NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@",model.LinkManName,model.WorkTel,model.ID,model.CustName,model.Position,model.Department]];
    }
    [_tableView reloadData];
}
#pragma mark -
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 69) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //iOS 8开始的自适应高度，可以不需要实现定义高度的方法
    //    self.tableView.estimatedRowHeight = 200;
    //    self.tableView.rowHeight = 60;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [_tableView reloadData];
        [_tableView.header endRefreshing];
    }];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        pag = pag +30;
        manger.keywork = @"";
        manger.PageSize =[NSString stringWithFormat:@"%d",pag];
        [manger loadData:RequestOfGetminelinkmanpagelist];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodatas) name:@"getminelinkmanpagelist" object:nil];
        [_tableView.footer endRefreshing];
    }];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.tableView setBackgroundColor:RGB(239, 239, 244)];
    [self.view addSubview:_tableView];
    [self hearView];
}
#pragma mark - tableView头视图
- (void)hearView{
    
    UIView *hearView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    //    hearView.backgroundColor = [UIColor redColor];
    seachTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 13, SCREEN_WIDTH - 80, 25)];
    seachTextField.layer.borderColor = [UIColor lightGrayColor].CGColor; // set color as you want.
    seachTextField.layer.borderWidth = 1.0; // set borderWidth as you want.
    seachTextField.layer.cornerRadius=8.0f;
    seachTextField.layer.masksToBounds=YES;
    seachTextField.font = [UIFont systemFontOfSize:13];
    seachTextField.backgroundColor = [UIColor whiteColor];
    [KeyboardToolBar registerKeyboardToolBar:seachTextField];
    [hearView addSubview:seachTextField];
    
    UIButton *seachBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [seachBtn setTitle:@"搜索" forState:UIControlStateNormal];
    seachBtn.frame = CGRectMake(SCREEN_WIDTH - 55, 13, 40, 25);
    seachBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    seachBtn.layer.borderColor = [UIColor lightGrayColor].CGColor; // set color as you want.
    seachBtn.layer.borderWidth = 1.0; // set borderWidth as you want.
    seachBtn.layer.cornerRadius=5.0f;
    seachBtn.layer.masksToBounds=YES;
    seachBtn.backgroundColor = [UIColor whiteColor];
    [seachBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [seachBtn addTarget:self action:@selector(seachOnSeach) forControlEvents:UIControlEventTouchDown];
    [hearView addSubview:seachBtn];
    _tableView.tableHeaderView = hearView;
    
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
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TheNewCustomerListCell *cell = [TheNewCustomerListCell selectedCell:tableView];
    TheNewCustomer *model = _m_datas[indexPath.row];
    cell.nameLab.text = model.LinkManName;
    cell.phoneLab.text = model.WorkTel;
    cell.tagLab.text = model.ID;
    if ([model.CustName isEqualToString:@"待定"])
    {
        model.CustName = @"";
    }
    cell.CompanyName.text = model.CustName;
    cell.zhiwuLab.text = model.Position;
    cell.keshiLab.text = model.Department;
    
//    UIButton *btnTop = [UIButton buttonWithType:UIButtonTypeCustom];
//    btnTop.frame = CGRectMake(ScreenWidth-90, 28, 60, 20);
//    btnTop.layer.cornerRadius = 3;
//    btnTop.backgroundColor = [UIColor orangeColor];
//    btnTop.titleLabel.font = [UIFont systemFontOfSize:11];
//    btnTop.tag = [model.ID integerValue];
//    cell.tag = [model.ID integerValue];
//    [btnTop setTitle:@"友情拜访" forState:UIControlStateNormal];
//    [btnTop setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btnTop addTarget:self action:@selector(popSignin:) forControlEvents:UIControlEventTouchDown];
//    [cell.contentView addSubview:btnTop];
//    
//    UIButton *btnBottom = [UIButton buttonWithType:UIButtonTypeCustom];
//    btnBottom.frame = CGRectMake(ScreenWidth-90, 100-30, 60, 20);
//    btnBottom.layer.cornerRadius = 3;
//    btnBottom.titleLabel.font = [UIFont systemFontOfSize:11];
//    btnBottom.backgroundColor = [UIColor orangeColor];
//    btnBottom.tag = [model.ID integerValue];
//    cell.tag = [model.ID integerValue];
//    [btnBottom setTitle:@"合作项目" forState:UIControlStateNormal];
//    [btnBottom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btnBottom addTarget:self action:@selector(pushProList:) forControlEvents:UIControlEventTouchDown];
//    [cell.contentView addSubview:btnBottom];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TheNewCustomerListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.block)
    {
        // NSString *name,NSString *tel,NSString *CompanyName,NSString *department,NSString *position,NSString *ID
        self.block(cell.nameLab.text,cell.phoneLab.text,cell.CompanyName.text,cell.keshiLab.text,cell.zhiwuLab.text,[NSString stringWithFormat:@"%ld",cell.tag]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)seachOnSeach
{
    manger.keywork = seachTextField.text;
    [manger loadData:RequestOfGetminelinkmanpagelist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodatas) name:@"getminelinkmanpagelist" object:nil];
}
- (void)pushProList:(UIButton *)btn
{
    TheNewCustomerListCell *cell = (TheNewCustomerListCell *)[_tableView viewWithTag:btn.tag];
    JCKLog(@"%@ %@",cell.nameLab.text,cell.tagLab.text);
    SigninSelectProjectViewController *sub = [[SigninSelectProjectViewController alloc] init];
    sub.title = [NSString stringWithFormat:@"%@的相关项目",cell.nameLab.text];
    sub.keywork = cell.nameLab.text;
    sub.block = ^(NSString *name,NSString *projectDirectionName,NSString *custor,NSString *tel,NSString *success,NSString *price,NSString *CanViewUserName,NSString *ID)
    {
        //                self.projectFild.text = [str substringFromIndex:4];
        //                proId = ID;
        JCKLog(@"%@ - %@ - %@ - %@ - %@ - %@ - %@",name,projectDirectionName,custor,tel,success,price,ID);
    };

    [self.navigationController pushViewController:sub animated:YES];
}
- (void)popSignin:(UIButton *)btn
{
    TheNewCustomerListCell *cell = (TheNewCustomerListCell *)[_tableView viewWithTag:btn.tag];
    if (self.block)
    {
        self.block(cell.nameLab.text,cell.phoneLab.text,cell.CompanyName.text,cell.keshiLab.text,cell.zhiwuLab.text,[NSString stringWithFormat:@"%ld",cell.tag]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)bulidAction
{
    CustlinkmansaveViewController *sub = [[CustlinkmansaveViewController alloc] init];
    sub.title = @"新建客户档案";
    [self.navigationController pushViewController:sub animated:YES];
    
}
@end

//
//  MyPayViewController.m
//  MedicalCRM
//
//  Created by admin on 16/7/14.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "MyPayViewController.h"
#import "MyPayCell.h"
#import "FeeapplysaveViewController.h"
#import "NetManger.h"
#import "MJExtension.h"
#import "PayListModel.h"
#import "FuntionObj.h"
#import "MyPayInfoViewController.h"
#import "MJRefresh.h"
#import "KeyboardToolBar.h"
@interface MyPayViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int pag;
    NetManger *manger;
    NSMutableArray *data;
    NSArray *filterData;
    UIScrollView *mainScrollView;
    UITextField *seachTextField;
//    UISearchDisplayController *searchDisplayController;
}
@property (nonatomic, strong) NSMutableArray *m_datas;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation MyPayViewController
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
    pag = 10;
    manger.keywork = @"";
    manger.PageSize = [NSString stringWithFormat:@"%d",pag];
    [manger loadData:RequestOfGetfeeapplypagelist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodatas) name:@"getfeeapplypagelist" object:nil];
    [self setTableView];
//#pragma mark - 设置navigationItem右侧按钮
//    UIButton *meassageBut = ({
//        UIButton *meassageBut = [UIButton buttonWithType:UIButtonTypeCustom];
//        meassageBut.frame = CGRectMake(0, 0, 20, 20);
//        [meassageBut addTarget:self action:@selector(pushPuCctr) forControlEvents:UIControlEventTouchDown];
//        [meassageBut setImage:[UIImage imageNamed:@"addIcon"]forState:UIControlStateNormal];
//        meassageBut;
//    });
//    
//    UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithCustomView:meassageBut];
//    self.navigationItem.rightBarButtonItem = rBtn;
}
- (void)relodatas
{
    [_m_datas removeAllObjects];
    [data removeAllObjects];
    for (NSDictionary *dic in manger.feeapplypagelist) {
        PayListModel *model = [PayListModel mj_objectWithKeyValues:dic];
        if (!_m_datas) {
            _m_datas = [NSMutableArray array];
        }
        [_m_datas addObject:model];
        if ([FuntionObj isNullDic:dic Key:@"Title"])
        {
            model.Title = dic[@"Title"];
        }
        else
        {
            model.Title = @"未填写";
        }
        if (!data) {
            data = [NSMutableArray array];
        }
        [data addObject:model.Title];
    }

    [_tableView reloadData];
}

#pragma mark -
- (void)setTableView
{
    // setScrollView
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth, ScreenHeight - 49-0)];
    mainScrollView.contentSize = CGSizeMake(418, ScreenHeight - 49-40);
    [self.view addSubview:mainScrollView];

    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 418, ScreenHeight-64 ) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        pag = pag + 5;
        manger.keywork = @"";
        manger.PageSize = [NSString stringWithFormat:@"%d",pag];
        [manger loadData:RequestOfGetfeeapplypagelist];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodatas) name:@"getfeeapplypagelist" object:nil];
        [_tableView.footer endRefreshing];
    }];
    //iOS 8开始的自适应高度，可以不需要实现定义高度的方法
//    self.tableView.estimatedRowHeight = 200;
//    self.tableView.rowHeight = 150;
//    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width
//                                                                           , 44)];
//    searchBar.placeholder = @"搜索";
//    
//    // 添加 searchbar 到 headerview
//    self.tableView.tableHeaderView = searchBar;
//    
//    // 用 searchbar 初始化 SearchDisplayController
//    // 并把 searchDisplayController 和当前 controller 关联起来
//    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
//    
//    // searchResultsDataSource 就是 UITableViewDataSource
//    searchDisplayController.searchResultsDataSource = self;
//    // searchResultsDelegate 就是 UITableViewDelegate
//    searchDisplayController.searchResultsDelegate = self;
    [self hearView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [mainScrollView addSubview:_tableView];
}
#pragma mark - tableView头视图
- (void)hearView{
    
    UIView *hearView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    //    hearView.backgroundColor = [UIColor redColor];
    seachTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 5, SCREEN_WIDTH - 80, 30)];
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
    seachBtn.frame = CGRectMake(SCREEN_WIDTH - 55, 5, 40, 30);
    seachBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    seachBtn.layer.borderColor = [UIColor lightGrayColor].CGColor; // set color as you want.
    seachBtn.layer.borderWidth = 1.0; // set borderWidth as you want.
    seachBtn.layer.cornerRadius=5.0f;
    seachBtn.layer.masksToBounds=YES;
    seachBtn.backgroundColor = [UIColor whiteColor];
    [seachBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [seachBtn addTarget:self action:@selector(seachOnSeach) forControlEvents:UIControlEventTouchDown];
    [hearView addSubview:seachBtn];
    [self.view addSubview:hearView];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _m_datas.count+1;
//    if (tableView == self.tableView) {
//        return _m_datas.count;
//    }else{
//        // 谓词搜索
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@",searchDisplayController.searchBar.text];
//        filterData =  [[NSArray alloc] initWithArray:[data filteredArrayUsingPredicate:predicate]];
//        return filterData.count;
//    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section // 返回组的头宽
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 31;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyPayCell *cell = [MyPayCell selectedCell:tableView];
    if (indexPath.row != 0)
    {
        PayListModel *model = _m_datas[indexPath.row - 1];
        cell.resonLab.text = model.Reason;
        cell.titleLab.text = model.Title;
        cell.needTime.text = model.ProjectName;
        cell.createTime.text = [model.CreateDate substringToIndex:16];
        cell.priceLab.text = [NSString stringWithFormat:@"￥%@",model.TotalAmount];
        cell.CreatorName.text = model.CreatorName;//[NSString stringWithFormat:@"申请人:
        cell.stateLab.text = model.FlowStatusName;
        cell.titleLab.text = data[indexPath.row-1];
        cell.tag = [model.ID integerValue];
    }
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0)
    {
        MyPayCell *cell =[tableView cellForRowAtIndexPath:indexPath];
        MyPayInfoViewController *sub = [[MyPayInfoViewController alloc] init];
        sub.title = @"报销详情";
        sub.ID = [NSString stringWithFormat:@"%ld",cell.tag];
        [self.navigationController pushViewController:sub animated:YES];

    }
   
}
- (void)pushPuCctr
{
    FeeapplysaveViewController *sub = [[FeeapplysaveViewController alloc] init];
    sub.title = @"报销申请";
    [self.navigationController pushViewController:sub animated:YES];

}
- (void)seachOnSeach
{
    pag = 15;
    manger.PageSize = [NSString stringWithFormat:@"%d",pag];
    manger.keywork = seachTextField.text;
    [manger loadData:RequestOfGetfeeapplypagelist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodatas) name:@"getfeeapplypagelist" object:nil];
}
@end

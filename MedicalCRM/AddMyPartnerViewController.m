//
//  AddMyPartnerViewController.m
//  MedicalCRM
//
//  Created by admin on 16/8/30.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "AddMyPartnerViewController.h"
#import "NetManger.h"
#import "MJExtension.h"
#import "AddMyPartnerModel.h"
#import "MJRefresh.h"
#import "AddMyPartnerCell.h"
#import "TheNewCustomInfoViewController.h"
#import "CustlinkmansaveViewController.h"
#import "TheNewCustomerSeachController.h"

//#import "FriendListRightCell.h"
#import "FriendListModel.h"
#import <RongIMKit/RongIMKit.h>
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "AllGroupSelectViewController.h"
#import "ChatLinkManInfoViewController.h"
#import "KeyboardToolBar.h"
@interface AddMyPartnerViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

{
    NetManger *manger;
    NSArray *data;
    NSArray *filterData;
    int selectCount;
    UITextField *seachTextField;
    int pag;
}
@property (nonatomic, strong) UITableView *m_tableView;
@property (nonatomic ,strong) NSMutableArray *m_fansListsArray;
@property (nonatomic, strong) NSMutableArray *m_dateArray;
@property (nonatomic, strong) NSMutableArray *m_date;
@property (nonatomic, strong) NSMutableArray *m_IDdate;
@property (nonatomic, strong) NSMutableArray *m_Position;
@property (nonatomic, strong) NSMutableArray *m_Department;
@property (nonatomic, strong) NSMutableArray *m_parArr;
@end

@implementation AddMyPartnerViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
}
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    manger = [NetManger shareInstance];
    manger.keywork = @"";
    pag = 999;
    manger.PageSize = [NSString stringWithFormat:@"%d",pag];
    [manger loadData:RequestOfGetminelinkmanpagelists];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createTableView) name:@"getminelinkmanpagelist" object:nil];
    //    [self createTableView];
    [_m_date removeAllObjects];
    [_m_IDdate removeAllObjects];
    if (_m_date == nil)
    {
        _m_date = [NSMutableArray array];
    }
    if (_m_IDdate == nil)
    {
        _m_IDdate = [NSMutableArray array];
    }
    if (_m_Department == nil)
    {
        _m_Department = [NSMutableArray array];
    }
    if (_m_Position == nil)
    {
        _m_Position = [NSMutableArray array];
    }
    
}


- (NSMutableArray *)m_fansListsArray
{
    if (_m_fansListsArray == nil)
    {
        _m_fansListsArray = [NSMutableArray array];
    }
    return _m_fansListsArray;
    
}

- (void)createTableView
{
    _m_dateArray = nil;
    if (_m_dateArray == nil)
    {
        _m_dateArray = [NSMutableArray array];
        for (int i = 0; i<manger.getminelinkmanpagelists.count; i++)
        {
            AddMyPartnerModel *fansModel = manger.getminelinkmanpagelists[i];
            if ([_names containsObject:fansModel.LinkManName])
            {
                fansModel.m_chooseBtn = YES;
            }
            [_m_dateArray addObject:fansModel];
        }
    }
    [_m_date addObjectsFromArray:_names];
    self.m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    self.m_tableView.delegate = self;
    self.m_tableView.dataSource = self;
    [self.m_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:self.m_tableView];
    self.m_tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        pag ++;
        manger.PageSize = [NSString stringWithFormat:@"%d",pag];
        [manger loadData:RequestOfGetminelinkmanpagelists];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createTableView) name:@"getminelinkmanpagelist" object:nil];
        [_m_tableView.footer endRefreshing];
    }];
    self.m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
#pragma mark - 设置navigationItem右侧按钮
    UIButton *meassageBut = ({
        UIButton *meassageBut = [UIButton buttonWithType:UIButtonTypeCustom];
        meassageBut.frame = CGRectMake(0, 0, 35, 20);
        meassageBut.titleLabel.font = [UIFont systemFontOfSize:15];
        [meassageBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [meassageBut addTarget:self action:@selector(popCtr) forControlEvents:UIControlEventTouchDown];
        [meassageBut setTitle:@"确认"  forState:UIControlStateNormal];
        meassageBut;
    });
    UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithCustomView:meassageBut];
    self.navigationItem.rightBarButtonItem = rBtn;
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
    _m_tableView.tableHeaderView = hearView;
    
}
//- (NSMutableArray *)m_dateArray
//{
//    
//    if (_m_dateArray == nil)
//    {
//        _m_dateArray = [NSMutableArray array];
//        
//        for (int i = 0; i<manger.getminelinkmanpagelists.count; i++)
//        {
//            AddMyPartnerModel *fansModel = manger.getminelinkmanpagelists[i];
//            [_m_dateArray addObject:fansModel];
//        }
//    }
//    
//    return _m_dateArray;
//}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.m_tableView)
    {
        return self.m_dateArray.count;
    }
    else
    {
        //        // 谓词搜索
        //        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@",searchDisplayController.searchBar.text];
        //        filterData =  [[NSArray alloc] initWithArray:[_m_date filteredArrayUsingPredicate:predicate]];
        //        return filterData.count;
        filterData = _m_dateArray;
        return filterData.count;
    }
    //    return self.m_dateArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section  // 返回一个UIView作为头视图
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
    bgView.backgroundColor = [UIColor whiteColor];
    UIButton *friendInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    friendInfoBtn.frame = CGRectMake(12,0,ScreenWidth-12,60);
    friendInfoBtn.backgroundColor = [UIColor clearColor];
    [friendInfoBtn addTarget:self action:@selector(friendInfoBtnAction) forControlEvents:UIControlEventTouchDown];
    [bgView addSubview:friendInfoBtn];
    UILabel *selcetLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, ScreenWidth-12, 60)];
    selcetLab.tag = 8888;
    selcetLab.numberOfLines = 0;
    if (_m_date.count != 0) {
        NSString *ns=[_m_date componentsJoinedByString:@","];
        selcetLab.text = [NSString stringWithFormat:@"您添加的一伙人为: %@",ns];
    }
    else
    {
        
        NSString *ns=[_names componentsJoinedByString:@","];
        if (ns.length == 0)
        {
            ns = @"";
        }
        selcetLab.text = [NSString stringWithFormat:@"您添加的一伙人为: %@",ns];
    }
    
    selcetLab.font = [UIFont systemFontOfSize:13];
    [bgView addSubview: selcetLab];
    //    bgView.backgroundColor = [UIColor redColor];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 60-1, ScreenWidth, 1)];
    line.backgroundColor = RGB(234, 234, 234);
    [bgView addSubview:line];

    return bgView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddMyPartnerCell *cell = [AddMyPartnerCell selectedCell:tableView];
    cell.tagLab.hidden = YES;
    if (tableView == self.m_tableView)
    {
        AddMyPartnerModel *model = self.m_dateArray[indexPath.row];
        if (model.m_chooseBtn)
        {
            cell.selectedBtn.selected = NO;
            [cell rowSelected];
            //            [cell.selectedBtn setBackgroundImage:[UIImage imageNamed:@"score_icon_select.png"] forState:UIControlStateSelected];
        }
        cell.nameLab.text = model.LinkManName;
        cell.tagLab.text = [NSString stringWithFormat:@"%@",model.ID];
        cell.zhiwuLab.text = model.Operation;
        cell.partMentLab.text = model.Department;
        cell.phoneLab.text = [NSString stringWithFormat:@"%@",model.WorkTel];
        cell.companyLab.text = model.CustName;
        return cell;
    }
    else
    {
        AddMyPartnerModel *model = self.m_dateArray[indexPath.row];
        if (model.m_chooseBtn)
        {
            cell.selectedBtn.selected = NO;
            [cell rowSelected];
            //            [cell.selectedBtn setBackgroundImage:[UIImage imageNamed:@"score_icon_select.png"] forState:UIControlStateSelected];
        }
        cell.nameLab.text = model.LinkManName;
        cell.tagLab.text = [NSString stringWithFormat:@"%@",model.ID];
        cell.zhiwuLab.text = model.Operation;
        cell.partMentLab.text = model.Department;
        cell.phoneLab.text = [NSString stringWithFormat:@"%@",model.WorkTel];
        cell.companyLab.text = model.CustName;
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.m_tableView)
    {
        [self.m_tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        AddMyPartnerCell *cell = (AddMyPartnerCell *)[self.m_tableView cellForRowAtIndexPath:indexPath];
        AddMyPartnerModel *model = self.m_dateArray[indexPath.row];
        model.m_chooseBtn = !model.isChooseBtn;
        if (model.m_chooseBtn)
        { //选择了
            NSString *str = [NSString stringWithFormat:@"%@",model.LinkManName];
            NSString *str2 = [NSString stringWithFormat:@"%@",model.ID];
            [self.m_date addObject:str];
            [self.m_IDdate addObject:str2];
//            [self.m_fansListsArray addObject:model.ID];
//            [self.m_Department addObject:model.Department];
//            [self.m_Position addObject:model.Operation];
            
        }
        else
        { //取消
            NSString *str = [NSString stringWithFormat:@"%@",model.LinkManName];
            NSString *str2 = [NSString stringWithFormat:@"%@",model.ID];
            [self.m_date removeObject:str];
            [self.m_IDdate removeObject:str2];
            [self.m_fansListsArray removeObject:model.ID];
//            [self.m_Department removeObject:model.Department];
//            [self.m_Position removeObject:model.Operation];
            
        }
        
        [cell rowSelected];
        
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        AddMyPartnerCell *cell = (AddMyPartnerCell *)[self.m_tableView cellForRowAtIndexPath:indexPath];
        AddMyPartnerModel *model = self.m_dateArray[indexPath.row];
        model.m_chooseBtn = !model.isChooseBtn;
        if (model.m_chooseBtn)
        { //选择了
            NSString *str = [NSString stringWithFormat:@"%@",model.LinkManName];
            NSString *str2 = [NSString stringWithFormat:@"%@",model.ID];
            [self.m_date addObject:str];
            [self.m_IDdate addObject:str2];
            [self.m_fansListsArray addObject:model.ID];
            
        }
        else
        { //取消
            NSString *str = [NSString stringWithFormat:@"%@",model.LinkManName];
            [self.m_date removeObject:str];
            [self.m_fansListsArray removeObject:model.ID];
            
        }
        
        [cell rowSelected];
        
    }
    if (_m_date.count % 4)
    {
        selectCount ++;
    }
    NSString *ns=[_m_date componentsJoinedByString:@","];
    UILabel *lb = (UILabel *)[tableView viewWithTag:8888];
    lb.text = [NSString stringWithFormat:@"您添加的一伙人为: %@",ns];
    NSLog(@"%@ %@",self.m_fansListsArray,_m_date);
}

- (void)bulidAction
{
    CustlinkmansaveViewController *sub = [[CustlinkmansaveViewController alloc] init];
    sub.title = @"新建客户档案";
    [self.navigationController pushViewController:sub animated:YES];
    
}
- (void)pushSeachVC
{
    TheNewCustomerSeachController *sub = [[TheNewCustomerSeachController alloc] init];
    [self.navigationController pushViewController:sub animated:YES];
    
}
- (void)popCtr
{
    /*
     CompanyName
     CompanyPhone
     Email
     LinkmanName
     MobilePhone
     Sex
     Position
     */
    JCKLog(@"%@ \n %@",_names,_m_date);
    NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",_m_date];
    //过滤数组
    NSArray * reslutFilteredArray = [_names filteredArrayUsingPredicate:filterPredicate];
    NSLog(@"Reslut Filtered Array = %@",reslutFilteredArray);
    [_m_parArr removeAllObjects];
    
    for (int i = 0; i<_m_IDdate.count; i++)
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:_m_date[i] forKey:@"LinkmanName"];
        [dic setObject:@"0" forKey:@"IsDeleted"];
        [dic setObject:_m_IDdate[i] forKey:@"LinkEmployeeID"];
        [dic setObject:@"1" forKey:@"LinkmanType"];

        if (!_m_parArr) {
            _m_parArr = [NSMutableArray array];
        }
//        [dic setObject:_m_Position forKey:@"Position"];
//        [dic setObject:_m_date forKey:@""];
//        [dic setObject:_m_date forKey:@""];]
        [_m_parArr addObject:dic];
    }
    if (_m_parArr)
    {
        manger.sType = @"1";
        manger.personallinkmansavebatchs = _m_parArr;
        [manger loadData:RequestOfPersonallinkmansavebatch];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popCtrs) name:@"personallinkmansavebatch" object:nil];
    }
   
}
- (void)seachOnSeach
{
    manger.keywork = seachTextField.text;
    manger.PageSize = [NSString stringWithFormat:@"%d",pag];
    [manger loadData:RequestOfGetminelinkmanpagelists];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createTableView) name:@"getminelinkmanpagelist" object:nil];
}
- (void)popCtrs
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)friendInfoBtnAction
{    //初始化提示框；
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"等待接口" preferredStyle: UIAlertControllerStyleAlert];
//    
//    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        //点击按钮的响应事件；
//    }]];
//    
//    //弹出提示框；
//    [self presentViewController:alert animated:true completion:nil];
}
@end

//
//  EquipmentListViewController.m
//  MedicalCRM
//
//  Created by admin on 16/7/22.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "EquipmentListViewController.h"
#import "NetManger.h"
#import "MJRefresh.h"
#import "EquipmentListModel.h"
#import "EquipmentListCell.h"
@interface EquipmentListViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

{
    NetManger *manger;
    NSArray *data;
    NSArray *filterData;
    int selectCount;
    
}
@property (nonatomic, strong) UITableView *m_tableView;
@property (nonatomic ,strong) NSMutableArray *m_fansListsArray;
@property (nonatomic, strong) NSMutableArray *m_dateArray;
@property (nonatomic, strong) NSMutableArray *m_date;
@property (nonatomic, strong) NSMutableArray *m_IDdate;
@end

@implementation EquipmentListViewController
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
    [manger loadData:RequestOfGetproductpagelist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createTableView) name:@"getproductpagelist" object:nil];
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
    self.m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    self.m_tableView.delegate = self;
    self.m_tableView.dataSource = self;
    [self.m_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:self.m_tableView];
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

}

- (NSMutableArray *)m_dateArray
{
    
    if (_m_dateArray == nil)
    {
        _m_dateArray = [NSMutableArray array];
        
        for (int i = 0; i<manger.equipmentLists.count; i++)
        {
            EquipmentListModel *selcetModel = manger.equipmentLists[i];
            [_m_dateArray addObject:selcetModel];
        }
    }
    
    return _m_dateArray;
}


#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EquipmentListCell *cell = [EquipmentListCell selectedCell:tableView];
    //    cell.tagLab.hidden = YES;
    EquipmentListModel *model = self.m_dateArray[indexPath.row];
    if (model.m_chooseBtn)
    {
        cell.selectedBtn.selected = NO;
        [cell rowSelected];
        //            [cell.selectedBtn setBackgroundImage:[UIImage imageNamed:@"score_icon_select.png"] forState:UIControlStateSelected];
    }
    cell.tag = [model.ID integerValue];
    cell.titleLab.text = model.ProductName;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.m_tableView)
    {
        [self.m_tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        EquipmentListCell *cell = (EquipmentListCell *)[self.m_tableView cellForRowAtIndexPath:indexPath];
        EquipmentListModel *model = self.m_dateArray[indexPath.row];
        model.m_chooseBtn = !model.isChooseBtn;
        if (model.m_chooseBtn)
        { //选择了
            NSString *str = [NSString stringWithFormat:@"%@",model.ProductName];
            NSString *str2 = [NSString stringWithFormat:@"%@",model.ID];
            [self.m_date addObject:str];
            [self.m_IDdate addObject:str2];
            [self.m_fansListsArray addObject:model.ID];
            
        }
        else
        { //取消
            NSString *str = [NSString stringWithFormat:@"%@",model.ProductName];
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
    lb.text = [NSString stringWithFormat:@"您添加的机型为: %@",ns];
    NSLog(@"%@ %@",self.m_fansListsArray,_m_date);
    [self popCtr];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_dateArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section  // 返回一个UIView作为头视图
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
    bgView.backgroundColor = [UIColor whiteColor];
//    UIButton *friendInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    friendInfoBtn.frame = CGRectMake(12,0,ScreenWidth-12,60);
//    friendInfoBtn.backgroundColor = [UIColor clearColor];
//    [friendInfoBtn addTarget:self action:@selector(friendInfoBtnAction) forControlEvents:UIControlEventTouchDown];
//    [bgView addSubview:friendInfoBtn];
    UILabel *selcetLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, ScreenWidth-12, 60)];
    selcetLab.tag = 8888;
    selcetLab.numberOfLines = 0;
    if (_m_date.count != 0) {
        NSString *ns=[_m_date componentsJoinedByString:@","];
        selcetLab.text = [NSString stringWithFormat:@"您添加的机型为: %@",ns];
    }
    else
    {
        selcetLab.text = @"您添加的机型为:";
    }
    
    selcetLab.font = [UIFont systemFontOfSize:13];
    [bgView addSubview: selcetLab];
    //    bgView.backgroundColor = [UIColor redColor];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 60-1, ScreenWidth, 1)];
    line.backgroundColor = RGB(234, 234, 234);
    [bgView addSubview:line];
    
    return bgView;
}


- (void)popCtr
{
    if (_m_fansListsArray.count != 0 )
    {
        if (self.block)
        {
            self.block(_m_date,_m_fansListsArray);
        }
    }
    else
    {
        NSLog(@"nil");
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)friendInfoBtnAction
{    //初始化提示框；
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"等待接口" preferredStyle: UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
    
}

@end

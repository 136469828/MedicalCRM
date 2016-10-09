//
//  MyPayInfoViewController.m
//  MedicalCRM
//
//  Created by admin on 16/8/12.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "MyPayInfoViewController.h"
#import "NetManger.h"
#import "MJExtension.h"
#import "MyPayInfoModel.h"
#import "FuntionObj.h"
@interface MyPayInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NetManger *manger;
    NSString *projcetStr;
    NSString *counts;
    //    NSString *counts;
    NSMutableArray *Details;
}
@property (nonatomic, strong) NSMutableArray *m_datas;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MyPayInfoViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    manger = [NetManger shareInstance];
    manger.ID = self.ID;
    [manger loadData:RequestOfGetfeeapply];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodatas) name:@"getfeeapply" object:nil];
}
- (void)relodatas
{

    NSArray *datas = manger.myPayInfos[@"Details"];
    
    for (NSDictionary *dic in datas)
    {
        if (Details == nil)
        {
            Details = [[NSMutableArray alloc] initWithCapacity:0];
        }
        NSString *ExpTypeName = @"";
        if ([FuntionObj isNullDic:dic Key:@"ExpTypeName"])
        {
            ExpTypeName = dic[@"ExpTypeName"];
        }
        [Details addObject:[NSString stringWithFormat:@"%@: ￥%@",ExpTypeName,dic[@"Amount"]]];
    }
    JCKLog(@"%@",Details);
    [self setTableView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark -
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 69) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //iOS 8开始的自适应高度，可以不需要实现定义高度的方法
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView // 一个表视图里面有多少组
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return 2+Details.count;
    }
    else if (section == 2)
    {
        return 3;
    }
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section  // 返回组的头宽
{
    return 9;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section // 返回组的尾宽
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *allCell = @"cell";
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:allCell];
        cell.selectionStyle = UITableViewCellAccessoryNone;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.numberOfLines = 0;
//    MyPayInfoModel *model = manger.myPayInfos[0];
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        
        cell.textLabel.text = [NSString stringWithFormat:@"标题: %@",manger.myPayInfos[@"Title"]];
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            cell.textLabel.text = [NSString stringWithFormat:@"项目名: %@",manger.myPayInfos[@"ProjectName"]];
        }
        else if (indexPath.row == 1)
        {
            cell.textLabel.textColor = [UIColor orangeColor];
            cell.textLabel.text = [NSString stringWithFormat:@"总报销金额: %@",manger.myPayInfos[@"TotalAmount"]];
        }
        else
        {
            cell.textLabel.textColor = [UIColor orangeColor];
            cell.textLabel.text = Details[indexPath.row - 2]; //BUG
        }
        
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            cell.textLabel.text = [NSString stringWithFormat:@"申请时间: %@",manger.myPayInfos[@"AriseDate"]];
        }
        else if (indexPath.row == 1)
        {
            cell.textLabel.textColor = RGB(77, 188, 251);
            cell.textLabel.text = [NSString stringWithFormat:@"申请人: %@",manger.myPayInfos[@"CreatorName"]];
        }
        else
        {
            NSString *Reason = @"";
            if ([FuntionObj isNullDic:manger.myPayInfos Key:@"Reason"])
            {
                Reason = manger.myPayInfos[@"Reason"];
            }
            cell.textLabel.text = [NSString stringWithFormat:@"报销原因: %@",Reason];
        }
        
    }
    return cell;
}

@end

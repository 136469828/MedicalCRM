//
//  TheNewCustomInfoViewController.m
//  MedicalCRM
//
//  Created by admin on 16/8/11.
//  Copyright © 2016年 JCK. All rights reserved.
//RequestOfGetlinkman _getlinkmans

#import "TheNewCustomInfoViewController.h"
#import "TheNewCustomer.h"
#import "MJExtension.h"
#import "NetManger.h"
#import "FuntionObj.h"
@interface TheNewCustomInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *title;
    NetManger *manger;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *m_datas;
@end

@implementation TheNewCustomInfoViewController
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
    [manger loadData:RequestOfGetlinkman];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDatas) name:@"getlinkman" object:nil];
//    NSString *sex;
//    if ([self.model.Sex isEqualToString:@"1"]) {
//        sex = @"男";
//    }
//    else
//    {
//        sex = @"女";
//    }
//    if (!self.model.Department)
//    {
//        self.model.Department = @"";
//    }
//    if (!self.model.Position)
//    {
//        self.model.Position = @"无";
//    }
//    title = @[[NSString stringWithFormat:@"姓        名:  %@ [%@]",self.model.LinkManName,self.model.Position],
//              [NSString stringWithFormat:@"工作电话: %@",self.model.WorkTel],
//              [NSString stringWithFormat:@"性        别:  %@",sex],
//              [NSString stringWithFormat:@"医院/公司:  %@",self.model.CustName],
//              [NSString stringWithFormat:@"科         室:  %@",self.model.Department]];
    
}
- (void)reloadDatas
{
    NSDictionary *dic = (id)manger.getlinkmans;
    TheNewCustomer *model = [TheNewCustomer mj_objectWithKeyValues:manger.getlinkmans];
    NSString *sex ;

    if ([FuntionObj isNullDic:dic Key:@"Sex"])
    {
        if ([dic[@"Sex"] isEqualToString:@"1"]) {
            sex = @"男";
        }
        else
        {
            sex = @"女";
        }
    }
    else
    {
        sex = @"";
    }

    if (!model.Department)
    {
        model.Department = @"";
    }
    if (!model.Position)
    {
        model.Position = @"";
    }
    if ([model.CustName isEqualToString:@"待定"])
    {
        model.CustName = @"";
    }
    title = @[[NSString stringWithFormat:@"姓        名:  %@",model.LinkManName],
              [NSString stringWithFormat:@"工作电话: %@",model.WorkTel],
              [NSString stringWithFormat:@"性        别:  %@",sex],
              [NSString stringWithFormat:@"医院/公司:  %@",model.CustName],
              [NSString stringWithFormat:@"科         室:  %@",model.Department],
              [NSString stringWithFormat:@"职         务:  %@",model.Position],];

    JCKLog(@"%@",dic[@"LinkManName"]);

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
    self.tableView.rowHeight = 44;
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
    return title.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *allCell = @"cell";
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:allCell];
        cell.selectionStyle = UITableViewCellAccessoryNone;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",title[indexPath.row]];
    return cell;
}

@end

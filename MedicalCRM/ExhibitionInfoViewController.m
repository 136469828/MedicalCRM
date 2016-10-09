//
//  ExhibitionInfoViewController.m
//  MedicalCRM
//
//  Created by admin on 16/8/11.
//  Copyright © 2016年 JCK. All rights reserved.
//getsellexhibition RequestOfGetsellexhibition

#import "ExhibitionInfoViewController.h"
#import "MJExtension.h"
#import "ExhibitionInfoModel.h"
#import "NetManger.h"
#import "ExhibitionInfoCell.h"
@interface ExhibitionInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NetManger *manger;
    NSArray *titles;
    NSArray *contexts;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *m_datas;
@end

@implementation ExhibitionInfoViewController
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
    manger.ID = self.Id;
    [manger loadData:RequestOfGetsellexhibition];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDatas) name:@"getsellexhibition" object:nil];
    
}
- (void)reloadDatas
{
//    manger.zhanhuiInfos
    ExhibitionInfoModel *model = [ExhibitionInfoModel mj_objectWithKeyValues:manger.zhanhuiInfos];
    titles =  @[@[@"标题: "],
                 @[ @"联系人",
                  @"联系电话: "],
                
                @[@"开始日期:",
                  @"结束日期: ",
                  @"规模人数: ",
                  @"费用总投资: "],
                
                @[@"展会目的: ",
                  @"展会计划: ",
                  @"合作伙伴: ",
                  @"竞争对手: "]];

    contexts = @[@[model.Title],
                   @[model.LinkManName,
                   model.LinkTel],
                 
               @[model.ExhibitionStartDate,
                 model.ExhibitionEndDate,
                 model.AttendPersons,
                 [NSString stringWithFormat:@"%@ 万元",model.TotalMoney]],
                 
               @[model.ExhibitionAim,
                 model.ExhibitionPlan,
                 model.UnionPartner,
                 model.Competitors]];
    [self setTableView];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [titles[section] count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView// 一个表视图里面有多少组
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExhibitionInfoCell *cell = [ExhibitionInfoCell selectedCell:tableView];
    cell.titleLab.text = [NSString stringWithFormat:@"%@",titles[indexPath.section][indexPath.row]];
    cell.contextLab.text = [NSString stringWithFormat:@"%@",contexts[indexPath.section][indexPath.row]];
    if (indexPath.section == 2 && indexPath.row == 3)
    {
        cell.contextLab.textColor = [UIColor orangeColor];
    }
//    if (indexPath.section == 1 && indexPath.row == 2)
//    {
//        UIButton *phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        phoneBtn.frame = CGRectMake(ScreenWidth-60,0,44,44);
//        phoneBtn.backgroundColor = [UIColor redColor];
//        [phoneBtn addTarget:self action:@selector(phoneBtnAction:) forControlEvents:UIControlEventTouchDown];
//        phoneBtn.tag = [cell.contextLab.text integerValue];
//        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
//        img.image = [UIImage imageNamed:@"客户电话"];
//        [phoneBtn addSubview:img];
//        [cell.contentView addSubview:phoneBtn];
//    }
    return cell;
}
- (void)phoneBtnAction:(UIButton *)btn
{
    if (btn.tag != 0)
    {
        NSString *num = [[NSString alloc] initWithFormat:@"tel://%ld",btn.tag]; //number为号码字符串
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
    }

}
@end

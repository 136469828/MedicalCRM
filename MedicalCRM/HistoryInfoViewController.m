//
//  HistoryInfoViewController.m
//  MedicalCRM
//
//  Created by admin on 16/8/5.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "HistoryInfoViewController.h"
#import "HistoryCell.h"
#import "HistoryInfoCell.h"
#import "NetManger.h"
#import "HistoryInfoModel.h"
#import "MJExtension.h"
#import "FuntionObj.h"
#import "SigninModel.h"
@interface HistoryInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NetManger *manger;
    NSMutableArray *data;
    int pag;
    NSString *hospitalName;
    NSString *LinkManname;
    NSString *LinkManTel;
    NSMutableArray *feeapply;
    NSArray *Amounts;
    NSMutableArray *mfeeapplys;
    
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation HistoryInfoViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self setTableView];
    _ProName = @"";
    [SigninModel tearDown];
    manger = [NetManger shareInstance];
    manger.ID = _ID;
    [manger loadData:RequestOfGetcustinfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloDatas) name:@"getcustinfo" object:nil];
    
}
- (void)reloDatas
{
//    manger.getcustinfoDic
    [data removeAllObjects];
//    JCKLog(@"%@",manger.getcustinfoDic);
    if ([FuntionObj isNullDic:manger.getcustinfoDic Key:@"CustName"])
    {
        hospitalName = manger.getcustinfoDic[@"CustName"];
    }
    else
    {
        hospitalName = @"";
    }
    NSArray *Contracts = manger.getcustinfoDic[@"Contracts"];
    NSArray *LinMans = manger.getcustinfoDic[@"LinMans"];
    NSArray *Projects = manger.getcustinfoDic[@"Projects"];
    for (NSDictionary *dic in Contracts)
    {
        HistoryInfoModel *model = [HistoryInfoModel mj_objectWithKeyValues:dic];
        if (!data)
        {
            data = [NSMutableArray array];
            
        }
        JCKLog(@"%@",model.feeapply[@"Details"]);
        NSArray *feeapplys = model.feeapply[@"Details"];
        int i = 0;
        [mfeeapplys removeAllObjects];
        for (NSDictionary *dic in feeapplys)
        {
            JCKLog(@"%@ %@",dic[@"ExpTypeName"] ,dic[@"Amount"]);
            if (!mfeeapplys)
            {
                mfeeapplys = [NSMutableArray array];
            }
//            NSString *tagstr;
//            if (i%2)
//            {
//                tagstr = @"";
//            }
//            else
//            {
//                tagstr = @"\n";
//            }
            [mfeeapplys addObject:[NSString stringWithFormat:@"%@:%@",dic[@"ExpTypeName"],dic[@"Amount"]]];
//            i ++;
//            switch (i) {
//                case 1:
//                {
//                    
//                    model.FeeApplyTravelCount = [NSString stringWithFormat:@"%@",dic[@"Amount"] ];
//                }
//                    break;
//                case 2:
//                {
//                    model.FeeApplyAccommodationCount = [NSString stringWithFormat:@"%@",dic[@"Amount"]];
//                }
//                    break;
//                case 3:
//                {
//                    model.FeeApplyGiftCount = [NSString stringWithFormat:@"%@",dic[@"Amount"]];
//                }
//                    break;
//                case 4:
//                {
//                    model.FeeApplyOtherCount = [NSString stringWithFormat:@"%@",dic[@"Amount"]];
//                }
//                    break;
//                    
//                default:
//                    break;
//            }
            
        }
//        JCKLog(@"%@",mfeeapplys);
        model.price = [mfeeapplys componentsJoinedByString:@","];
//        if (!model.FeeApplyTravelCount) {
//            model.FeeApplyTravelCount = @"0";
//        }
//        if (!model.FeeApplyAccommodationCount) {
//            model.FeeApplyAccommodationCount = @"0";
//        }
//        if (!model.FeeApplyGiftCount) {
//            model.FeeApplyGiftCount = @"0";
//        }
//        if (!model.FeeApplyOtherCount) {
//            model.FeeApplyOtherCount = @"0";
//        }
        [data addObject:model];
        
    }
    if (LinMans.count == 0)
    {
        LinkManname = @"";
        LinkManTel = @"";
    }
    for (NSDictionary *dic in LinMans)
    {
        JCKLog(@"%@ %@",dic[@"LinkManName"],dic[@"WorkTel"]);
        LinkManname = dic[@"LinkManName"];
        if (!LinkManname)
        {
            LinkManname = @"";
        }
        LinkManTel = dic[@"WorkTel"];
        if (!LinkManTel)
        {
            LinkManTel = @"";
        }
        break;
    }
    for (NSDictionary *dic in Projects)
    {
        _ProName = dic[@"ProjectName"];
        break;
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
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
    [self setTop];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setTop
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 70)];
    UILabel *hospitalNameLab = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, ScreenWidth, 20)];
    hospitalNameLab.text = [NSString stringWithFormat:@"医院名: %@",hospitalName];
    hospitalNameLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    [bgView addSubview:hospitalNameLab];
    UILabel *proNameLab = [[UILabel alloc] initWithFrame:CGRectMake(8, 30, ScreenWidth, 20)];
    proNameLab.text = [NSString stringWithFormat:@"项目名:%@",_ProName];
    proNameLab.font = [UIFont systemFontOfSize:13];
    [bgView addSubview:proNameLab];
    UILabel *linkManLab = [[UILabel alloc] initWithFrame:CGRectMake(8, 50, ScreenWidth/2-10, 20)];
    linkManLab.text = [NSString stringWithFormat:@"联系人: %@",LinkManname];
    linkManLab.font = [UIFont systemFontOfSize:13];
    [bgView addSubview:linkManLab];
    UILabel *linkManTelLab = [[UILabel alloc] initWithFrame:CGRectMake(8+ScreenWidth/2, 50, ScreenWidth/2-10, 20)];
    linkManTelLab.text = [NSString stringWithFormat:@"联系电话: %@",LinkManTel];
    linkManTelLab.font = [UIFont systemFontOfSize:13];
    [bgView addSubview:linkManTelLab];
    _tableView.tableHeaderView = bgView;
    
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section == 1 || section == 2) {
//        return 1;
//    }
    return data.count;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    if (indexPath.section == 1) {
////        return 120;
////    }
////    if (indexPath.section == 2)
////    {
////        return 44;
////    }
//    return 135;
//}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView // 一个表视图里面有多少组
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section // 返回组的头宽
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section// 返回组的尾宽
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HistoryInfoCell *cell = [HistoryInfoCell selectedCell:tableView];
    HistoryInfoModel *model = data[indexPath.row];
    cell.timeLab.text = [NSString stringWithFormat:@"%@",[model.ModifiedDate substringToIndex:16]];
    cell.addressLab.text = model.LocationAddress;
    cell.titleLab.text  = model.Contents;
    
    cell.totalLab.text = model.TotalAmount;
//    cell.feeapply1.text = model.FeeApplyTravelCount;
//    cell.feeapply2.text = model.FeeApplyAccommodationCount;
//    cell.feeapply3.text = model.FeeApplyGiftCount;
//    cell.feeapply4.text = model.FeeApplyOtherCount;
    cell.priceLab.text = [model.price stringByReplacingOccurrencesOfString:@"," withString:@"\n"];
    return cell;
}

@end

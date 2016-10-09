//
//  ProjectInfoController.m
//  MedicalCRM
//
//  Created by admin on 16/7/15.
//  Copyright © 2016年 JCK. All rights reserved.
/*
 if (manger.constructionDetails.count != 0)
 {
 sub.progress = manger.constructionDetails;
 }
 */

#import "ProjectInfoController.h"
#import "ProjectInfoCell.h"
#import "ProjectInfo2Cell.h"
#import "NetManger.h"
#import "ProjectInfoModel.h"
#import "ProjectFollowViewController.h"
#import "ProInfoFollewController.h"
#import "DemoMachineSaveController.h"
#import "HistoryViewController.h"
#import "ProcessModel.h"
#import "MJExtension.h"
#import "ProInfoProcessCell.h"
#import "PayInfoViewController.h"
#import "DownloadListViewController.h"
#import "DownloadListController.h"
#import "CustcontactpagelistModel.h"
#import "FuntionObj.h"
#import "HistoryInfoModel.h"
#import "HistoryInfoCell.h"
@interface ProjectInfoController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *datas;
    NSArray *datas2;
    NSArray *datas3;
    NetManger *manger;
    ProjectInfoModel *model;
    NSMutableArray *data;
    int pag;
    NSString *hospitalName;
    NSString *LinkManname;
    NSString *LinkManTel;
    NSMutableArray *feeapply;
    NSArray *Amounts;
    NSMutableArray *mfeeapplys;
    BOOL selected;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *m_Processdatas;
@end

@implementation ProjectInfoController
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
    selected = YES;
    manger = [NetManger shareInstance];
    manger.ID = [NSString stringWithFormat:@"%ld",self.ID];
    [manger loadData:RequestOfGetproject];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodatas) name:@"getproject" object:nil];
}
- (void)reloadHistoryData
{
    [data removeAllObjects];
    
    NSArray *Contracts = manger.getcustinfoDic[@"Contracts"];
     JCKLog(@"%@",Contracts);
    for (NSDictionary *dic in Contracts)
    {
        HistoryInfoModel *historyInfoModel = [HistoryInfoModel mj_objectWithKeyValues:dic];
        if (!data)
        {
            data = [NSMutableArray array];
            
        }
        JCKLog(@"%@",historyInfoModel.feeapply[@"Details"]);
        NSArray *feeapplys = historyInfoModel.feeapply[@"Details"];
        int i = 0;
        [mfeeapplys removeAllObjects];
        for (NSDictionary *dic in feeapplys)
        {
            //            JCKLog(@"%@",dic);
            if (!mfeeapplys)
            {
                mfeeapplys = [NSMutableArray array];
            }
            [mfeeapplys addObject:[NSString stringWithFormat:@"%@:%@",dic[@"ExpTypeName"],dic[@"Amount"]]];
//            i ++;
//            switch (i) {
//                case 1:
//                {
//                    
//                    historyInfoModel.FeeApplyTravelCount = [NSString stringWithFormat:@"%@",dic[@"Amount"] ];
//                }
//                    break;
//                case 2:
//                {
//                    historyInfoModel.FeeApplyAccommodationCount = [NSString stringWithFormat:@"%@",dic[@"Amount"]];
//                }
//                    break;
//                case 3:
//                {
//                    historyInfoModel.FeeApplyGiftCount = [NSString stringWithFormat:@"%@",dic[@"Amount"]];
//                }
//                    break;
//                case 4:
//                {
//                    historyInfoModel.FeeApplyOtherCount = [NSString stringWithFormat:@"%@",dic[@"Amount"]];
//                }
//                    break;
//                    
//                default:
//                    break;
//            }
            
        }
         historyInfoModel.price = [mfeeapplys componentsJoinedByString:@","];;
//        if (!historyInfoModel.FeeApplyTravelCount) {
//            historyInfoModel.FeeApplyTravelCount = @"0";
//        }
//        if (!historyInfoModel.FeeApplyAccommodationCount) {
//            historyInfoModel.FeeApplyAccommodationCount = @"0";
//        }
//        if (!historyInfoModel.FeeApplyGiftCount) {
//            historyInfoModel.FeeApplyGiftCount = @"0";
//        }
//        if (!historyInfoModel.FeeApplyOtherCount) {
//            historyInfoModel.FeeApplyOtherCount = @"0";
//        }
        [data addObject:historyInfoModel];
        
    }

    [_tableView reloadData];

}
- (void)relodatas
{
    // 名称 编号 金额 成功率
    // 联系人 联系电话
    // 登记时间 状态 备注
    model = manger.projectinfos[0];
    //    datas2 = @[[NSString stringWithFormat:@"联系人: %@",model.CustLinkMan],[NSString stringWithFormat:@"客户电话: %@",model.LinkTel]];
    //    datas3 = @[model.CreateDate,model.StatusName,[NSString stringWithFormat:@"备注: %@",model.Remark]];
    JCKLog(@"%@",model.CustID);
    manger.ID = model.CustID;
    [manger loadData:RequestOfGetcustinfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadHistoryData) name:@"getcustinfo" object:nil];
    if (model.CanViewUserName.length == 0)
    {
        model.CanViewUserName = @"无";
    }
    datas = @[model.ProjectName,
              [NSString stringWithFormat:@"项目编号:%@",model.ProjectNo],
              [NSString stringWithFormat:@"项目金额: %@",model.Investment],
              [NSString stringWithFormat:@"项目成功率: %.0f%%",[model.SuccessRate floatValue]*100],
              [NSString stringWithFormat:@"我司相关人员:%@",model.CanViewUserName]];
    
    if (model.CustName.length == 0)
    {
        model.CustName = @"";
    }
    if (model.DepartmentName.length == 0)
    {
        model.DepartmentName = @"";
    }
    if (model.ZhiWu.length == 0) {
        model.ZhiWu = @"";
    }
    if (model.LinkTel.length == 0) {
        model.LinkTel = @"";
    }
    if (model.CustLinkMan.length == 0) {
        model.CustLinkMan = @"";
    }
    
    datas2  = @[[NSString stringWithFormat:@"医院/公司: %@",model.CustName],
                [NSString stringWithFormat:@"科室/部门: %@",model.DepartmentName],
                [NSString stringWithFormat:@"职务: %@",model.ZhiWu],
                [NSString stringWithFormat:@"联系人: %@",model.CustLinkMan],
                [NSString stringWithFormat:@"客户电话: %@",[NSString stringWithFormat:@"%@",model.LinkTel]]];
    [_m_Processdatas removeAllObjects];
    for (NSDictionary *dic in manger.constructionDetails)
    {
        JCKLog(@"%@-%@-%@-%@",dic[@"ProcessName"],dic[@"Msg"],dic[@"FKId"],dic[@"FileNames"]);
        if (!_m_Processdatas)
        {
            _m_Processdatas = [NSMutableArray array];
        }
        ProcessModel *processModel = [ProcessModel mj_objectWithKeyValues:dic];
        [_m_Processdatas addObject:processModel];
    }
    JCKLog(@"%ld",_m_Processdatas.count);
//    datas3 = @[[NSString stringWithFormat:@"项目申报时间: %@",model.CreateDate],
//               [NSString stringWithFormat:@"项目状态: %@",model.StatusName],
//               [NSString stringWithFormat:@"备注: %@",model.Remark]];
    
    [self setTableView];
    [self setBottomView];
}
- (void)setBottomView{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, 80)];
    bottomView.backgroundColor = RGB(239, 239, 244);
    for (int i = 0; i<2; i++) {
        UIButton *bottomBtn         =
        [UIButton buttonWithType:UIButtonTypeCustom];
        
        bottomBtn.frame             =
        CGRectMake(i*(ScreenWidth/2)+10, 20, ScreenWidth/2-20, 40);
        bottomBtn.backgroundColor   =
        [UIColor orangeColor];
        [bottomBtn setTitle:@"完成" forState:UIControlStateNormal];
        if (i == 0)
        {
            if (self.isPublic == YES) {
                [bottomBtn setTitle:@"加入我的项目" forState:UIControlStateNormal];
            }
            else
            {
                [bottomBtn setTitle:@"放入公海池" forState:UIControlStateNormal];
            }
            [bottomBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            bottomBtn.layer.borderWidth = 1;
            bottomBtn.layer.borderColor = [UIColor orangeColor].CGColor;
            bottomBtn.backgroundColor = [UIColor clearColor];
        }
        [bottomBtn setTintColor:[UIColor whiteColor]];
        bottomBtn.titleLabel.font   =
        [UIFont systemFontOfSize:16];
        
        bottomBtn.tag               =
        2000+i;
        
        [bottomBtn addTarget:self action:@selector(bottomBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        bottomBtn.layer.cornerRadius = 5;
        bottomBtn.layer.masksToBounds = YES;
        [bottomView addSubview:bottomBtn];
    }
//    [self.view addSubview:bottomView];
    self.tableView.tableFooterView = bottomView;
}

#pragma mark -
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-56) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //iOS 8开始的自适应高度，可以不需要实现定义高度的方法
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:self.tableView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section// 返回组名
{
    NSArray *titles = @[@"项目相关",@"客户相关",@"项目进展",@"拜访记录"];
    return titles[section];
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section == 3)
//    {
//        return 140;
//    }
//    else
//    {
//        return UITableViewAutomaticDimension;
//    }
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }
    if (section == 1)
    {
        return 5;
    }
    if (section == 3)
    {
        if (data.count == 0)
        {
            return 1;
        }
        else
        {
            return data.count;
        }
        
    }
    return _m_Processdatas.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView // 一个表视图里面有多少组
{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section // 返回组的头宽
{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section // 返回组的尾宽
{

    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *allCell = @"cell";
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:allCell];
        cell.selectionStyle = UITableViewCellAccessoryNone;
    }
    if (indexPath.section == 0)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",datas[indexPath.row]];
    }
    if (indexPath.section == 1)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",datas2[indexPath.row]];
    }
    if (indexPath.section == 2)
    {
        ProInfoProcessCell *cell2 = [ProInfoProcessCell selectedCell:tableView];
        ProcessModel *processModel = _m_Processdatas[indexPath.row];
        cell2.titleLab.text = [NSString stringWithFormat:@"%@:",processModel.ProcessName];
        if ([processModel.Msg isEqualToString:@"(当前状态)"]) {
            processModel.Msg = @"";
        }
        if (processModel.FileNames.length == 0)
        {
            processModel.FileNames = @"";
        }
        cell2.contextLab.text = [NSString stringWithFormat:@"%@\n相关文件:\n%@",processModel.Msg,processModel.FileNames];
        cell2.timeLab.text = processModel.ProcessTime;
        cell2.tag = [processModel.FKId integerValue];
        cell2.tag = indexPath.row;
        cell2.btn.tag = cell2.tag;
        [cell2.btn addTarget:self action:@selector(pushDownloadListController:) forControlEvents:UIControlEventTouchDown];
        return cell2;
    }
    if (indexPath.section == 3)
    {
        HistoryInfoCell *historyInfoCell = [HistoryInfoCell selectedCell:tableView];
        HistoryInfoModel *historyInfoModel = data[indexPath.row];
        historyInfoCell.timeLab.text = [NSString stringWithFormat:@"%@",[historyInfoModel.ModifiedDate substringToIndex:16]];
        historyInfoCell.addressLab.text = [NSString stringWithFormat:@"%@" ,historyInfoModel.LocationAddress];
        historyInfoCell.titleLab.text  = historyInfoModel.Contents;
        
        historyInfoCell.totalLab.text = historyInfoModel.TotalAmount;
        historyInfoCell.priceLab.text = [historyInfoModel.price stringByReplacingOccurrencesOfString:@"," withString:@"\n"];
        return historyInfoCell;

//        static NSString *allCell3 = @"cell3";
//        UITableViewCell *cell3 = nil;
//        if (!cell3) {
//            cell3 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:allCell3];
//            cell3.selectionStyle = UITableViewCellAccessoryNone;
//        }
//        
//        if (!selected)
//        {
//            CustcontactpagelistModel *custcontactpagelistModel = manger.getcustcontactpagelist[indexPath.row];
//            cell3.textLabel.text = custcontactpagelistModel.Contents;
//            cell3.detailTextLabel.text = custcontactpagelistModel.ModifiedDate;
//        }
//        else
//        {
//            cell3.textLabel.text = @"点击展开拜访记录";
//        }
//        cell3.detailTextLabel.font = [UIFont systemFontOfSize:11];
//        cell3.textLabel.font = [UIFont systemFontOfSize:13];
//        return cell3;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    ProInfoProcessCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    if (indexPath.section == 2 && indexPath.row == 1)
//    {
//        if (cell.tag != 0)
//        {
//            PayInfoViewController *sub = [[PayInfoViewController alloc] init];
//            sub.title = @"详情";
//            sub.ProjectName = model.ProjectName;
////            sub.FlowStatusName = model.FlowStatusName;
//            sub.ID = [NSString stringWithFormat:@"%ld",cell.tag];
//            [self.navigationController pushViewController:sub animated:YES];
//        }
////        ProInfoFollewController *sub = [[ProInfoFollewController alloc] init];
////        sub.title = @"详情";
////        sub.datas = manger.constructionDetails;
////        [self.navigationController pushViewController:sub animated:YES];
//
//    }
    if (indexPath.section == 2)
    {
        ProcessModel *model2 = _m_Processdatas[indexPath.row];
        JCKLog(@"%@\n%@",model2.FileNames,model2.FilePaths);
        NSArray *fileNames = [model2.FileNames componentsSeparatedByString:@";"];
        NSArray *filePaths = [model2.FilePaths componentsSeparatedByString:@";"];
        DownloadListController *sub = [[DownloadListController alloc] init];
        sub.title = @"下载列表";
        sub.names = fileNames;
        sub.urls = filePaths;
        [self.navigationController pushViewController:sub animated:YES];

    }
//    if (indexPath.section == 3)
//    {
//        if (selected)
//        {
//            testArr =testArr = manger.getcustcontactpagelist;
//        }
//        else
//        {
//            testArr = @[@"1"];
//        }
//        selected = !selected;
//        //一个section刷新
//        
//        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
//        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
//    }

}
- (void)pushDownloadListController:(UIButton *)btn
{
    ProcessModel *model2 = _m_Processdatas[btn.tag];
    JCKLog(@"%@\n%@",model2.FileNames,model2.FilePaths);
    NSArray *fileNames = [model2.FileNames componentsSeparatedByString:@";"];
    NSArray *filePaths = [model2.FilePaths componentsSeparatedByString:@";"];
    DownloadListController *sub = [[DownloadListController alloc] init];
    sub.title = @"下载列表";
    sub.names = fileNames;
    sub.urls = filePaths;
    [self.navigationController pushViewController:sub animated:YES];
}
- (void)projecttranspub
{
    NSString *alMsg;
    if (self.isPublic) {
        alMsg = @"是否跟进此项目";
    }
    else
    {
        alMsg = @"是否把项目放进公海池";
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:alMsg preferredStyle: UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        manger.ID = [NSString stringWithFormat:@"%ld",self.ID];
        if (self.isPublic) {
            [manger loadData:RequestOfProjectpubtransmine];
             [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popCtr) name:@"projectpubtransmine" object:nil];
        }
        else
        {
            [manger loadData:RequestOfProjecttranspub];
             [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popCtr) name:@"projecttranspub" object:nil];
        }
        
       
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
    }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];


}
#pragma  mark - bottomBtnAction
- (void)bottomBtnAction:(UIButton *)sender
{
    if (sender.tag == 2001)
    {
//        ProjectFollowViewController *sub = [[ProjectFollowViewController alloc] init];
//        sub.title = @"跟进计划";
//        sub.ID = [NSString stringWithFormat:@"%ld",self.ID];
//        [self.navigationController pushViewController:sub animated:YES];
        [self popCtr];
    }
    if (sender.tag == 2000)
    {
        [self projecttranspub];
    }
}
- (void)demoAction
{
//    DemoMachineSaveController *sub = [[DemoMachineSaveController alloc] init];
//    sub.title = @"样机申请";
//    sub.ID = [NSString stringWithFormat:@"%ld",self.ID];
//    [self.navigationController pushViewController:sub animated:YES];
    
    HistoryViewController *sub = [[HistoryViewController alloc] init];
    sub.title = @"历史拜访记录";
    [self.navigationController pushViewController:sub animated:YES];

}
- (void)popCtr
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

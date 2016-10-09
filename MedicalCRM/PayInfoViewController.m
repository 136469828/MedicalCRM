//
//  PayInfoViewController.m
//  MedicalCRM
//
//  Created by admin on 16/8/9.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "PayInfoViewController.h"
#import "NetManger.h"
#import "MJExtension.h"
#import "DemoChiInfoModel.h"
#import "DemoChiISteModel.h"
#import "StepNamesCell.h"
#import "FuntionObj.h"
@interface PayInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NetManger *manger;
    NSString *projcetStr;
    NSString *counts;
    NSString *proNo;
    NSString *proID;
    NSString *ProdNo;
    NSString *UsedPrice;
    NSString *cusName;
}
@property (nonatomic, strong) NSMutableArray *m_datas;
@property (nonatomic, strong) NSMutableArray *StepNames;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation PayInfoViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];

}
- (void)relodatas
{
    if (_ProjectName.length == 0)
    {
        _ProjectName = @"无关联项目";
    }
    DemoChiInfoModel *model = manger.getsellsamples[0];
    proNo = model.ApplyNo;
    for (NSDictionary *dic in model.details)
    {
        projcetStr = dic[@"ProductName"],
        proID= dic[@"ProductID"];
        counts = [NSString stringWithFormat:@"%@",dic[@"ProductCount"]];
        ProdNo = dic[@"ProdNo"];
//        UsedPrice = dic[@"UsedPrice"];
        
    }
    NSArray *datas = model.FlowSteps;
    for (NSDictionary *dic2 in datas)
    {
        DemoChiISteModel *model2 = [DemoChiISteModel mj_objectWithKeyValues:dic2];
        JCKLog(@"%@",dic2[@"CheckStatusName"]);
        if (!_StepNames) {
            _StepNames = [NSMutableArray array];
        }
        [_StepNames addObject:model2];
    }
    [self setTableView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    manger = [NetManger shareInstance];
    manger.ID = self.ID;
    [manger loadData:RequestOfGetsellsample];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodatas) name:@"getsellsample" object:nil];
}
- (void)setBottomView{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,ScreenHeight-69 - 70, ScreenWidth, 70)];
    bottomView.backgroundColor = RGB(239, 239, 244);

        UIButton *bottomBtn         =
        [UIButton buttonWithType:UIButtonTypeCustom];
        
        bottomBtn.frame             =
        CGRectMake(10, 20, ScreenWidth-20, 40);
        bottomBtn.backgroundColor   =
        [UIColor orangeColor];
        [bottomBtn setTitle:@"申请备货样机" forState:UIControlStateNormal];
        [bottomBtn setTintColor:[UIColor whiteColor]];
        bottomBtn.titleLabel.font   =
        [UIFont systemFontOfSize:16];
        
        bottomBtn.tag               =
        2000;
        
        [bottomBtn addTarget:self action:@selector(bottomBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        bottomBtn.layer.cornerRadius = 5;
        bottomBtn.layer.masksToBounds = YES;
        [bottomView addSubview:bottomBtn];
    //    [self.view addSubview:bottomView];
        [self.view addSubview: bottomView];
}

#pragma mark -
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 70) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //iOS 8开始的自适应高度，可以不需要实现定义高度的方法
//    self.tableView.estimatedRowHeight = 200;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
    JCKLog(@"%@",self.FlowStatusName);
    if (self.isAdu == 3)
    {
        [self setBottomView2];
    }
    else
    {
        if (![self.FlowStatusName isEqualToString:@"待审批"])
        {
            [self setBottomView];
        }
    }


}
- (void)setBottomView2{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,ScreenHeight-69 - 70, ScreenWidth, 70)];
    bottomView.backgroundColor = RGB(239, 239, 244);
    for (int i = 0; i<2; i++) {
        UIButton *bottomBtn         =
        [UIButton buttonWithType:UIButtonTypeCustom];
        
        bottomBtn.frame             =
        CGRectMake(i*(ScreenWidth/2)+10, 20, ScreenWidth/2-20, 40);
        bottomBtn.backgroundColor   =
        [UIColor orangeColor];
        [bottomBtn setTitle:@"通过" forState:UIControlStateNormal];
        if (i == 0)
        {
            [bottomBtn setTitle:@"不通过" forState:UIControlStateNormal];
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
        
        [bottomBtn addTarget:self action:@selector(bottomBtnAction2:) forControlEvents:UIControlEventTouchUpInside];
        bottomBtn.layer.cornerRadius = 5;
        bottomBtn.layer.masksToBounds = YES;
        [bottomView addSubview:bottomBtn];
    }
    //    [self.view addSubview:bottomView];
    [self.view addSubview: bottomView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView // 一个表视图里面有多少组
{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3)
    {
        return 70;
    }
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section  // 返回组的头宽
{
    return 9;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section // 返回组的尾宽
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return 5;
    }
    else if (section == 2)
    {
        return 3;
    }
    else if (section == 3)
    {
        return _StepNames.count;
    }
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
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    DemoChiInfoModel *model = manger.getsellsamples[0];
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"标题: %@",model.Title];
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            cell.textLabel.text = [NSString stringWithFormat:@"样机名: %@",projcetStr];
        }
        else if (indexPath.row == 1)
        {
            if ([model.CustName isKindOfClass:[NSNull class]])
            {
                model.CustName = @"";
            }
            cell.textLabel.text = [NSString stringWithFormat:@"医院名: %@",model.CustName];
        }
        else if (indexPath.row == 2)
        {
            cell.textLabel.text = [NSString stringWithFormat:@"关联项目: %@",_ProjectName];
        }
        else if (indexPath.row == 3)
        {
            cell.textLabel.textColor =[UIColor orangeColor];
            cell.textLabel.text = [NSString stringWithFormat:@"金额: %@ ",model.TotalFee];
        }
        else
        {
            cell.textLabel.textColor =[UIColor orangeColor];
            cell.textLabel.text = [NSString stringWithFormat:@"数量: %@ ",counts];
        }
        
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            cell.textLabel.text = [NSString stringWithFormat:@"申请时间: %@",model.CreateDate];
        }
        else if (indexPath.row == 1)
        {
           cell.textLabel.textColor = RGB(77, 188, 251);
           cell.textLabel.text = [NSString stringWithFormat:@"申请人: %@",model.CreatorName];
        }
        else
        {
            cell.textLabel.text = [NSString stringWithFormat:@"联系电话: %@",model.CustTel];
        }
    }
    else if (indexPath.section == 3)
    {
        StepNamesCell *cell2 = [StepNamesCell selectedCell:tableView];
        DemoChiISteModel *model2 = _StepNames[indexPath.row];
        cell2.titleLab.text = [NSString stringWithFormat:@"审核部门: %@",model2.StepName];
        if (model2.CheckStatusName.length == 0)
        {
            model2.CheckStatusName = @"";
        }
        cell2.subTitleLab.text = [NSString stringWithFormat:@"审核结果: %@",model2.CheckStatusName];
        cell2.timeLab.text = [NSString stringWithFormat:@"%@",[model2.ModifiedDate substringToIndex:16]];
        return cell2;
    }
    return cell;

}
- (void)bottomBtnAction2:(UIButton *)btn
{
    NSString *tag;
    if (btn.tag == 2000)
    {
        tag = @"2";
    }
    else  if (btn.tag == 2001)
    {
        tag = @"0";
    }
    manger.flowstepchecks = @[ProdNo,tag,@"5",@"11"];
    JCKLog(@"%@ %@",tag,ProdNo);
    
    [manger loadData:RequestOfFlowstepcheck];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popctr) name:@"flowstepcheck" object:nil];
}
- (void)popctr
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)bottomBtnAction:(UIButton *)btn
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"请输入备货数量"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确认", nil];
    // 基本输入框，显示实际输入的内容
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    //设置输入框的键盘类型
    UITextField *tf = [alert textFieldAtIndex:0];
    
    UITextField *tf2 = [alert textFieldAtIndex:1];
    if (alert.alertViewStyle == UIAlertViewStylePlainTextInput) {
        // 对于用户名密码类型的弹出框，还可以取另一个输入框
        tf2 = [alert textFieldAtIndex:1];
        tf2.keyboardType = UIKeyboardTypeASCIICapable;
        NSString* text2 = tf2.text;
        NSLog(@"INPUT1:%@", text2);
    }
    
    // 取得输入的值
    NSString* text = tf.text;
    NSLog(@"INPUT:%@", text);
    if (alert.alertViewStyle == UIAlertViewStylePlainTextInput) {
        // 对于两个输入框的
        NSString* text2 = tf2.text;
        NSLog(@"INPUT2:%@", text2);
    }
    
    [alert show];
    /*
     
     NSArray *Detailss =  @[@{
     @"ProductID": Details[0],
     @"ProductCount": Details[1],
     }
     ];
     NSString *detailstr = [Detailss mj_JSONString];
     AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
     manager.requestSerializer.timeoutInterval = 5;
     NSDictionary *parameters = @{
     @"_appid" : @"101",
     @"_code": self.userCode,
     @"EndDateStr": @"",
     @"StartDateStr": @"",
     @"Title": sellordersaves[0],
     @"FromType": sellordersaves[1],
     @"FromBillID":sellordersaves[2],
     @"Details" : detailstr
     };

     */
    JCKLog(@"%ld",btn.tag);

}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        UITextField *nameField = [alertView textFieldAtIndex:0];
        //TODO
//        NSLog(@"nameField %@",nameField.text);
        manger.detailss = @[proID,nameField.text];// 样机ID 数量
//        JCKLog(@"%@",proNo);
        manger.sellordersaves = @[projcetStr,@"4",proNo];// 标题 来源（固定4）样机BillID
        [manger loadData:RequestOfSellordersave];
    }
    
}
@end

//
//  LifeNavigationViewController.m
//  MedicalCRM
//
//  Created by admin on 16/8/8.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "LifeNavigationViewController.h"
#import "LifeNanvigationCell.h"
#import "LifeNanvgation5Cell.h"
#import "LifeNanvgation3Cell.h"
#import "LifeNanvgation4Cell.h"
#import "MJExtension.h"
#import "NetManger.h"
#import "LifeNavigationListModel.h"
#import "KeyboardToolBar.h"
#import "SVProgressHUD.h"
//#import "IQKeyboardManager.h"
//#import "IQKeyboardReturnKeyHandler.h"
@interface LifeNavigationViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate>
{
    NSArray *scetionName;
    NetManger *manger;
    LifeNavigationListModel *model;
    NSString *tf3d;
    NSString *tv3d;
    NSString *tfyijian;
    NSString *tvyijian;
    NSString *tfDSA;
    NSString *tvDSA;
    NSString *tfzhineng;
    NSString *tvzhineng;
    NSString *tfmore;
    NSString *tvmore;
//    IQKeyboardReturnKeyHandler *returnKeyHandler;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation LifeNavigationViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [IQKeyboardManager sharedManager].enable=NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [IQKeyboardManager sharedManager].enable=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    scetionName = @[@"★一、个人财富、事业目标：",@"★二、我的机会：",@"★三、我的行动：",@"★四、我的预期成果："];
    manger = [NetManger shareInstance];
    [manger loadData:RequestOfGetemployeenav];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDatas) name:@"getemployeenav" object:nil];
#pragma mark - 设置navigationItem右侧按钮
    UIButton *meassageBut = ({
        UIButton *meassageBut = [UIButton buttonWithType:UIButtonTypeCustom];
        meassageBut.frame = CGRectMake(0, 0, 40, 20);
        meassageBut.titleLabel.font = [UIFont systemFontOfSize:15];
        [meassageBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [meassageBut addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchDown];
        [meassageBut setTitle:@"保存" forState:UIControlStateNormal];
        meassageBut;
    });
    UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithCustomView:meassageBut];
    self.navigationItem.rightBarButtonItem = rBtn;
    
//    [IQKeyboardManager sharedManager].enableAutoToolbar=YES;
//    returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
//    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

//- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [self.view endEditing:YES];
//}
- (void)reloadDatas
{
    //    JCKLog(@"%@",manger.lifeDic);
//    JCKLog(@"%@",manger.lifeDic[@"data"][@"TotalMineMoneyByYear"]);//年度财富
//    JCKLog(@"%@",manger.lifeDic[@"data"][@"TotalMineMoneyByFuture"]);//未来财富
//    JCKLog(@"%@",manger.lifeDic[@"data"][@"TeamCountByYear"]);//成就多少人
//    JCKLog(@"%@",manger.lifeDic[@"data"][@"TeamCountByFuture"]);//未来成就多少人
//    JCKLog(@"%@",manger.lifeDic[@"data"][@"ChanceTypeList"]);//领域目标
//    JCKLog(@"%@",manger.lifeDic[@"data"][@"VisitCountByDay"]);//每天拜访多少人
//    JCKLog(@"%@",manger.lifeDic[@"data"][@"VisitCountByYear"]);//年度拜访多少人
//    JCKLog(@"%@",manger.lifeDic[@"data"][@"CustomCountByYear"]);//客户成为合伙人
//    JCKLog(@"%@",manger.lifeDic[@"data"][@"ProjectCountByYear"]);//年度项目数
//    JCKLog(@"%@",manger.lifeDic[@"data"][@"SaleMoneyByYear"]);//年度销售数
//    JCKLog(@"%@",manger.lifeDic[@"data"][@"ProjectMoneyByYear"]);//年度成果数
//    JCKLog(@"%@",manger.lifeDic[@"data"][@"CreateDate"]);//创建时间
    
    model = [LifeNavigationListModel shareInstance];
    
//    model.TotalMineMoneyByYear = manger.lifeDic[@"data"][@"TotalMineMoneyByYear"];
//    model.TotalMineMoneyByFuture = manger.lifeDic[@"data"][@"TotalMineMoneyByFuture"];
//    model.TeamCountByYear = manger.lifeDic[@"data"][@"TeamCountByYear"];
//    model.TeamCountByFuture = manger.lifeDic[@"data"][@"TeamCountByFuture"];
////    model.ChanceTypeList = manger.lifeDic[@"data"][@"ChanceTypeList"];
//    model.VisitCountByDay = manger.lifeDic[@"data"][@"VisitCountByDay"];
//    model.VisitCountByYear = manger.lifeDic[@"data"][@"VisitCountByYear"];
//    model.CustomCountByYear = manger.lifeDic[@"data"][@"CustomCountByYear"];
//    model.ProjectCountByYear = manger.lifeDic[@"data"][@"ProjectCountByYear"];
//    model.SaleMoneyByYear = manger.lifeDic[@"data"][@"SaleMoneyByYear"];
//    model.ProjectMoneyByYear = manger.lifeDic[@"data"][@"ProjectMoneyByYear"];
//    model.CreateDate = manger.lifeDic[@"data"][@"CreateDate"];
//    model.ChanceTypeList = manger.lifeDic[@"data"][@"ChanceTypeList"];
//    JCKLog(@"%@",model);
    [self setTableView];
    
}
#pragma mark -
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 69) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //iOS 8开始的自适应高度，可以不需要实现定义高度的方法
//    self.tableView.estimatedRowHeight = 200;
//    self.tableView.rowHeight = 150;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
    
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
//    
//    
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTableViewTouchInSide)];
    tableViewGesture.numberOfTapsRequired = 1;
    tableViewGesture.cancelsTouchesInView = NO;
    [_tableView addGestureRecognizer:tableViewGesture];
}
-(CGFloat)keyboardEndingFrameHeight:(NSDictionary *)userInfo//计算键盘的高度
{
    CGRect keyboardEndingUncorrectedFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGRect keyboardEndingFrame = [self.view convertRect:keyboardEndingUncorrectedFrame fromView:nil];
    return keyboardEndingFrame.size.height;
}
-(void)keyboardWillAppear:(NSNotification *)notification
{
    CGRect currentFrame = CGRectMake(0,0, ScreenWidth, ScreenHeight - 69/2);
    CGFloat change = [self keyboardEndingFrameHeight:[notification userInfo]];
    currentFrame.origin.y = currentFrame.origin.y - change ;
    self.view.frame = currentFrame;
}
// 当键盘消失后，视图需要恢复原状。
-(void)keyboardWillDisappear:(NSNotification *)notification
{
    CGRect currentFrame = CGRectMake(0, -ScreenHeight/2+49, ScreenWidth, ScreenHeight);
    CGFloat change = [self keyboardEndingFrameHeight:[notification userInfo]];
    currentFrame.origin.y = currentFrame.origin.y + change ;
    self.view.frame = currentFrame;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)commentTableViewTouchInSide{
    [_tableView endEditing:YES];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_tableView endEditing:YES];
}

#pragma mark - UITableViewDataSource
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section // 返回组名
{
    return scetionName[section];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section // 返回组的尾宽
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section // 返回组的头宽
{
    return 30;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 5;
    }
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView // 一个表视图里面有多少组
{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 200;
    }
    else if (indexPath.section == 1)
    {
        return 120;
    }
    else if (indexPath.section == 2)
    {
        return 80;
    }
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        LifeNanvigationCell *cell = [LifeNanvigationCell selectedCell:tableView];
        cell.tf1.text = [NSString stringWithFormat:@"%@",model.TotalMineMoneyByYear];
        cell.tf2.text = [NSString stringWithFormat:@"%@",model.TotalMineMoneyByFuture];
        cell.tf3.text = [NSString stringWithFormat:@"%@",model.TeamCountByYear];
        cell.tf4.text = [NSString stringWithFormat:@"%@",model.TeamCountByFuture];
        cell.tf1.delegate = self;
        cell.tf2.delegate = self;
        cell.tf3.delegate = self;
        cell.tf4.delegate = self;
        cell.tf1.tag = 1000;
        cell.tf2.tag = 1001;
        cell.tf3.tag = 1002;
        cell.tf4.tag = 1003;

        [KeyboardToolBar registerKeyboardToolBar:cell.tf1];
        [KeyboardToolBar registerKeyboardToolBar:cell.tf2];
        [KeyboardToolBar registerKeyboardToolBar:cell.tf3];
        [KeyboardToolBar registerKeyboardToolBar:cell.tf4];
        return cell;
    }
    else if (indexPath.section == 1)
    {
        LifeNanvgation5Cell *cell5 = [LifeNanvgation5Cell selectedCell:tableView];
        cell5.tv5.layer.cornerRadius = 5;
        cell5.tv5.layer.borderColor = RGB(234, 234, 234).CGColor;
        cell5.tv5.layer.borderWidth = 1;
        cell5.tv5.text = [NSString stringWithFormat:@"1...\n2...\n3...\n..."];
        if (indexPath.row == 0)
        {
            cell5.titleLab.text = @"1、3D解剖临床应用解决方案：我有机会让这";
            cell5.tv5.delegate = self;
            cell5.tf5.delegate = self;
            cell5.tv5.tag = 2000;
            cell5.tf5.tag = 1010;
            if ([cell5.tf5.text isEqualToString:@"<null>"])
            {
                cell5.tf5.text = @"";
            }
            else
            {
               cell5.tf5.text = tf3d;
            }
            if ([cell5.tv5.text isEqualToString:@"1...\n2...\n3...\n..."])
            {
                cell5.tf5.text = @"";
            }
            else
            {
                cell5.tf5.text = tv3d;
            }
        }
        else if (indexPath.row == 1)
        {
            cell5.titleLab.text = @"2、一键式医疗信息平台解决方案：我有机会让这";
            cell5.tv5.delegate = self;
            cell5.tf5.delegate = self;
            cell5.tf5.tag = 1011;
                        cell5.tv5.tag = 2001;
            if ([cell5.tf5.text isEqualToString:@"<null>"])
            {
                cell5.tf5.text = @"";
            }
            else
            {
               cell5.tf5.text = tfyijian;
            }
            if ([cell5.tv5.text isEqualToString:@"1...\n2...\n3...\n..."])
            {
                cell5.tf5.text = @"";
            }
            else
            {
                cell5.tf5.text = tvyijian;
            }
        }
        else if (indexPath.row == 2)
        {
            cell5.titleLab.text = @"3、DSA智能信号处理解决方案：我有机会让这";
            cell5.tv5.delegate = self;
            cell5.tf5.delegate = self;
                        cell5.tv5.tag = 2002;
            cell5.tf5.tag = 1012;
            if ([cell5.tf5.text isEqualToString:@"<null>"])
            {
                cell5.tf5.text = @"";
            }
            else
            {
                cell5.tf5.text = tfDSA;
            }
            if ([cell5.tv5.text isEqualToString:@"1...\n2...\n3...\n..."])
            {
                cell5.tf5.text = @"";
            }
            else
            {
                cell5.tf5.text = tvDSA;
            }
        }
        else if (indexPath.row == 3)
        {
            cell5.titleLab.text = @"4、智能影像中心解决方案：我有机会让这";
            cell5.tv5.delegate = self;
            cell5.tf5.delegate = self;
            cell5.tf5.tag = 1013;
                        cell5.tv5.tag = 2003;
            if ([cell5.tf5.text isEqualToString:@"<null>"])
            {
                cell5.tf5.text = @"";
            }
            else
            {
                cell5.tf5.text = tfzhineng;
            }
            if ([cell5.tv5.text isEqualToString:@"1...\n2...\n3...\n..."])
            {
                cell5.tf5.text = @"";
            }
            else
            {
                cell5.tf5.text = tvzhineng;
            }
        }
        else if (indexPath.row == 4)
        {
            cell5.titleLab.text = @"5、其他专业医疗显示解决方案：我有机会让这";
            cell5.tv5.delegate = self;
            cell5.tf5.delegate = self;
            cell5.tf5.tag = 1014;
                        cell5.tv5.tag = 2004;
            if ([cell5.tf5.text isEqualToString:@"<null>"])
            {
                cell5.tf5.text = @"";
            }
            else
            {
                cell5.tf5.text = tfmore;
            }
            if ([cell5.tv5.text isEqualToString:@"1...\n2...\n3...\n..."])
            {
                cell5.tf5.text = @"";
            }
            else
            {
                cell5.tf5.text = tvmore;
            }
        }
        
        return cell5;
    }
    else if (indexPath.section == 2)
    {
        LifeNanvgation3Cell *cell3 = [LifeNanvgation3Cell selectedCell:tableView];
        cell3.tf31.text = [NSString stringWithFormat:@"%@",model.VisitCountByDay];
        cell3.tf32.text = [NSString stringWithFormat:@"%@",model.VisitCountByYear];
        cell3.tf33.text = [NSString stringWithFormat:@"%@",model.CustomCountByYear];
        cell3.tf31.delegate = self;
        cell3.tf31.delegate = self;
        cell3.tf31.delegate = self;
        cell3.tf31.tag = 1004;
        cell3.tf31.tag = 1005;
        cell3.tf31.tag = 1006;
        [KeyboardToolBar registerKeyboardToolBar:cell3.tf31];
        [KeyboardToolBar registerKeyboardToolBar:cell3.tf32];
        [KeyboardToolBar registerKeyboardToolBar:cell3.tf33];
        return cell3;
    }
    else if (indexPath.section == 3)
    {
        LifeNanvgation4Cell *cell4 = [LifeNanvgation4Cell selectedCell:tableView];
        cell4.tf31.text = [NSString stringWithFormat:@"%@",model.ProjectCountByYear];
        cell4.tf32.text = [NSString stringWithFormat:@"%@",model.SaleMoneyByYear];
        cell4.tf33.text = [NSString stringWithFormat:@"%@",model.ProjectMoneyByYear];
        cell4.tf31.delegate = self;
        cell4.tf32.delegate = self;
        cell4.tf33.delegate = self;
        cell4.tf31.tag = 1007;
        cell4.tf32.tag = 1008;
        cell4.tf33.tag = 1009;
        [KeyboardToolBar registerKeyboardToolBar:cell4.tf31];
        [KeyboardToolBar registerKeyboardToolBar:cell4.tf32];
        [KeyboardToolBar registerKeyboardToolBar:cell4.tf33];
        return cell4;
    }
    return nil;

}
- (void)saveAction
{
//    manger = [NetManger shareInstance];
//    [manger loadData:RequestOfSaveemployeenav];
    //初始化提示框；
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"保存成功" preferredStyle: UIAlertControllerStyleAlert];
//    
//    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        //点击按钮的响应事件；
//        [self.navigationController popViewControllerAnimated:YES];
//    }]];
//    
//    //弹出提示框；
//    [self presentViewController:alert animated:true completion:nil];
    [SVProgressHUD showSuccessWithStatus:@"保存成功"];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField

{
    NSLog(@"textFieldDidBeginEditing");
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    /*
     model.TotalMineMoneyByYear = manger.lifeDic[@"data"][@"TotalMineMoneyByYear"];
     model.TotalMineMoneyByFuture = manger.lifeDic[@"data"][@"TotalMineMoneyByFuture"];
     model.TeamCountByYear = manger.lifeDic[@"data"][@"TeamCountByYear"];
     model.TeamCountByFuture = manger.lifeDic[@"data"][@"TeamCountByFuture"];
     //    model.ChanceTypeList = manger.lifeDic[@"data"][@"ChanceTypeList"];
     model.VisitCountByDay = manger.lifeDic[@"data"][@"VisitCountByDay"];
     model.VisitCountByYear = manger.lifeDic[@"data"][@"VisitCountByYear"];
     model.CustomCountByYear = manger.lifeDic[@"data"][@"CustomCountByYear"];
     model.ProjectCountByYear = manger.lifeDic[@"data"][@"ProjectCountByYear"];
     model.SaleMoneyByYear = manger.lifeDic[@"data"][@"SaleMoneyByYear"];
     model.ProjectMoneyByYear = manger.lifeDic[@"data"][@"ProjectMoneyByYear"];
     model.CreateDate = manger.lifeDic[@"data"][@"CreateDate"];
     model.ChanceTypeList = manger.lifeDic[@"data"][@"ChanceTypeList"];
     */
    switch (textField.tag) {
        case 1000:
        {
            model.TotalMineMoneyByYear = textField.text;
        }
            break;
        case 1001:
        {
            model.TotalMineMoneyByFuture = textField.text;
        }
            break;
        case 1002:
        {
            model.TeamCountByYear = textField.text;
        }
            break;
        case 1003:
        {
            model.TeamCountByFuture = textField.text;
        }
            break;
        case 1004:
        {
            model.VisitCountByDay = textField.text;
        }
            break;
        case 1005:
        {
            model.VisitCountByYear = textField.text;
        }
            break;
        case 1006:
        {
            model.CustomCountByYear = textField.text;
        }
            break;
        case 1007:
        {
            model.ProjectCountByYear = textField.text;
        }
            break;
        case 1008:
        {
            model.SaleMoneyByYear = textField.text;
        }
            break;
        case 1009:
        {
            model.ProjectMoneyByYear = textField.text;
        }
            break;
        case 1010:
        {
            tf3d = textField.text;
        }
            break;
        case 1011:
        {
            tfyijian = textField.text;
        }
            break;
        case 1012:
        {
            tfDSA = textField.text;
        }
            break;
        case 1013:
        {
            tfzhineng = textField.text;
        }
            break;
        case 1014:
        {
            tfmore = textField.text;
        }
            break;
            
            
        default:
            break;
    }
    return YES;
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    switch (textView.tag) {
        case 2000:
        {
            tv3d = textView.text;
        }
            break;
        case 2001:
        {
                        tvyijian = textView.text;
        }
            break;
        case 2002:
        {
                        tvDSA = textView.text;
        }
            break;
        case 2003:
        {
                        tvzhineng = textView.text;
        }
            break;
        case 2004:
        {
                       tvmore = textView.text;
        }
            break;
            
        default:
            break;
    }
    return YES;
}
@end

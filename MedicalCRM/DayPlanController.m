//
//  DayPlanController.m
//  MedicalCRM
//
//  Created by admin on 16/8/1.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "DayPlanController.h"
#include "DayPlanCycleController.h"
#import "DayPlanClassController.h"
//#import "CustomerListViewController.h"
#import "DayPlanDirectionController.h"
#import "DayPlanImportantViewController.h"
#import "KeyboardToolBar.h"
#import "NetManger.h"
#import "DayPlanModel.h"
@interface DayPlanController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    NSArray *titles;
    UITextView *tv;
    NSString *classStr;
    NSString *classStrID;
    NSString *dateCycle;
    NSString *custon;
    NSString *important;
    NSString *custonID;
    DayPlanModel *model;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *m_cutomArray;
@end

@implementation DayPlanController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    model = [DayPlanModel shareInstance];
    titles = @[@[@"标题",@"计划类型",@"工作方向"],@[@"周期",@"开始时间",@"结束时间",@"重要性",@"预估项目费用(￥)"],@[@" "]];
    [self setTableView];
#pragma mark - 设置navigationItem右侧按钮
    UIButton *meassageBut = ({
        UIButton *meassageBut = [UIButton buttonWithType:UIButtonTypeCustom];
        meassageBut.frame = CGRectMake(0, 0, 40, 20);
        meassageBut.titleLabel.font = [UIFont systemFontOfSize:15];
        [meassageBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [meassageBut addTarget:self action:@selector(savePlan) forControlEvents:UIControlEventTouchDown];
        [meassageBut setTitle:@"提交" forState:UIControlStateNormal];
        meassageBut;
    });
    
    UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithCustomView:meassageBut];
    self.navigationItem.rightBarButtonItem = rBtn;
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
    
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTableViewTouchInSide)];
    tableViewGesture.numberOfTapsRequired = 1;
    tableViewGesture.cancelsTouchesInView = NO;
    [_tableView addGestureRecognizer:tableViewGesture];
    
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
    if (section == 1) {
        return 5;
    }
    else if (section == 0)
    {
        return 3;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        return 100;
    }
    return 44;
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
    cell.textLabel.text = titles[indexPath.section][indexPath.row];
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(ScreenWidth*0.3, 0, ScreenWidth-ScreenWidth*0.3-10, 44)];
    tf.font = [UIFont systemFontOfSize:13];
    tf.textAlignment = NSTextAlignmentRight;
    tf.placeholder = @"点击输入工作计划内容";
    tf.delegate = self;
    tf.tag = 20000 + indexPath.row;
    [KeyboardToolBar registerKeyboardToolBar:tf];
    [cell.contentView addSubview:tf];
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        if (model.title)
        {
            tf.text = model.title;
        }
    }
    if (((indexPath.section == 1 && indexPath.row == 0) || indexPath.row == 3) || indexPath.section == 2 || (indexPath.section == 0 && indexPath.row != 0))
    {
        tf.hidden = YES;
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*0.3, 0, ScreenWidth-ScreenWidth*0.3-10, 44)];
        lb.font = [UIFont systemFontOfSize:13];
        lb.textAlignment = NSTextAlignmentRight;
        if (indexPath.section == 0 && indexPath.row == 1)
        {
            lb.tag = 5000;
            if (classStr.length != 0)
            {
                lb.text = classStr;
            }
            else
            {
            lb.text = @"点击选择";
            }
        }
        else if (indexPath.section == 1 && indexPath.row == 0)
        {
            lb.tag = 5001;
            if (dateCycle.length != 0)
            {
                lb.text = dateCycle;
            }
            else
            {
                lb.text = @"点击选择";
            }
        }
        else if (indexPath.section == 1 && indexPath.row == 3)
        {
            lb.tag = 5003;
            if (important.length != 0)
            {
                lb.text = important;
            }
            else
            {
                lb.text = @"点击选择";
            }
        }
        else if (indexPath.section == 0 && indexPath.row == 2)
        {
            lb.tag = 5002;
            if (custon.length != 0)
            {
                lb.text = custon;
            }
            else
            {
                lb.text = @"点击选择";
            }
        }
        [cell.contentView addSubview:lb];

        if (indexPath.section == 2)
        {
            lb.hidden = YES;
            tv = [[UITextView alloc] initWithFrame:CGRectMake(2, 3, ScreenWidth-4, 100 - 6)];
            tv.font = [UIFont systemFontOfSize:13];
            tv.text = @"点击输入";
            tv.textColor = [UIColor lightGrayColor];
            tv.delegate = self;
            [cell.contentView addSubview:tv];
        }
        
    }

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JCKLog(@"%@",indexPath);
    if (indexPath.section == 1 && indexPath.row == 0)
    {
        DayPlanCycleController *sub = [[DayPlanCycleController alloc] init];
        sub.title = @"请选择计划周期";
        sub.block = ^(NSString *str)
        {
            JCKLog(@"%@",str);
            dateCycle = str;
            UILabel *lb = (UILabel *)[_tableView viewWithTag:5001];
            lb.text = dateCycle;
        };
        [self.navigationController pushViewController:sub animated:YES];

    }
    else  if (indexPath.section == 1 && indexPath.row == 3)
    {
        DayPlanImportantViewController *sub = [[DayPlanImportantViewController alloc] init];
        sub.title = @"请选择重要性";
        sub.block = ^(NSString *str)
        {
            JCKLog(@"%@",str);
            important = str;
            UILabel *lb = (UILabel *)[_tableView viewWithTag:5003];
            lb.text = important;
        };
        [self.navigationController pushViewController:sub animated:YES];
        
    }
    
    else if (indexPath.section == 0 && indexPath.row == 1)
    {
        DayPlanClassController *sub = [[DayPlanClassController alloc] init];
        sub.title = @"请选择计划类型";
        sub.block = ^(NSString *str)
        {
            JCKLog(@"%@",str);
            // 分隔字符串
            NSArray *array = [str componentsSeparatedByString:@","]; //从字符A中分隔成2个元素的数组
            classStr = array[0];
            classStrID = array[1];
            UILabel *lb = (UILabel *)[_tableView viewWithTag:5000];
            lb.text = classStr;
        };
        [self.navigationController pushViewController:sub animated:YES];
    }
    else  if (indexPath.section == 0 && indexPath.row == 2)
    {
        DayPlanDirectionController *sub = [[DayPlanDirectionController alloc] init];
        sub.title = @"请选择领域";
        sub.block = ^(NSString *str)
        {
            JCKLog(@"%@",str);
            // 分隔字符串
            NSArray *array = [str componentsSeparatedByString:@","]; //从字符A中分隔成2个元素的数组
            custon = array[0];
            custonID = array[1];
            UILabel *lb = (UILabel *)[_tableView viewWithTag:5002];
            lb.text = custon;
        };
        [self.navigationController pushViewController:sub animated:YES];
        
    }

}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 20000:
        {
            model.title = textField.text;
        }
            break;
        case 20001:
        {
            model.starDate = textField.text;
        }
            break;
        case 20002:
        {
            model.endDate = textField.text;
        }
            break;
            
        default:
            break;
    }
    return YES;
}
#pragma mark - textViewdelegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([tv.text isEqualToString:@"点击输入工作计划内容"])
    {
        tv.text=@"";
    }
    tv.textColor = [UIColor blackColor];
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if ( tv.text.length == 0)
    {
        tv.text=@"点击输入工作计划内容";
        tv.textColor = [UIColor lightGrayColor];
    }
    return YES;
}
- (void)commentTableViewTouchInSide{
    [tv resignFirstResponder];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [tv resignFirstResponder];
}
-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
//        showSwitchValue.text = @"是";
    }else {
//        showSwitchValue.text = @"否";
    }
}
- (void)savePlan
{
    if (model.title.length == 0 || classStrID.length == 0 ||custonID.length == 0 ||dateCycle.length == 0 ||model.starDate.length == 0 ||model.endDate.length == 0 ||tv.text.length == 0 ||important.length == 0 )
    {
        //初始化提示框；
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"部分信息为空,请补全" preferredStyle: UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //点击按钮的响应事件；
        }]];
        
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }
    else
    {
        if ([dateCycle isEqualToString:@"日计划"])
        {
            dateCycle = @"1";
        }
        else if ([dateCycle isEqualToString:@"周计划"]) {
            dateCycle = @"2";
        }
        else if ([dateCycle isEqualToString:@"月计划"]) {
            dateCycle = @"3";
        }
        else if ([dateCycle isEqualToString:@"季度计划"]) {
            dateCycle = @"4";
        }
        else if ([dateCycle isEqualToString:@"年度计划"]) {
            dateCycle = @"5";
        }
        if ([important isEqualToString:@"重要"])
        {
            important = @"2";
        }
        else if ([important isEqualToString:@"一般"])
        {
            important = @"4";
        }
        NetManger *manger = [NetManger shareInstance];
        //    NSArray *testdata = @[model.title,classStrID,custonID,dateCycle,model.starDate,model.endDate,tv.text];
        //    JCKLog(@"%@",testdata);
        manger.planaimsaves = @[model.title,classStrID,custonID,dateCycle,model.starDate,model.endDate,tv.text,important];

        [manger loadData:RequestOfPlanaimsave];
        [self.navigationController popViewControllerAnimated:YES];
    }

}
#pragma mark - Tool
- (NSString *)getData
{
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    
    return locationString;
}
@end

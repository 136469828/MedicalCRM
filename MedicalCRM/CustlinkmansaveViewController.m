//
//  CustlinkmansaveViewController.m
//  MedicalCRM
//
//  Created by admin on 16/7/22.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "CustlinkmansaveViewController.h"
#import "NetManger.h"
#import "ProjectBuildCell.h"
#import "KeyboardToolBar.h"
#import "SelectViewController.h"
#import "CLinkmanModel.h"
#import "CustInfoViewController.h"
#import "CustomerListViewController.h"
@interface CustlinkmansaveViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    // CustNo，LinkManName，Sex，Company，Department，Position，WorkTel，MailAddress，QQ，Age
    NSArray *titles;
    NSArray *placeholders;
    CLinkmanModel *model;
    NSString *Sex;
    NSString *cosName;
}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CustlinkmansaveViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    model = [CLinkmanModel shareInstance];
    // Do any additional setup after loading the view.
    titles = @[@"客户名称:",
               @"性别:",
               @"工作电话:",
               @"部门:",
               @"职位:",
               @"邮箱:",
               @"QQ:",
               @"年龄",
               @"备注:"];
    placeholders = @[@"必填",
                     @"点击选择",
                     @"必填",
                     @"选填",
                     @"选填",
                     @"选填",
                     @"选填",
                     @"选填",
                     @"选填",
                     @"选填"];
    [self setTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-60) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(40,10,ScreenWidth-80,40);
    btn.backgroundColor = [UIColor orangeColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.layer.cornerRadius = 5;
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buildProject) forControlEvents:UIControlEventTouchDown];
    [bg addSubview:btn];
    self.tableView.tableFooterView = bg;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titles.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section // 返回组的头宽
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectBuildCell *cell = [ProjectBuildCell selectedCell:tableView];
    if (indexPath.row == 1)
    {
        cell.textField.hidden = YES;
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(128, 5, ScreenWidth-148, 34)];
        lb.text = Sex;
        lb.textAlignment = NSTextAlignmentRight;
        lb.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:lb];
    }
    if (indexPath.row == 9)
    {
        cell.textField.hidden = YES;
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(128, 5, ScreenWidth-148, 34)];
        lb.text = cosName;
        lb.textAlignment = NSTextAlignmentRight;
        lb.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:lb];
    }
    cell.textField.placeholder = placeholders[indexPath.row];
    cell.textField.delegate = self;
    cell.textField.tag = indexPath.row +10000;
    switch (indexPath.row) {
        case 0:
        {
            if (model.linkManName)
            {
                cell.textField.text = model.linkManName;
            }
        }
            break;
        case 2:
        {
            if (model.tel)
            {
                cell.textField.text = model.tel;
            }
        }
            break;
        case 3:
        {
            if (model.department)
            {
                cell.textField.text = model.department;
            }
        }
            break;
        case 4:
        {
            if (model.position)
            {
                cell.textField.text = model.position;
            }
        }
            break;
        case 5:
        {
            if (model.Email)
            {
                cell.textField.text = model.Email;
            }
        }
            break;
        case 6:
        {
            if (model.QQ)
            {
                cell.textField.text = model.QQ;
            }
        }
            break;
        case 7:
        {
            if (model.age)
            {
                cell.textField.text = model.age;
            }
        }
            break;
        case 8:
        {
            if (model.remark)
            {
                cell.textField.text = model.remark;
            }
        }
            break;
            
        default:
            break;
    }
    [KeyboardToolBar registerKeyboardToolBar:cell.textField];
    cell.titleLab.text = [NSString stringWithFormat:@"%@",titles[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        SelectViewController *sub = [[SelectViewController alloc] init];
        sub.title = @"选择性别";
        sub.block = ^(NSString *str)
        {
            Sex = str;
            [self.tableView reloadData];
            
        };
        
        [self.navigationController pushViewController:sub animated:YES];
        
    }
    if (indexPath.row == 9)
    {
//        CustomerListViewController *sub = [[CustomerListViewController alloc] init];
//        sub.title = @"请选择";
//        sub.block = ^(NSInteger ID, NSString *str , NSString *phone,NSString *num)
//        {
//            JCKLog(@"%@",str);
////            _CustNo = num;
////            cosName = str;
////            if ([cosName isEqualToString:@"待定"])
////            {
////                cosName = @"未填写";
////            }
////            [self.tableView reloadData];
//        };
//        [self.navigationController pushViewController:sub animated:YES];

    }
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
        // CustNo，LinkManName，Sex，Company，Department，Position，WorkTel，MailAddress，QQ，Age
    switch (textField.tag)
    {
            
        case 10000:
        {
            model.linkManName = textField.text;
        }
            break;
        case 10002:
        {
            model.tel = textField.text;
        }
            break;
        case 10003:
        {
            model.department = textField.text;
        }
            break;
        case 10004:
        {
            model.position = textField.text;
        }
            break;

        case 10005:
        {
            model.Email = textField.text;
        }
            break;
        case 10006:
        {
            model.QQ = textField.text;
        }
            break;
        case 10007:
        {
            model.age = textField.text;
        }
            break;
        case 10008:
        {
            model.remark = textField.text;
        }
            break;


        default:
            break;
    }
    return YES;
}
- (void)buildProject
{
 /*
  @"CustNo"      : custlinkmaninfos[0],
  @"LinkManName" : custlinkmaninfos[1],
  @"Sex"         : custlinkmaninfos[2],
  //                                 @"Company"     : custlinkmaninfos[3],
  @"Remark": custlinkmaninfos[3],
  @"Department"  : custlinkmaninfos[4],
  @"Position"    : custlinkmaninfos[5],
  @"WorkTel"     : custlinkmaninfos[6],
  @"MailAddress" : custlinkmaninfos[7],
  @"QQ"          : custlinkmaninfos[8],
  @"Age"         : custlinkmaninfos[9],
  */
//    NSLog(@"%@ %@ %@ %@",ContactName,ContactTel,SellArea,City);

    if (model.linkManName.length != 0 && Sex.length != 0 && model.tel.length != 0 && model.department.length != 0 && model.position.length != 0 && _CustNo.length != 0)
    {
        if ([Sex isEqualToString:@"男"]) {
            Sex = @"1";
        }
        else
        {
            Sex = @"2";
        }
        if (!model.remark) {
            model.remark = @"";
        }
        if (!model.Email) {
            model.Email = @"";
        }
        if (!model.age) {
            model.age = @"";
        }
        if (!model.QQ) {
            model.QQ = @"";
        }
        NetManger * manger = [NetManger shareInstance];
        manger.custlinkmaninfo = @[_CustNo,model.linkManName,Sex,model.remark,model.department,model.position,model.tel,model.Email,model.QQ,model.age];
        [manger loadData:RequestOfCustlinkmansave];
        model = nil;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popCtr) name:@"custlinkmansave" object:nil];
    }
    else
    {
        //初始化提示框；
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"部分信息为空,请补全" preferredStyle: UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //点击按钮的响应事件；
        }]];
        
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }
}

- (void)popCtr
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end

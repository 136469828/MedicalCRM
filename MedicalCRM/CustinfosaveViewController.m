//
//  CustinfosaveViewController.m
//  MedicalCRM
//
//  Created by admin on 16/7/22.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "CustinfosaveViewController.h"
#import "NetManger.h"
#import "ProjectBuildCell.h"
#import "KeyboardToolBar.h"
#import "AreaViewController.h"
#import "CustlinkmansaveViewController.h"
#import "CLinkmansaveMdeol.h"
@interface CustinfosaveViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSArray *titles;
    NSArray *placeholders;
    NSString *ContactName;
    NSString *City;
    NSString *ContactTel;
    NSString *SellArea;
    NSArray *text;
    CLinkmansaveMdeol *model;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation CustinfosaveViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    model = [CLinkmansaveMdeol shareInstance];
    // Do any additional setup after loading the view.
//    text = @[@[model.comName,model.cicy,model.adress],@[model.tel,model.phone,model.eMail,model.aress,model.remark]];
    titles = @[@[@"客户(公司)名称:",
               @"所在城市:",
               @"经营范围:",],
               @[@"工作电话:",
               @"手    机:",
               @"邮    箱:",
               @"联系地址:",
               @"备    注:"]];
    placeholders = @[@[@"必填",
                     @"点击选择",
                     @"必填",],
                     @[@"点击填写",
                       @"选填",
                       @"选填",
                       @"选填",
                       @"备注"]];

    [self setTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-56) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-65 - 64, ScreenWidth, 60)];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(40,10,ScreenWidth-80,40);
    btn.backgroundColor = [UIColor orangeColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.layer.cornerRadius = 5;
    [btn setTitle:@"提交我的拜访" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buildProject) forControlEvents:UIControlEventTouchDown];
    [bg addSubview:btn];
    //    [self.view addSubview:bg];
    _tableView.tableFooterView = bg;
    [self.view addSubview:_tableView];
    
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    return 5;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView // 一个表视图里面有多少组
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section // 返回组的头宽
{
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section   // 返回一个UIView作为头视图
{
    if (section == 1)
    {
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        UILabel *lb1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth, 20)];
        lb1.textColor = RGB(172, 172, 172);
        lb1.font = [UIFont systemFontOfSize:13];
        lb1.text = @"联系方式";
        [bg addSubview:lb1];
        return bg;
    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectBuildCell *cell = [ProjectBuildCell selectedCell:tableView];
    if (indexPath.section == 0)
    {
        if (indexPath.row == 1)
        {
            cell.textField.hidden = YES;
            UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(128, 5, ScreenWidth-148, 34 )];
            lb.text = City;
            lb.textAlignment = NSTextAlignmentRight;
            lb.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:lb];
        }
        cell.textField.placeholder = placeholders[indexPath.section][indexPath.row];
        switch (indexPath.row) {
            case 0:
            {
                if (model.comName)
                {
                    cell.textField.text = model.comName;
                }
            }
                break;
            case 2:
            {
                if (model.aress)
                {
                    cell.textField.text = model.aress;
                }
            }
                break;
            default:
                break;
        }
        cell.textField.delegate = self;
        cell.textField.tag = indexPath.row +9000;
        [KeyboardToolBar registerKeyboardToolBar:cell.textField];
        cell.titleLab.text = [NSString stringWithFormat:@"%@",titles[indexPath.section][indexPath.row]];
        return cell;
    }
    cell.textField.placeholder = placeholders[indexPath.section][indexPath.row];
    switch (indexPath.row) {
        case 0:
        {
            if (model.tel)
            {
                cell.textField.text = model.tel;
            }
        }
            break;
        case 1:
        {
            if (model.phone)
            {
                cell.textField.text = model.phone;
            }
        }
            break;
        case 2:
        {
            if (model.eMail)
            {
                cell.textField.text = model.eMail;
            }
        }
            break;
        case 3:
        {
            if (model.adress)
            {
                cell.textField.text = model.adress;
            }
        }
            break;
        case 4:
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
    cell.textField.delegate = self;
    cell.textField.tag = indexPath.row +8000;
    [KeyboardToolBar registerKeyboardToolBar:cell.textField];
    cell.titleLab.text = [NSString stringWithFormat:@"%@",titles[indexPath.section][indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1) {
        AreaViewController *sub = [[AreaViewController alloc] init];
        sub.title = @"选择地区";
        sub.block = ^(NSString *str){
            City = str;
            [self.tableView reloadData];
            
        };
        [self.navigationController pushViewController:sub animated:YES];

    }
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    switch (textField.tag)
    {
            
        case 9000:
        {
            model.comName = textField.text;
        }
            break;
        case 9002:
        {
            model.aress = textField.text;
        }
            break;
        case 8000:
        {
            model.tel = textField.text;
        }
            break;
        case 8001:
        {
            model.phone = textField.text;
        }
            break;
        case 8002:
        {
            model.eMail = textField.text;
        }
            break;
        case 8003:
        {
            model.adress = textField.text;
        }
            break;
        case 8004:
        {
            model.remark = textField.text;
        }
            break;
    }

    return YES;
}
- (void)buildProject
{
/*
 @"CustName": custininfos[0],
 @"City": custininfos[1],
 @"Tel": custininfos[2],
 @"Mobile": custininfos[3],
 @"SellArea": custininfos[4],
 @"email": custininfos[5],
 @"Address": custininfos[6],
 @"Remark": custininfos[7],
 */
    if (model.comName.length != 0 && model.aress.length != 0 && model.tel.length != 0 && City.length != 0)
    {
        NetManger * manger = [NetManger shareInstance];
        JCKLog(@"%@",model);
        if (!model.phone) {
            model.phone = @"未填写";
        }
        if (!model.eMail) {
            model.eMail = @"未填写";
        }
        if (!model.adress) {
            model.adress = @"未填写";
        }
        if (!model.remark) {
            model.remark = @"无";
        }
        manger.custinfoinfo = @[model.comName,City,model.tel,model.phone,model.aress,model.eMail,model.adress,model.remark];
        [manger loadData:RequestOfCustinfosave];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popCtr:) name:@"custinfosave" object:nil];
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

- (void)popCtr:(NSNotification *)obj
{
    NSLog(@"%@",obj.userInfo);
    //初始化提示框；
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否完善客户联系人信息" preferredStyle: UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        CustlinkmansaveViewController *sub = [[CustlinkmansaveViewController alloc] init];
        sub.title = @"新建客户联系人";
        [self.navigationController pushViewController:sub animated:YES];

    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}
@end

//
//  ProjectBuildViewController.m
//  MedicalCRM
//
//  Created by admin on 16/7/20.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "ProjectBuildViewController.h"
#import "KeyboardToolBar.h"
#import "ProBuildModel.h"
#import "ProjectBuildCell.h"
#import "DayPlanDirectionController.h"
#import "NetManger.h"
#import "AreaViewController.h"
#import "AddFriendListViewController.h"
#import "TheNewCustomerViewController.h"
#import "EquipmentListViewController.h"
@interface ProjectBuildViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSArray *titles;
    NSArray *placeholders;
    NSArray *values;
    ProBuildModel *model;
    NSString *ProjectDirectionId;
//    NSString *projectAddress;
    NSString *projectCustor;
    NSString *cusId;
    NSString *diqu;
    NSString *ProjectDirection;
    NSArray *friends;
    NSArray *proTimeList;
    UIPickerView *pickerView;
    NSArray *data_id;
    NSArray *demoMachiNames;
    NSArray *demoMachiIDs;
}
@property (nonatomic, strong) UIView *closeV;
@property (nonatomic, strong) UIView *labelView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *m_arrs;
@property (nonatomic, strong) NSArray *bulidDatas;
@end

@implementation ProjectBuildViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_tableView endEditing:YES];
    _tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 69);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    model = [ProBuildModel shareInstance];
    // Do any additional setup after loading the view.
    titles = @[@"项目名:",
               @"项目金额(元):",
               @"项目领域:",
               @"我的成功率:",
               @"客户名:",
               @"客户电话:",
               @"所属单位:",
               @"项目所属地区:",
               @"相关人员:",
               @"机型:",
               @"数量:",
               @"项目时间计划:",
               @"项目内容:"];
    placeholders = @[@"点击输入",@"选填",@"点击输入",@"点击输入",@"点击输入",@"点击输入",@" ",@"",@"",@"选填",@"选填",@"选填",@"选填",@"选填",@"选填",@"选填"];

    [self setTableView];

}
-(CGFloat)keyboardEndingFrameHeight:(NSDictionary *)userInfo//计算键盘的高度
{
    CGRect keyboardEndingUncorrectedFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGRect keyboardEndingFrame = [self.view convertRect:keyboardEndingUncorrectedFrame fromView:nil];
    return keyboardEndingFrame.size.height;
}
-(void)keyboardWillAppear:(NSNotification *)notification
{
    CGRect currentFrame = self.view.frame;
    CGFloat change = [self keyboardEndingFrameHeight:[notification userInfo]];
    currentFrame.origin.y = currentFrame.origin.y - change ;
    self.view.frame = currentFrame;
}
// 当键盘消失后，视图需要恢复原状。
-(void)keyboardWillDisappear:(NSNotification *)notification
{
    CGRect currentFrame = CGRectMake(0, -ScreenHeight/2+49, ScreenWidth, ScreenHeight - 69);
    CGFloat change = [self keyboardEndingFrameHeight:[notification userInfo]];
    currentFrame.origin.y = currentFrame.origin.y + change ;
    self.view.frame = currentFrame;
}
#pragma mark -
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-69) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60 + 70)];
    
    UIButton *upFild = [UIButton buttonWithType:UIButtonTypeCustom];
    upFild.frame = CGRectMake(12, 10, 50, 50);
    [upFild setBackgroundImage:[UIImage imageNamed:@"addFild"] forState:UIControlStateNormal];
    [upFild addTarget:self action:@selector(addFild) forControlEvents:UIControlEventTouchDown];
    [bg addSubview:upFild];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(40,10+70,ScreenWidth-80,40);
    btn.backgroundColor = [UIColor orangeColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.layer.cornerRadius = 5;
    [btn setTitle:@"申报" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buildProject) forControlEvents:UIControlEventTouchDown];
    [bg addSubview:btn];
    self.tableView.tableFooterView = bg;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    cell.textField.placeholder = @"点击输入";
    cell.textField.delegate = self;
    cell.textField.tag = indexPath.row +8000;
    [KeyboardToolBar registerKeyboardToolBar:cell.textField];
    cell.titleLab.text = [NSString stringWithFormat:@"%@",titles[indexPath.row]];
    switch (indexPath.row) {
        case 0:
        {
            if (model.name)
            {
                cell.textField.text = model.name;
            }
        }
            break;
        case 1:
        {
            cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
            if (model.price)
            {
                cell.textField.text = model.price;
                
            }
            
        }
            break;
        case 2:
        {
            cell.textField.hidden = YES;
            UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*0.35, 0, ScreenWidth-ScreenWidth*0.35-18, 44)];
            lb.font = [UIFont systemFontOfSize:13];
            lb.textAlignment = NSTextAlignmentRight;
            lb.tag = 5002;
            if (ProjectDirection)
            {
                lb.text = ProjectDirection;
            }
            else
            {
                lb.text = @"点击选择";
            }
            [cell.contentView addSubview:lb];
            
        }
            break;

        case 3:
        {
            cell.textField.hidden = YES;
            UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*0.35, 0, ScreenWidth-ScreenWidth*0.35-18, 44)];
            lb.font = [UIFont systemFontOfSize:13];
            lb.textAlignment = NSTextAlignmentRight;
            //            lb.tag = 5002;
            if (model.success)
            {
                lb.text = model.success;
            }
            else
            {
                lb.text = @"点击选择";
            }
            [cell.contentView addSubview:lb];

        }
            break;
        case 4:
        {
            cell.textField.hidden = YES;
            UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*0.35, 0, ScreenWidth-ScreenWidth*0.35-18, 44)];
            lb.font = [UIFont systemFontOfSize:13];
            lb.textAlignment = NSTextAlignmentRight;
            //            lb.tag = 5002;
            if (model.liinkMan)
            {
                lb.text = model.liinkMan;
            }
            else
            {
                lb.text = @"点击选择";
            }
            [cell.contentView addSubview:lb];
            
        }
            break;
        case 5:
        {
            cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
            if (model.tel)
            {
                cell.textField.text = model.tel;
                
            }
        }
            break;
        case 6:
        {
            if (model.adress)
            {
                cell.textField.text = model.adress;
            }
            else
            {
                model.adress = @"点击输入";
                cell.textField.text = model.adress;
            }

        }
            break;
        case 7:
        {
            cell.textField.hidden = YES;
            UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*0.35, 0, ScreenWidth-ScreenWidth*0.35-18, 44)];
            lb.font = [UIFont systemFontOfSize:13];
            lb.textAlignment = NSTextAlignmentRight;
            lb.tag = 6000;
            if (diqu)
            {
                lb.text = diqu;
            }
            else
            {
                diqu = @"深圳";
                lb.text = diqu;
            }
            [cell.contentView addSubview:lb];
        }
            break;
        case 8:
        {
            cell.textField.hidden = YES;
            
            UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*0.35, 0, ScreenWidth-ScreenWidth*0.35-18, 44)];
            lb.font = [UIFont systemFontOfSize:13];
            lb.textAlignment = NSTextAlignmentRight;
            lb.tag = 10000;
            if (friends)
            {
                NSString *string = [friends componentsJoinedByString:@","];//--分隔符
                lb.text = [NSString stringWithFormat:@"%@",string];
            }
            else
            {
                lb.text = @"点击选择";
            }
            [cell.contentView addSubview:lb];
        }
            break;
        case 9:
        {
            cell.textField.hidden = YES;
            
            UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*0.35, 0, ScreenWidth-ScreenWidth*0.35-18, 44)];
            lb.font = [UIFont systemFontOfSize:13];
            lb.textAlignment = NSTextAlignmentRight;
            lb.tag = 4001;
            if ( model.demoMachiName)
            {
                lb.text =  model.demoMachiName;
            }
            else
            {
                lb.text = @"点击选择";
            }
            [cell.contentView addSubview:lb];
        }
            break;
        default:
            break;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 4)
    {
        TheNewCustomerViewController *sub = [[TheNewCustomerViewController alloc] init];
        sub.title = @"客户列表";
        sub.block = ^(NSString *str, NSString *ID, NSString *phone,NSString *CompanyName,NSString *linkID)
        {
            model.cusId = ID;
            model.liinkMan = str;
            model.tel = phone;
            if ([CompanyName isEqualToString:@"待定"]) {
                CompanyName = @"未填写";
            }
            model.adress = CompanyName;
            [tableView reloadData];
        };
        [self.navigationController pushViewController:sub animated:YES];
    }
    if (indexPath.row == 3)
    {
        [self setPickView];
    }
    if (indexPath.row == 2)
    {
        DayPlanDirectionController *sub = [[DayPlanDirectionController alloc] init];
        sub.title = @"请选择项目领域";
        sub.block = ^(NSString *str)
        {
            JCKLog(@"%@",str);
            // 分隔字符串
            NSArray *array = [str componentsSeparatedByString:@","]; //从字符A中分隔成2个元素的数组
            ProjectDirection = array[0];
            ProjectDirectionId = array[1];
            UILabel *lb = (UILabel *)[_tableView viewWithTag:5002];
            lb.text = ProjectDirection;
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:5 inSection:0];
            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        };
        [self.navigationController pushViewController:sub animated:YES];
        
    }
    if (indexPath.row == 7)
    {
        AreaViewController *sub = [[AreaViewController alloc] init];
        sub.title = @"选择地区";
        sub.block = ^(NSString *str){
            diqu = str;
            [self.tableView reloadData];
            
        };
        UILabel *lb = (UILabel *)[_tableView viewWithTag:6000];
        lb.text = diqu;
        [self.navigationController pushViewController:sub animated:YES];
    }
    if (indexPath.row == 8) // 相关人员
    {
        AddFriendListViewController *sub = [[AddFriendListViewController alloc] init];
        sub.title = @"选择相关人员";
        sub.isNogroup = 1;
        sub.hidesBottomBarWhenPushed = YES;
        sub.block = ^(NSArray *datas,NSArray *data_ID)
        {
            friends = datas;
            data_id = data_ID;
            [_tableView reloadData];
        };
        [self.navigationController pushViewController:sub animated:YES];
    }
    if (indexPath.row == 9) // 样机机型
    {
        EquipmentListViewController *sub = [[EquipmentListViewController alloc] init];
        sub.title = @"选择样机名";
        sub.block = ^(NSArray *names,NSArray *IDs)
        {
            NSString *ns=[names componentsJoinedByString:@","];
            demoMachiNames = names;
            demoMachiIDs = IDs;
            UILabel *lb = (UILabel *)[_tableView viewWithTag:4001];
            model.demoMachiName = ns;
            lb.text = model.demoMachiName;
//            model.demoMachiId = ID;
        };
        [self.navigationController pushViewController:sub animated:YES];
    }
}
#pragma mark -textField
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
        switch (textField.tag)
        {
                
            case 8000:
            {
                model.name = textField.text;
            }
                break;
            case 8001:
            {
                model.price = textField.text;
            }
                break;
            case 8005:
            {
                model.tel = textField.text;
            }
                break;
            case 8007:
            {
                model.adress = textField.text;
            }
                break;
            case 8010:
            {
                model.demoMaCount = textField.text;
            }
                break;
            case 8011:// 时间计划
            {
                model.datePlanDesc = textField.text;
            }
                break;
            case 8012:// 项目内容
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

    if (model.name.length != 0 &&
        model.adress.length != 0 &&
        model.liinkMan.length != 0 &&
        model.tel.length != 0 &&
        model.price.length != 0 &&
        model.success.length != 0 &&
        ProjectDirectionId.length != 0 &&
        data_id.count != 0 &&
        diqu.length !=0 &&
        model.cusId.length !=0 &&
        model.demoMaCount != 0)
    {
        [_m_arrs removeAllObjects];
        for (int i = 0; i<demoMachiIDs.count; i++)
        {
            NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
            [m_dic setObject:demoMachiIDs[i] forKey:@"ProductID"];
            [m_dic setObject:model.demoMaCount forKey:@"ProductCount"];
            if (!_m_arrs) {
                _m_arrs = [NSMutableArray array];
            }
            [_m_arrs addObject:m_dic];
        }
        JCKLog(@"%@",_m_arrs);
        if (model.remark.length == 0)
        {
            model.remark = @"无";
        }
        if (model.datePlanDesc.length == 0)
        {
            model.datePlanDesc = @"无";
        }
       float flo = [[model.success substringToIndex:2] floatValue]*0.01;
        if ([model.success isEqualToString:@"100%"])
        {
            flo = 1.0f;
        }
        JCKLog(@"%@",data_id);
        /*
         @"ProjectName": projectsaves[0],
         @"Address": projectsaves[1],
         @"CustLinkMan": projectsaves[2],
         @"CustLinkTel": projectsaves[3],
         @"Investment":projectsaves[4],
         @"SuccessRate": projectsaves[5],
         @"Remark":projectsaves[6],
         @"ProjectDirectionId": projectsaves[7],
         @"CustID":projectsaves[8],
         @"CanViewUser": projectsaves[9],
         @"DatePlanDesc": projectsaves[10],
         @"Detailstr": detailstr
         
         */
        NetManger * manger = [NetManger shareInstance];
        manger.projectsaves = @[model.name,
                                [NSString stringWithFormat:@"%@%@",model.adress,diqu],
                                model.liinkMan,
                                model.tel,
                                model.price,
                                [NSString stringWithFormat:@"%.1f",flo],
                                model.remark,// 项目内容
                                ProjectDirectionId,
                                model.cusId,
                                [data_id componentsJoinedByString:@","],
                                model.datePlanDesc,
                                _m_arrs];
        [manger loadData:RequestOfProjectsave];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popCtr) name:@"projectsave" object:nil];
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
//        [_m_arrs removeAllObjects];
//        for (int i = 0; i<demoMachiIDs.count; i++)
//        {
//            NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
//            [m_dic setObject:demoMachiIDs[i] forKey:@"ProductID"];
//            [m_dic setObject:model.demoMaCount forKey:@"ProductCount"];
//            if (!_m_arrs) {
//                _m_arrs = [NSMutableArray array];
//            }
//            [_m_arrs addObject:m_dic];
//        }
//        float flo = [[model.success substringToIndex:2] floatValue]*0.01;
//        if ([model.success isEqualToString:@"100%"])
//        {
//            flo = 1.0f;
//        }
//
//        _bulidDatas = @[@"",
//                       [NSString stringWithFormat:@"%@%@",model.adress,diqu],
//                       model.liinkMan,
//                       model.tel,
//                       model.price,
//                       [NSString stringWithFormat:@"%.1f",flo],
//                       model.remark,// 项目内容
//                       ProjectDirectionId,
//                       model.cusId,
//                       [data_id componentsJoinedByString:@","],
//                       model.datePlanDesc,
//                       _m_arrs];
//
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"" object:_bulidDatas];
//        int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
//        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index -2)] animated:YES];
    }
}
- (void)addFild
{
    //初始化提示框；
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"开发中" preferredStyle: UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}
- (void)popCtr
{

    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setPickView
{
    _labelView = [[UIView alloc] initWithFrame:CGRectMake(0,ScreenHeight - 216-80, ScreenWidth, 80)];
    _labelView.backgroundColor = [UIColor whiteColor];
    UIButton *cancelB = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelB.frame = CGRectMake(10,10, 40, 40);
    [cancelB setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [cancelB setTitle:@"取消" forState:UIControlStateNormal];
    [cancelB addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchDown];
    [self.labelView addSubview:cancelB];
    
    UIButton *clickB = [UIButton buttonWithType:UIButtonTypeCustom];
    clickB.frame = CGRectMake(ScreenWidth - 55,10, 40, 40);
    [clickB setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [clickB setTitle:@"确定" forState:UIControlStateNormal];
    [clickB addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [self.labelView addSubview:clickB];
    
    [self.view addSubview:_labelView];

    proTimeList = [[NSArray alloc]initWithObjects:@"10%",@"20%",@"30%",@"40%",@"50%",@"60%",@"70%",@"80%",@"90%",@"100%",nil];
    // 选择框
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,ScreenHeight-216, ScreenWidth, 216)];
    pickerView.backgroundColor = [UIColor whiteColor];
    // 显示选中框
    pickerView.showsSelectionIndicator=YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    [self.view addSubview:pickerView];
    
//    proTimeList = [[NSArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",nil];
}
#pragma Mark -- UIPickerViewDataSource
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {

    return [proTimeList count];
}
#pragma Mark -- UIPickerViewDelegate
// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {

    return 180;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString  *_proNameStr = [proTimeList objectAtIndex:row];
    NSLog(@"nameStr=%@",_proNameStr);
    model.success = _proNameStr;
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return [proTimeList objectAtIndex:row];
}
- (void)closeView{
    [self.closeV removeFromSuperview];
    [pickerView removeFromSuperview];
    [self.labelView removeFromSuperview];
    //一个cell刷新
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:0];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}
@end

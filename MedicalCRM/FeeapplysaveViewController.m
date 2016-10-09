//
//  FeeapplysaveViewController.m
//  MedicalCRM
//
//  Created by admin on 16/7/26.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "FeeapplysaveViewController.h"
#import "NetManger.h"
#import "XFDaterView.h"
#import "KeyboardToolBar.h"
#import "TheNewCustomerViewController.h"
#import "PublicClassViewController.h"
#import "FeeapplysaveModel.h"
#import "TheProjectListViewController.h"
@interface FeeapplysaveViewController ()<UITableViewDataSource,UITableViewDelegate,XFDaterViewDelegate,UITextFieldDelegate>
{
    NetManger *manger;
    NSArray *titles;
    XFDaterView*dater;
    NSArray *array;
    NSString *custom;
    NSString *payClass;
    FeeapplysaveModel *model;
    NSString *cusId;
    NSString *proID;
    NSString *proName;
}
@property (nonatomic ,strong) NSMutableArray *m_cutomArray;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation FeeapplysaveViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    model = [FeeapplysaveModel shareInstance];
    // Do any additional setup after loading the view.
    titles = @[@"标题",@"客户",@"费用分类",@"金额",@"申请时间",@"需要时间",@"原因",@"备注",@"关联项目:"];
    dater=[[XFDaterView alloc]initWithFrame:CGRectZero];
    dater.delegate=self;
    [self setTableView];
//#pragma mark - 设置navigationItem右侧按钮
//    UIButton *meassageBut = ({
//        UIButton *meassageBut = [UIButton buttonWithType:UIButtonTypeCustom];
//        meassageBut.frame = CGRectMake(0, 0, 40, 20);
//        meassageBut.titleLabel.font = [UIFont systemFontOfSize:15];
//        [meassageBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [meassageBut addTarget:self action:@selector(feeapplyAction) forControlEvents:UIControlEventTouchDown];
//        [meassageBut setTitle:@"提交" forState:UIControlStateNormal];
//        meassageBut;
//    });
//    
//    UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithCustomView:meassageBut];
//    self.navigationItem.rightBarButtonItem = rBtn;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDatas:) name:@"cuNameStr" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDatas2:) name:@"classStr" object:nil];
}
- (void)reloadDatas:(NSNotification *)obj
{
    JCKLog(@"客户ID%@",obj);
    [_m_cutomArray removeAllObjects];
    for (NSString *str in obj.object)
    {
        if (_m_cutomArray == nil)
        {
            _m_cutomArray = [NSMutableArray array];
        }
        [_m_cutomArray addObject:str];
    }
    UILabel *tf = (UILabel *)[_tableView viewWithTag:6000];
    custom = [NSString stringWithFormat:@"%@",[_m_cutomArray lastObject]];
    tf.text = custom;
}
- (void)reloadDatas2:(NSNotification *)obj
{
    JCKLog(@"分类ID%@",obj);
    // 分隔字符串
    NSString*string = obj.object;
    
    array = [string componentsSeparatedByString:@","]; //从字符A中分隔成2个元素的数组
    UILabel *tf = (UILabel *)[_tableView viewWithTag:7000];
    payClass = [NSString stringWithFormat:@"%@",array[1]];
    tf.text = payClass;
}
#pragma mark -
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-69) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //iOS 8开始的自适应高度，可以不需要实现定义高度的方法
//    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = 44;
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
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchDown];
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *allCell = @"cell";
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:allCell];
        cell.selectionStyle = UITableViewCellAccessoryNone;
    }
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(ScreenWidth*0.3, 0, ScreenWidth-ScreenWidth*0.3-20, 44)];
    tf.placeholder = @"点击填写";
    tf.textAlignment = NSTextAlignmentRight;
    tf.font = [UIFont systemFontOfSize:15];
    tf.delegate = self;
    tf.tag = 8000 + indexPath.row;
    [KeyboardToolBar registerKeyboardToolBar:tf];
    [cell.contentView addSubview:tf];
    switch (indexPath.row) {
        case 0:
        {
            if (model.title)
            {
                tf.text = model.title;
            }
        }
            break;
        case 3:
        {
            tf.keyboardType = UIKeyboardTypeDecimalPad;
            if (model.count)
            {
                tf.text = model.count;
            }
        }
            break;
        case 6:
        {
            if (model.reson)
            {
                tf.text = model.reson;
            }
        }
            break;
        case 7:
        {
            if (model.remark)
            {
                tf.text = model.remark;
            }
        }
            break;
            
        default:
            break;
    }
    if (indexPath.row == 1)
    {
        tf.hidden = YES;
        UILabel *dateLb = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*0.3, 0, ScreenWidth-ScreenWidth*0.3-20, 44)];
        dateLb.tag = 6000;
        dateLb.text = custom;
        dateLb.textAlignment = NSTextAlignmentRight;
        dateLb.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:dateLb];
    }
    else if (indexPath.row == 2)
    {
        tf.hidden = YES;
        UILabel *dateLb = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*0.3, 0, ScreenWidth-ScreenWidth*0.3-20, 44)];
        dateLb.tag = 7000;
        dateLb.text = payClass;
        dateLb.textAlignment = NSTextAlignmentRight;
        dateLb.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:dateLb];
    }
    else if (indexPath.row == 4)
    {
        tf.hidden = YES;
        UILabel *dateLb = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*0.3, 0, ScreenWidth-ScreenWidth*0.3-20, 44)];
        dateLb.tag = 4000;
        dateLb.text = [self getData];
        dateLb.textAlignment = NSTextAlignmentRight;
        dateLb.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:dateLb];
    }
    else if (indexPath.row == 5)
    {
        tf.hidden = YES;
        UILabel *dateLb = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*0.3, 0, ScreenWidth-ScreenWidth*0.3-20, 44)];
        dateLb.tag = 5000;
        dateLb.text = [self getData];
        dateLb.textAlignment = NSTextAlignmentRight;
        dateLb.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:dateLb];
    }
    else if (indexPath.row == 8)
    {
        tf.hidden = YES;
        UILabel *dateLb = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*0.3, 0, ScreenWidth-ScreenWidth*0.3-20, 44)];
        dateLb.tag = 5001;
        if (proName)
        {
            dateLb.text = proName;
        }
        {
            dateLb.text = @"点击选择";
        }
        
        dateLb.textAlignment = NSTextAlignmentRight;
        dateLb.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:dateLb];
    }

    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",titles[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 1:
        {
            TheNewCustomerViewController *sub = [[TheNewCustomerViewController alloc] init];
            sub.title = @"客户列表";
            sub.block = ^(NSString *str, NSString *ID, NSString *phone,NSString *CompanyName, NSString *linkId)
            {
                cusId = ID;
//                model.tel = phone;
                custom = str;
//                    self.yiyuanTf.text = CompanyName;
                [tableView reloadData];
            };
            [self.navigationController pushViewController:sub animated:YES];
        }
            break;
        case 2:
        {
            PublicClassViewController *sub = [[PublicClassViewController alloc] init];
            sub.title = @"点击选择费用分类";
            [self.navigationController pushViewController:sub animated:YES];
            
        }
            break;
        case 4:
        {
            dater.tag = 1000;
            [dater showInView:self.view animated:YES];
        }
            break;
        case 5:
        {
            dater.tag = 2000;
            [dater showInView:self.view animated:YES];
        }
            break;
        case 8:
        {
            
            TheProjectListViewController *sub = [[TheProjectListViewController alloc] init];
            sub.title = @"选择项目";
            sub.block = ^(NSString *str,NSString *ID){
                JCKLog(@"%@",str);
                
                UILabel *lb = (UILabel *)[_tableView viewWithTag:5001];
                proName = [str substringFromIndex:4];;
                lb.text = proName;
                proID = [NSString stringWithFormat:@"%@",ID];
            };
            [self.navigationController pushViewController:sub animated:YES];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - XFDaterViewDelegate
- (void)daterViewDidClicked:(XFDaterView *)daterView
{
    NSLog(@"dateString=%@ timeString=%@",dater.dateString,dater.timeString);
    if (dater.tag == 1000)
    {
        UILabel *tf = (UILabel *)[_tableView viewWithTag:4000];
        JCKLog(@"%d",[self compareDateWithSelectDate:dater.dateString]);
        if ([self compareDateWithSelectDate:dater.dateString] < 0)
        {
            //初始化提示框；
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"时间错误，请重新选择" preferredStyle: UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //点击按钮的响应事件；
            }]];
            
            //弹出提示框；
            [self presentViewController:alert animated:true completion:nil];
        }
        else
        {
            tf.text = dater.dateString;
        }
        
        
    }
    else
    {
        UILabel *tf = (UILabel *)[_tableView viewWithTag:5000];
        if ([self compareDateWithSelectDate:dater.dateString] < 0)
        {
            //初始化提示框；
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"时间错误，请重新选择" preferredStyle: UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //点击按钮的响应事件；
            }]];
            
            //弹出提示框；
            [self presentViewController:alert animated:true completion:nil];
        }
        else
        {
            tf.text = dater.dateString;
        }

    }
}
- (void)daterViewDidCancel:(XFDaterView *)daterView{
    
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 8000:
        {
            model.title = textField.text;
        }
            break;
        case 8003:
        {
            model.count = textField.text;
        }
            break;
        case 8006:
        {
            model.reson = textField.text;
        }
            break;
        case 8007:
        {
            model.remark = textField.text;
        }
            break;
            
        default:
            break;
    }
    return YES;
}
#pragma mark - BtnAction
- (void)btnAction
{
/*
 @"ExpID": @"", // 分类ID
 @"ExpType": @"", // 公共ID
 @"Amount": @"", // 数量
 @"ExpRemark": @"sample string 2" // 备注
 @"Title": feeapplys[0],
 @"CustID": feeapplys[1],
 @"AriseDate": feeapplys[2],
 @"NeedDate": feeapplys[3],
 @"Reason": feeapplys[4],
 @"ExpType": feeapplys[5],
 */
    UILabel *tf = (UILabel *)[_tableView viewWithTag:4000];
    UILabel *tf2 = (UILabel *)[_tableView viewWithTag:5000];
    UILabel *tf3 = (UILabel *)[_tableView viewWithTag:6000];
    UILabel *tf4 = (UILabel *)[_tableView viewWithTag:7000];
    if (model.title.length == 0 || model.count.length == 0 || model.reson.length == 0 || [tf3.text isEqualToString:@"点击选择客户"] || [tf4.text isEqualToString:@"点击选择费用分类"]||proID.length == 0)
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
        manger = [NetManger shareInstance];
        if (model.remark.length == 0) {
            model.remark = @"无";
        }
        manger.feeapplyDetails = @[array[2],array[0],model.count,model.remark];
        manger.feeapplys = @[model.title,cusId,tf.text,tf2.text,model.reson,array[2],proID];
        [manger loadData:RequestOfFeeapplysave];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popCtr) name:@"feeapplysave" object:nil];
    }

}
- (void)popCtr
{
    [self.navigationController popViewControllerAnimated:YES];
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
- (int)compareDateWithSelectDate:(NSString *)selectDate
{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
    [fomatter setDateFormat:@"YYYY-MM-dd"];
    NSString *curentDateStr = [fomatter stringFromDate:currentDate];
    currentDate = [fomatter dateFromString:curentDateStr];
    
    int result = [[fomatter dateFromString:selectDate] compare:currentDate];
    if(result == NSOrderedDescending)
    {
        return 1;
    }
    else if(result == NSOrderedAscending)
    {
        return -1;
    }
    return 0;
}
@end

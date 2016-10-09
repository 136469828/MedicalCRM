//
//  ProjectFollowViewController.m
//  MedicalCRM
//
//  Created by admin on 16/7/25.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "ProjectFollowViewController.h"
#import "ProjectFollow1TableViewCell.h"
#import "KeyboardToolBar.h"
#import "XFDaterView.h"
#import "NetManger.h"
@interface ProjectFollowViewController ()<UITableViewDataSource,UITableViewDelegate,XFDaterViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSArray *titles;
    NSArray *placeholder;
    XFDaterView *dater;
    NSString *costStr;
    NSString *artificialStr;
    NSString *progressStr;
    NSString *paperStr;
    NSString *remarkStr;
    UIPickerView *pickerView;
    NSArray *proTimeList;
}
@property (nonatomic, strong) UIView *closeV;
@property (nonatomic, strong) UIView *labelView;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ProjectFollowViewController
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
    remarkStr = @"无";
    titles = @[@"开始时间:",@"结束时间:",@"费用预算(￥):",@"人工数量(个):",@"进度占比:",@"进度摘要:",@"备注:"];
    placeholder = @[@"点击选择时间",@"点击选择时间",@"点击输入",@"点击输入",@"进度占比",@"点击输入",@"选填"];
    dater=[[XFDaterView alloc]initWithFrame:CGRectZero];
    dater.delegate=self;
    [self setTableView];
    
}
#pragma mark -
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-54) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //iOS 8开始的自适应高度，可以不需要实现定义高度的方法
//    self.tableView.rowHeight = 100;
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
    [btn addTarget:self action:@selector(followPro) forControlEvents:UIControlEventTouchDown];
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
    ProjectFollow1TableViewCell *cell = [ProjectFollow1TableViewCell selectedCell:tableView];
    if (indexPath.row == 0) {
        cell.textFild.hidden = YES;
        UILabel *dateLb = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*0.3, 0, ScreenWidth-ScreenWidth*0.3-10, 44)];
        dateLb.tag = 1000;
        dateLb.text = [self getData];
        dateLb.textAlignment = NSTextAlignmentRight;
        dateLb.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:dateLb];
    }
    if (indexPath.row == 1) {
        cell.textFild.hidden = YES;
        UILabel *dateLb = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*0.3, 0, ScreenWidth-ScreenWidth*0.3-10, 44)];
        dateLb.tag = 2000;
        dateLb.text = [self getData];
        dateLb.textAlignment = NSTextAlignmentRight;
        dateLb.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:dateLb];
    }
    if (indexPath.row == 4)
    {
        UILabel *dateLb = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*0.3, 0, ScreenWidth-ScreenWidth*0.3-10, 44)];
        
        dateLb.textAlignment = NSTextAlignmentRight;
        dateLb.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:dateLb];
        if (progressStr) {
            dateLb.text = progressStr;
        }
        else
        {
            dateLb.text = @"点击选择";
        }
        cell.textFild.hidden = YES;

    }
    cell.textFild.tag = 4000+indexPath.row;
    cell.textFild.delegate = self;
    cell.titles.text = [NSString stringWithFormat:@"%@",titles[indexPath.row]];
    cell.textFild.placeholder =  [NSString stringWithFormat:@"%@",placeholder[indexPath.row]];
    [KeyboardToolBar registerKeyboardToolBar:cell.textFild];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
//            dater.tag = 1000;
//            [dater showInView:self.view animated:YES];
        }
            break;
        case 1:
        {
            dater.tag = 2000;
            [dater showInView:self.view animated:YES];
        }
            break;
        case 4:
        {
            [self setPickView];
        }
            break;
        default:
            break;
    }
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 4002:
        {
            costStr = textField.text;
        }
            break;
        case 4003:
        {
            artificialStr = textField.text;
        }
            break;
//        case 4004:
//        {
//            progressStr = textField.text;
//        }
//            break;
        case 4005:
        {
            paperStr = textField.text;
        }
            break;
        case 4006:
        {
            remarkStr = textField.text;
        }
            break;
            
        default:
            break;
    }
    return YES;
}
#pragma mark - XFDaterViewDelegate
- (void)daterViewDidClicked:(XFDaterView *)daterView
{
    NSLog(@"dateString=%@ timeString=%@",dater.dateString,dater.timeString);
    if (dater.tag == 1000)
    {
        UILabel *tf = (UILabel *)[_tableView viewWithTag:1000];
        tf.text = dater.dateString;
    }
    else
    {
        UILabel *tf = (UILabel *)[_tableView viewWithTag:2000];
        tf.text = dater.dateString;
    }
}
- (void)daterViewDidCancel:(XFDaterView *)daterView{
    
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
    progressStr = _proNameStr;
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
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:4 inSection:0];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)followPro
{
    if (!paperStr || !artificialStr || !costStr || !progressStr )
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
        float flo = [[progressStr substringToIndex:2] floatValue]*0.01;
        if ([progressStr isEqualToString:@"100%"])
        {
            flo = 1.0f;
        }
        UILabel *tf = (UILabel *)   [_tableView viewWithTag:1000];
        UILabel *tf2 = (UILabel *)  [_tableView viewWithTag:2000];
        NetManger *manger = [NetManger shareInstance];
        manger.projectProcess = @[paperStr,self.ID,costStr,artificialStr,[NSString stringWithFormat:@"%.1f",flo],tf.text,tf2.text,remarkStr];
        JCKLog(@"%@",manger.projectProcess);
        [manger loadData:RequestOfProjectconstructiondetailssave];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popCtr) name:@"projectconstructiondetailssave" object:nil];
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
@end

//
//  ExhibitionbuildViewController.m
//  MedicalCRM
//
//  Created by admin on 16/8/4.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "ExhibitionbuildViewController.h"
#import "KeyboardToolBar.h"
#import "EquipmentListViewController.h"
#import "ExhibitionBulidModel.h"
#import "NetManger.h"
#import "XFDaterView.h"
#import "ExhibitionbuildCell.h"
#import "ExhibitionTextViewController.h"
@interface ExhibitionbuildViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,XFDaterViewDelegate>
{
    NSArray *titles;
    NSArray *pl;
    NSArray *scetionName;
    UITextView *tv;
    NSString *demoMachiName;
    ExhibitionBulidModel *model;
    XFDaterView*dater;
    NSString *demoMachiID;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *m_datas;
@end

@implementation ExhibitionbuildViewController
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
    model = [ExhibitionBulidModel shareInstance];
    dater=[[XFDaterView alloc]initWithFrame:CGRectZero];
    dater.delegate=self;
    [_m_datas removeAllObjects];
    if (!_m_datas) {
        _m_datas = [NSMutableArray array];
    }
    titles = @[@[@"展会名称"],
               @[@"联系人姓名",@"电话号码"],
               @[@"展会性质",@"参会人数",@"展会时间",@"展会地点"],
               @[@""],
               @[@""],
               @[@""],
               @[@"机器型号",@"归还日期"],
               @[@""]];
    scetionName = @[@"展会名称",@"主办方",@"展会相关详情",@"参展目标与计划",@"合作伙伴",@"赞助规格及其赞助(万元)",@"参展设备信息",@"竞争对手情况",];
    [self setTableView];
    [self setBottomView];
}
- (void)setBottomView{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,ScreenHeight-69 - 70, ScreenWidth, 80)];
    bottomView.backgroundColor = RGB(239, 239, 244);
    for (int i = 0; i<2; i++) {
        UIButton *bottomBtn         =
        [UIButton buttonWithType:UIButtonTypeCustom];
        
        bottomBtn.frame             =
        CGRectMake(i*(ScreenWidth/2)+10, 20, ScreenWidth/2-20, 40);
        bottomBtn.backgroundColor   =
        [UIColor orangeColor];
        [bottomBtn setTitle:@"提交" forState:UIControlStateNormal];
        if (i == 0)
        {
            [bottomBtn setTitle:@"保存" forState:UIControlStateNormal];
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
    [self.view addSubview: bottomView];
}
#pragma mark -
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 69 - 80) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //iOS 8开始的自适应高度，可以不需要实现定义高度的方法
//    self.tableView.estimatedRowHeight = 200;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
    
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTableViewTouchInSide)];
    tableViewGesture.numberOfTapsRequired = 1;
    tableViewGesture.cancelsTouchesInView = NO;
    [_tableView addGestureRecognizer:tableViewGesture];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView // 一个表视图里面有多少组
{
    return 8;
}
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 3:
        {
            return 80;
        }
            break;
        case 4:
        {
            return 80;
        }
            break;
        case 5:
        {
            return 80;
        }
            break;
        case 7:
        {
            return 80;
        }
            break;
            
        default:
            break;
    }
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1 || section == 6) {
        return 2;
    }
    else if (section == 2)
    {
        return 4;
    }
    return 1;
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
    tf.font = [UIFont systemFontOfSize:13];
    tf.delegate = self;
    tf.tag = 8000 + indexPath.row;
    if (model)
    {
        if (indexPath.section == 0)
        {
            tf.tag = 1000;
            if (model.Title)
            {
                 tf.text = model.Title;
            }
           
        }
        if (indexPath.section == 1 )
        {
            if (indexPath.row == 0)
            {
                tf.tag = 1001;
                if (model.LinkManName)
                {
                    tf.text = model.LinkManName;
                }
            }
            else
            {
                tf.tag = 1002;
                if (model.LinkTel)
                {
                    tf.text = model.LinkTel;
                }
            }
            
        }
        if (indexPath.section == 2 )
        {
            switch (indexPath.row) {
                case 0:
                {
                    tf.tag = 1003;
                    if (model.ExhibitionPlan)
                    {
                        tf.text = model.ExhibitionPlan;
                    }
                    
                }
                    break;

                case 1:
                {
                    tf.tag = 1004;
                    if (model.AttendPersons)
                    {
                        tf.text = model.AttendPersons;
                    }
                    
                }
                    break;
                case 3:
                {
                    tf.tag = 1005;
                    if (model.Address)
                    {
                        tf.text = model.Address;
                    }
                    
                }
                    break;


                default:
                    break;
            }
            
        }
    }
    
    [KeyboardToolBar registerKeyboardToolBar:tf];
    [cell.contentView addSubview:tf];
    switch (indexPath.section)
    {
        case 3:
        {
            tf.hidden = YES;
            UILabel *dateLb = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, ScreenWidth-20, 44)];
            dateLb.tag = 9993;
            dateLb.text = model.ExhibitionAim;
//                        dateLb.backgroundColor = [UIColor redColor];
            dateLb.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:dateLb];
        }
            break;
        case 4:
        {
             tf.hidden = YES;
            UILabel *dateLb = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, ScreenWidth-20, 44)];
            dateLb.tag = 9994;
            dateLb.text = model.UnionPartner;
//            dateLb.backgroundColor = [UIColor redColor];
            dateLb.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:dateLb];
            
        }
            break;
        case 5:
        {
             tf.hidden = YES;
            UILabel *dateLb = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, ScreenWidth-20, 44)];
            dateLb.tag = 9995;
            dateLb.text = model.PlanFee;
//                        dateLb.backgroundColor = [UIColor redColor];
            dateLb.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:dateLb];

        }
            break;
        case 7:
        {
            tf.hidden = YES;
            UILabel *dateLb = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, ScreenWidth-20, 44)];
            dateLb.tag = 9997;
            dateLb.text = model.Competitors;
//                        dateLb.backgroundColor = [UIColor redColor];
            dateLb.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:dateLb];

        }
            break;
        case 2:
        {
            // 开始时间
            if (indexPath.row == 2)
            {
                tf.hidden = YES;
                UILabel *dateLb = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*0.3, 0, ScreenWidth-ScreenWidth*0.3-20, 44)];
                dateLb.tag = 3000;
                if (model.ExhibitionStartDate || ![model.ExhibitionStartDate isEqualToString:@""])
                {
                    dateLb.text = model.ExhibitionStartDate;
                }
                else
                {
                    dateLb.text = @"点击选择日期";
                }
                
                dateLb.textAlignment = NSTextAlignmentRight;
                dateLb.font = [UIFont systemFontOfSize:15];
                [cell.contentView addSubview:dateLb];

            }
        }
            break;
        case 6:
        {
            tf.hidden = YES;
            if (indexPath.row == 0)
            {
                
                UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*0.3, 0, ScreenWidth-ScreenWidth*0.3-10, 44)];
                lb.font = [UIFont systemFontOfSize:13];
                lb.textAlignment = NSTextAlignmentRight;
                lb.tag = 4001;
                lb.text = demoMachiName;
                //        JCKLog(@"%ld",lb.tag);
                [cell.contentView addSubview:lb];
            }
            else if (indexPath.row == 1)
            {
                // 结束时间
                UILabel *dateLb = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*0.3, 0, ScreenWidth-ScreenWidth*0.3-20, 44)];
                dateLb.tag = 3001;
                if (model.ExhibitionEndDate || ![model.ExhibitionEndDate isEqualToString:@""])
                {
                    dateLb.text = model.ExhibitionEndDate;
                }
                else
                {
                    dateLb.text = @"点击选择日期";
                }
                
                dateLb.textAlignment = NSTextAlignmentRight;
                dateLb.font = [UIFont systemFontOfSize:15];
                [cell.contentView addSubview:dateLb];
            }
        }
            break;
        default:
            break;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",titles[indexPath.section][indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 6 && indexPath.row == 0) {
        EquipmentListViewController *sub = [[EquipmentListViewController alloc] init];
        sub.title = @"选择样机名";
//        sub.block = ^(NSString *str,NSString *ID){
//            //                JCKLog(@"%@",str);
//            UILabel *lb = (UILabel *)[_tableView viewWithTag:4001];
//            demoMachiName = str;
//            lb.text = demoMachiName;
//            demoMachiID = ID;
//        };
        sub.block = ^(NSArray *demoName,NSArray *demoIDs)
        {
            UILabel *lb = (UILabel *)[_tableView viewWithTag:4001];
            NSString *ns=[demoName componentsJoinedByString:@","];
            demoMachiName = ns;
            lb.text = demoMachiName;
            demoMachiID = demoIDs[0];
//            JCKLog(@"%@",model.demoMachiIDs[0]);
            //                    UILabel *lb = (UILabel *)[_tableView viewWithTag:4001];
            //                    model.demoMachiName = ns;
            //                    lb.text = model.demoMachiName;
            //                    //            model.demoMachiId = ID;
            [_tableView reloadData];
        };
//
//        sub.block = ^(NSArray *names,NSArray *IDs)
//        {
//            NSString *ns=[names componentsJoinedByString:@","];
//            UILabel *lb = (UILabel *)[_tableView viewWithTag:4001];
//            demoMachiName = ns;
//            lb.text = demoMachiName;
//            //            model.demoMachiId = ID;
//        };
        [self.navigationController pushViewController:sub animated:YES];
    }
    if (indexPath.section == 2 && indexPath.row == 2)
    {
        dater.tag = 30005;
        [dater showInView:self.view animated:YES];
    }
    if (indexPath.section == 6 && indexPath.row == 1)
    {
        dater.tag = 30006;
        [dater showInView:self.view animated:YES];
    }
    if (indexPath.section == 3 || indexPath.section == 4 || indexPath.section == 5 || indexPath.section == 7)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        ExhibitionTextViewController *sub = [[ExhibitionTextViewController alloc] init];
        sub.title = [NSString stringWithFormat:@"请输入%@",scetionName[indexPath.section]];
        sub.stpy = indexPath.section;
        sub.block = ^(NSString *str)
        {
            UILabel *lb = (UILabel *)[_tableView viewWithTag:9990+indexPath.section];
            switch (indexPath.section) {
                case 3:
                {
                    model.ExhibitionAim = str;
                    lb.text = model.ExhibitionAim;
                }
                    break;
                case 4:
                {
                    model.UnionPartner = str;
                    lb.text = model.UnionPartner;
                }
                    break;
                case 5:
                {
                    model.PlanFee = str;
                   lb.text = model.PlanFee;
                }
                    break;
                case 7:
                {
                    model.Competitors = str;
                    lb.text = model.Competitors;
                }
                    break;
                    
                default:
                    break;
            }
            [self.tableView reloadData];
            
        };
        [self.navigationController pushViewController:sub animated:YES];

    }
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 1000:
        {
            if(textField.text!=nil && [textField.text length]>0)
            {
                model.Title = textField.text;
                
            }
            else
            {
                model.Title  =@"";
            }
        }
            break;
        case 1001:
        {
            if(textField.text!=nil && [textField.text length]>0)
            {
                model.LinkManName = textField.text;
                
            }
            else
            {
                model.LinkManName  =@"";
            }
        }
            break;
        case 1002:
        {
            if(textField.text!=nil && [textField.text length]>0)
            {
                model.LinkTel = textField.text;
                
            }
            else
            {
                model.LinkTel  =@"";
            }
        }
            break;
        case 1003:
        {
            if(textField.text!=nil && [textField.text length]>0)
            {
                model.ExhibitionPlan = textField.text;
                
            }
            else
            {
                model.ExhibitionPlan  =@"";
            }
        }
            break;
        case 1004:
        {
            if(textField.text!=nil && [textField.text length]>0)
            {
                model.AttendPersons = textField.text;
                
            }
            else
            {
                model.AttendPersons  =@"";
            }
        }
            break;
        case 1005:
        {
            if(textField.text!=nil && [textField.text length]>0)
            {
                model.Address = textField.text;
                
            }
            else
            {
                model.Address  =@"";
            }
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
    if ([tv.text isEqualToString:@"点击填写"])
    {
        tv.text=@"";
    }
    tv.textColor = [UIColor blackColor];
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    JCKLog(@"-------%ld",tv.tag);
    switch (tv.tag) {
        case 3333:
        {
            model.ExhibitionPlan = tv.text;

        }
            break;
        case 3344:
        {
            model.UnionPartner = tv.text;

        }
            break;
        case 3355:
        {
            model.PlanFee = tv.text;

        }
            break;
        case 3366:
        {
            model.Competitors = tv.text;

        }
            break;
            
        default:
            break;
    }
    return YES;
}
- (void)commentTableViewTouchInSide{
    [_tableView endEditing:YES];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_tableView endEditing:YES];
}
#pragma mark - XFDaterViewDelegate
- (void)daterViewDidClicked:(XFDaterView *)daterView
{
//    NSLog(@"dateString=%@ timeString=%@",dater.dateString,dater.timeString);
    if (dater.tag == 30005)
    {
//        if
        if ([self compareDateWithSelectDate:dater.dateString] >= 0)
        {
            UILabel *tf = (UILabel *)[_tableView viewWithTag:3000];
            model.ExhibitionStartDate = dater.dateString;
            tf.text = model.ExhibitionStartDate;
        }
        else
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"输入日期错误" preferredStyle: UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //点击按钮的响应事件；
            }]];
            
            //弹出提示框；
            [self presentViewController:alert animated:true completion:nil];

        }
       
    }
    else if (dater.tag == 30006)
    {
        if ([self compareDateWithSelectDate:dater.dateString] >= 0 )
        {
            UILabel *tf = (UILabel *)[_tableView viewWithTag:3001];
            model.ExhibitionEndDate = dater.dateString;
            tf.text = model.ExhibitionEndDate;
        }
        else
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"输入日期错误" preferredStyle: UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //点击按钮的响应事件；
            }]];
            
            //弹出提示框；
            [self presentViewController:alert animated:true completion:nil];
            
        }
    }
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
- (void)daterViewDidCancel:(XFDaterView *)daterView{
    
}
- (void)bottomBtnAction:(UIButton *)btn
{
    /*
     @"LinkManName": self.zhanhuiSave[0],// 联系人
     @"LinkTel": self.zhanhuiSave[1], // 联系电话
     @"Title": self.zhanhuiSave[2],
     @"AttendPersons": self.zhanhuiSave[3],// 规模
     @"TotalMoney": self.zhanhuiSave[4], // 赞助
     @"ExhibitionStartDate": self.zhanhuiSave[5],//开展时间
     @"ExhibitionEndDate": self.zhanhuiSave[6],// 结束时间
     @"ExhibitionPlan": self.zhanhuiSave[7],// 计划
     @"ExhibitionAim": self.zhanhuiSave[8],//目标
     @"UnionPartner": self.zhanhuiSave[9],//合作伙伴
     @"PlanFee": self.zhanhuiSave[10],// 计划资金
     @"Competitors": self.zhanhuiSave[11], // 竞争对手
     @"Address": self.zhanhuiSave[12],// 地点
     @"Details":Details
     */
    JCKLog(@"%@",model);
    if (model.LinkManName &&
        model.LinkTel &&
        model.Title &&
        model.AttendPersons &&
        model.PlanFee &&
        model.ExhibitionStartDate &&
        model.ExhibitionEndDate&&
        model.ExhibitionPlan &&
        model.ExhibitionAim&&
        model.UnionPartner&&
        model.Competitors&&
        model.Address&&
        demoMachiID)
    {
        NetManger *manger = [NetManger shareInstance];
        manger.zhanhuiSave = @[model.LinkManName,
                               model.LinkTel,
                               model.Title,
                               model.AttendPersons,
                               model.PlanFee,
                               model.ExhibitionStartDate,
                               model.ExhibitionEndDate,
                               model.ExhibitionPlan,
                               model.ExhibitionAim,
                               model.UnionPartner,
                               model.Address,
                               model.Competitors,
                               model.Address,
                               demoMachiID];
        [manger loadData:RequestOfSellexhibitionsave];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popCtr) name:@"sellexhibitionsave" object:nil];
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

//    //初始化提示框；
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"正在开发中" preferredStyle: UIAlertControllerStyleAlert];
//    
//    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        //点击按钮的响应事件；
//    }]];
//    
//    //弹出提示框；
//    [self presentViewController:alert animated:true completion:nil];
}
- (void)popCtr
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end

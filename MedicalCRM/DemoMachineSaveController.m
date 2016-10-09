//
//  DemoMachineSaveController.m
//  MedicalCRM
//
//  Created by admin on 16/7/30.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "DemoMachineSaveController.h"
#import "NetManger.h"
#import "CustomerListViewController.h"
#import "EquipmentListViewController.h"
#import "KeyboardToolBar.h"
#import "DemoMachiModel.h"
#import "TheProjectListViewController.h"
#import "TheNewCustomerViewController.h"
@interface DemoMachineSaveController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NetManger *manger;
    NSArray *title;
    DemoMachiModel *model;
    NSString *demoMachiName;
    NSString *cusName;
    NSString *saveID;
    NSString *projcetName;
    NSString *cusId;
    NSString *linkManID;
}
@property (nonatomic ,strong) NSMutableArray *m_cutomArray;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation DemoMachineSaveController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    demoMachiName = @"点击选择";
    cusName = @"点击选择";
    model = [DemoMachiModel shareInstance];
    title = @[@"标题:",@"样机名:",@"客户名:",@"客户电话:",@"申请数量:",@"使用金额:",@"项目名:",@"备注:"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDatas:) name:@"cuNameStr" object:nil];
    [self setTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 69) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //iOS 8开始的自适应高度，可以不需要实现定义高度的方法
//    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = 44;
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

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return title.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *allCell = @"cell";
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:allCell];
        cell.selectionStyle = UITableViewCellAccessoryNone;
    }
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(ScreenWidth*0.3, 0, ScreenWidth-ScreenWidth*0.3-10, 44)];
    tf.font = [UIFont systemFontOfSize:13];
    tf.textAlignment = NSTextAlignmentRight;
    tf.placeholder = @"点击输入";
    tf.delegate = self;
    tf.tag = 21000 + indexPath.row;
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
            if (model.tel)
            {
                tf.text = model.tel;
            }
        }
            break;
        case 4:
        {
            if (model.count)
            {
                tf.text = model.count;
            }
        }
            break;
        case 5:
        {
            if (model.price)
            {
                tf.text = model.price;
            }

        }
            break;
        case 6:
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
    if (indexPath.row == 1 || indexPath.row == 2 ) {
        tf.hidden = YES;
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*0.3, 0, ScreenWidth-ScreenWidth*0.3-10, 44)];
        lb.font = [UIFont systemFontOfSize:13];
        lb.textAlignment = NSTextAlignmentRight;
        lb.tag = 4000+indexPath.row;
        if (indexPath.row == 1)
        {
            lb.text = demoMachiName;
        }
        else
        {
            lb.text = cusName;
        }
//        JCKLog(@"%ld",lb.tag);
        [cell.contentView addSubview:lb];
    }
    if (indexPath.row == 6) {
        tf.hidden = YES;
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*0.3, 0, ScreenWidth-ScreenWidth*0.3-10, 44)];
        lb.font = [UIFont systemFontOfSize:13];
        lb.textAlignment = NSTextAlignmentRight;
        lb.tag = 4008;
        if (!projcetName)
        {
            lb.text = @"点击选择";
        }
        else
        {
            lb.text = projcetName;
        }
        [cell.contentView addSubview:lb];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",title[indexPath.row]];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 2:
        {
            TheNewCustomerViewController *sub = [[TheNewCustomerViewController alloc] init];
            sub.title = @"客户列表";
            sub.block = ^(NSString *str, NSString *ID, NSString *phone,NSString *CompanyName,NSString *CusId)
            {
                cusId = ID;
                linkManID = CusId;
                model.tel = phone;
                cusName = str;
//                self.yiyuanTf.text = CompanyName;
                [tableView reloadData];
            };
            [self.navigationController pushViewController:sub animated:YES];
        }
            break;
        case 1:
        {
//            EquipmentListViewController *sub = [[EquipmentListViewController alloc] init];
//            sub.title = @"选择样机名";
//            sub.block = ^(NSString *str,NSString *ID){
////                JCKLog(@"%@",str);
//                UILabel *lb = (UILabel *)[_tableView viewWithTag:4001];
//                demoMachiName = str;
//                lb.text = demoMachiName;
//                self.ID = ID;
//            };
//            [self.navigationController pushViewController:sub animated:YES];
            EquipmentListViewController *sub = [[EquipmentListViewController alloc] init];
            sub.title = @"选择样机名";
//            sub.block = ^(NSArray *demoName,NSArray *demoIDs)
//            {
//                NSString *ns=[demoName componentsJoinedByString:@","];
//                demoMachiName = ns;
//                model.demoMachiIDs = demoIDs;
//                //                    UILabel *lb = (UILabel *)[_tableView viewWithTag:4001];
//                //                    model.demoMachiName = ns;
//                //                    lb.text = model.demoMachiName;
//                //                    //            model.demoMachiId = ID;
//                [_tableViewLeft reloadData];
//            };
            [self.navigationController pushViewController:sub animated:YES];
            

        }
            break;
        case 6:
        {
            TheProjectListViewController *sub = [[TheProjectListViewController alloc] init];
            sub.title = @"选择项目";
            sub.block = ^(NSString *str,NSString *ID){
                                JCKLog(@"%@",str);
                
                UILabel *lb = (UILabel *)[_tableView viewWithTag:4008];
                projcetName = [str substringFromIndex:4];;
                lb.text = projcetName;
                saveID = [NSString stringWithFormat:@"%@",ID];
            };
            [self.navigationController pushViewController:sub animated:YES];
            
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
        case 21000:
        {
            model.title = textField.text;
        }
            break;
        case 21003:
        {
            model.tel = textField.text;
        }
            break;
        case 21004:
        {
            model.count = textField.text;
        }
            break;
        case 21005:
        {
            model.price = textField.text;
        }
            break;
        case 21006:
        {
            model.remark = textField.text;
        }
            break;
            
        default:
            break;
    }
    return YES;
}
- (void)reloadDatas:(NSNotification *)obj
{
    NSLog(@"userInfo - %@",obj.object);
    [_m_cutomArray removeAllObjects];
    for (NSString *str in obj.object)
    {
        if (_m_cutomArray == nil)
        {
            _m_cutomArray = [NSMutableArray array];
        }
        [_m_cutomArray addObject:str];
    }
    model.tel = [NSString stringWithFormat:@"%@",[_m_cutomArray objectAtIndex:2]];
    UILabel *lb = (UILabel *)[_tableView viewWithTag:4002];
    cusName = [NSString stringWithFormat:@"%@",[_m_cutomArray lastObject]];
    lb.text = cusName;
    [_tableView reloadData];
}
- (void)btnAction
{
    /*
     @"ProductID": details[1],
     @"ProductCount": details[2],
     @"Remark":details[3],
     @"UsedPrice": details[4],
     @"ProductName": details[5],
     @"ProdNo": details[6]
     }];
     AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
     manager.requestSerializer.timeoutInterval = 5;
     NSDictionary *parameters = @{
     @"_appid" : @"101",
     @"_code": self.userCode,
     @"details": datas,
     @"Title": sellasmples[0],
     @"CustID": sellasmples[1],
     @"CustTel": sellasmples[2],
     //                                 @"Remark": sellasmples[3],
     };
     */
    if (model.count.length == 0 ||  model.price.length == 0 || model.title.length == 0 || model.tel.length == 0 || [demoMachiName isEqualToString:@"点击选择"] || [cusName isEqualToString:@"点击选择"])
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
        if (model.remark.length == 0)
        {
            model.remark = @"无";
        }
        manger = [NetManger shareInstance];
        manger.demoMachidetails = @[self.ID,model.count,model.remark,model.price,@"测试",saveID];
        manger.demoMachiSaves = @[model.title,cusId,model.tel,saveID,linkManID];
        [manger loadData:RequestOfSellsamplesave];
        [self.navigationController popViewControllerAnimated:YES];
    }

}

@end

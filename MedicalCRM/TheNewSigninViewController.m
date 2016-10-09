//
//  TheNewSigninViewController.m
//  MedicalCRM
//
//  Created by admin on 16/8/24.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "TheNewSigninViewController.h"
#import "KeyboardToolBar.h"
#import "ProjectBuildCell.h"
#import "DayPlanDirectionController.h"
#import "NetManger.h"
#import "AreaViewController.h"
#import "AddFriendListViewController.h"
#import "TheNewSigninSelectCustorController.h"

#import "TheNewSigninCell.h"
#import "PartnersVisitModel.h"
#import "SigninSelectHospitalViewController.h"
#import "PublishedController.h"
#import "HistoryViewController.h"
#import "MapViewController.h"
#import "TheNewCustomerListController.h"
#import "NetManger.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "SigninSelectProjectViewController.h"
#import "HistoryInfoViewController.h"
#import "MJExtension.h"
#import "CostDetailModel.h"
#import "CostDetailViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件

#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件

#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
#define btnSizW  self.siginBtn.bounds.size.width
#define btnSizH  self.siginBtn.bounds.size.height
@interface TheNewSigninViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    NSArray *titles;
    NSArray *titles2;
    NSArray *placeholders;
    NSArray *values;
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
    PartnersVisitModel *model;
    NetManger *manger;
    
    BMKMapView * _mapview;
    BMKLocationService *_locService;
    CLLocationCoordinate2D _touchMapCoordinate;  //  当前那一点的经纬度
    
    NSString *coustomerId;
    NSString *coustomerStr;
    
    NSString *proID;
    NSString *isPaterner;
    BOOL isAgent;
    CostDetailModel *costDetailModel;
}
@property (nonatomic, copy) NSString *locationLab;
@property (nonatomic, strong) UIView *closeV;
@property (nonatomic, strong) UIView *labelView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TheNewSigninViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [_mapview viewWillAppear];
    _mapview.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_tableView endEditing:YES];
    _tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 69);
    [_mapview viewWillDisappear];
    _mapview.delegate = nil; // 不用时，置nil
    [PartnersVisitModel tearDown];
//    [CostDetailModel tearDown];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    manger = [NetManger shareInstance];
    model = [PartnersVisitModel shareInstance];
    costDetailModel = [CostDetailModel shareInstance];
    // Do any additional setup after loading the view.
    titles = @[@[@""],@[@"合作伙伴公司名称:",@"联系人:",@"职务:",@"联系电话:",@"合作项目:"],@[@"是否一伙人:",@"是否一般合作经销商:"],@[@"差旅费",@"招待费",@"礼品费",@"其他费用"],@[@"此次拜访记录"]];
    
    //    placeholders = @[@"点击输入",@"选填",@"点击输入",@"点击输入",@"点击输入",@"点击输入",@" ",@"",@"",@"选填"];
    
    titles2 = @[@"",
                @"联系人基本信息",
                @"紧密程度",
                @"次拜费用",
                @"拜访记录"];
    [self setTableView];
#pragma mark - 设置navigationItem右侧按钮
    UIButton *meassageBut = ({
        UIButton *meassageBut = [UIButton buttonWithType:UIButtonTypeCustom];
        meassageBut.frame = CGRectMake(0, 0, 20, 20);
        [meassageBut addTarget:self action:@selector(enterInfoList) forControlEvents:UIControlEventTouchDown];
        [meassageBut setImage:[UIImage imageNamed:@"cusInfo"]forState:UIControlStateNormal];
        meassageBut;
    });
    
    UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithCustomView:meassageBut];
    self.navigationItem.rightBarButtonItem = rBtn;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popCtr) name:@"custcontactsave" object:nil];
    
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
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(40,10,ScreenWidth-80,40);
    btn.backgroundColor = [UIColor orangeColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.layer.cornerRadius = 5;
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(signin) forControlEvents:UIControlEventTouchDown];
    [bg addSubview:btn];
    self.tableView.tableFooterView = bg;
    //    [self setTopView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 105;
    }
    return 30;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    
    return [titles[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section // 返回组的头宽
{
    if (section == 0)
    {
        return 1;
    }
    return 29;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0
        ) {
        SigninSelectHospitalViewController *sub = [[SigninSelectHospitalViewController alloc] init];
        sub.title = @"请选择拜访的医院";
        sub.sType = @"2";
        sub.block = ^(NSString *ProjectNo,NSString *ProjectName,NSString *CompanyName,NSString *Department,NSString *StatusName,NSString *successRate,NSString *ProjcetId,NSArray *linkMandatas,NSString *custID,NSString *ProductName,NSString *ProductCount)
        {
//            JCKLog(@"%@ %@ %@ %@ %@ %@ %@",proNo,ProName,CompanyName,department,success,ID,cusID);
            /*
             model.CompanyName,
             model.DepartmentName,
             model.ZhiWu,
             model.CustLinkMan,
             model.LinkTel
             */
            //            model.proNo = proNo;
            JCKLog(@"%@",linkMandatas);
            model.company = CompanyName;
            model.department = Department;
            model.proID = [NSString stringWithFormat:@"%@",ProjcetId];
            model.proName = ProjectName;//ProName;
            model.name = linkMandatas[3];
            model.department = linkMandatas[1];
            model.zhiwu = linkMandatas[2];
            model.tel = linkMandatas[4];
            if ([model.tel isEqualToString:@"无"])
            {
                model.tel = @"";
            }
            coustomerId = [NSString stringWithFormat:@"%@",custID];
            //            model.ProlinkManID = linkMandatas[6];
            [_tableView reloadData];
        };
        
        [self.navigationController pushViewController:sub animated:YES];
    }
    if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            model.ispartner = !model.ispartner;
        }
        else
        {
            model.isdealers = !model.isdealers;
        }
        //一个section刷新
        
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
        
        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        
    }
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section// 返回组名
{
    return titles2[section];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView // 一个表视图里面有多少组
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        TheNewSigninCell *cell2 = [TheNewSigninCell selectedCell:tableView];
        // 地图
        //初始化BMKLocationService
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
        //启动LocationService
        [_locService startUserLocationService];
        _mapview = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0,80, 60)];
        //        cell2.addressLab.text = _locationLab;
        cell2.addressLab.tag = 10010;
        [cell2.mapView addSubview: _mapview];
        // 头像
        if ([manger.userNewPhoto isEqualToString:@"http://beacon.meidp.com"])
        {
            cell2.hearImg.image = [UIImage imageNamed:@"f5test"];
        }
        else
        {
            [cell2.hearImg sd_setImageWithURL:[NSURL URLWithString:manger.userNewPhoto]];
        }
        cell2.nameLab.text = manger.userName;
        
        // 时间
        NSArray *date = [self getWeek];
        cell2.dayLab.text = [NSString stringWithFormat:@"%@: %@-%@-%@",date[4],date[0],date[1],date[2]];
        cell2.timeLab.text = [NSString stringWithFormat:@"当前时间: %@",date[3]];
        // 拜访记录
        [cell2.lookHistorBtn addTarget:self action:@selector(pushHistory) forControlEvents:UIControlEventTouchDown];
        return cell2;
    }
    static NSString *allCell = @"cell";
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:allCell];
        cell.selectionStyle = UITableViewCellAccessoryNone;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.text = titles[indexPath.section][indexPath.row];
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(ScreenWidth*0.3, 0, ScreenWidth-ScreenWidth*0.3-10, 30)];
    tf.delegate = self;
    [KeyboardToolBar registerKeyboardToolBar:tf];
    tf.font = [UIFont systemFontOfSize:13];
    tf.placeholder = @"点击填写";
    tf.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:tf];
    switch (indexPath.section) {
        case 1:
        {
            tf.tag = 1000 + indexPath.row;
            if (indexPath.row == 0)
            {
                tf.hidden = YES;
                UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*0.35, 0, ScreenWidth-ScreenWidth*0.35-10, 30)];
                lb.font = [UIFont systemFontOfSize:13];
                lb.textAlignment = NSTextAlignmentRight;
                lb.textColor = RGB(130, 130, 130);
                lb.text = @"点击选择";
                if (model.company)
                {
                    lb.text = model.company;
                    lb.textColor = [UIColor blackColor];
                }
                [cell.contentView addSubview:lb];
                
            }
            if (indexPath.row == 1)
            {
                if (model.name)
                {
                    tf.text = model.name;
                }
            }
            if (indexPath.row == 2)
            {
                if (model.zhiwu)
                {
                    tf.text = model.zhiwu;
                }
            }
            if (indexPath.row == 3)
            {
                if (model.tel)
                {
                    tf.text = model.tel;
                }
            }
            if (indexPath.row == 4)
            {
                tf.hidden = YES;
                UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*0.35, 0, ScreenWidth-ScreenWidth*0.35-10, 30)];
                lb.font = [UIFont systemFontOfSize:13];
                lb.textAlignment = NSTextAlignmentRight;
                lb.textColor = RGB(130, 130, 130);
                lb.text = @"点击选择";
                if (model.proName)
                {
                    lb.text = model.proName;
                    lb.textColor = [UIColor blackColor];
                }
                [cell.contentView addSubview:lb];
            }
            
        }
            break;

        case 2:
        {
            tf.hidden = YES;
            if (indexPath.row == 0)
            {
                if (model.ispartner)
                {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    isPaterner = @"1";
                }
                else
                {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    isPaterner = @"0";
                }
            }
            else
            {
                
                if (model.isdealers)
                {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
                else
                {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            }
            
        }
            break;
        case 3:
        {
            tf.tag = 3000+indexPath.row;
            tf.keyboardType = UIKeyboardTypeDecimalPad;
            if (indexPath.row == 0)
            {
                tf.hidden = YES; // pushCostDetailViewController
                if (model.FeeApplyTravelCount)
                {
                    tf.text = model.FeeApplyTravelCount;
                }
                UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                addBtn.frame = CGRectMake(60,3,ScreenWidth - 60,25);
                //                                addBtn.backgroundColor = [UIColor redColor];
                addBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                addBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                addBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
                NSString *btnTitle;
                UIColor *btncolor;
                if (model.FeeApplyTravelCount)
                {
                    btnTitle = [NSString stringWithFormat:@"差旅总费: %@",model.FeeApplyTravelCount];
                    btncolor = [UIColor orangeColor];
                }
                else
                {
                    btnTitle = @"填写差旅费";
                    btncolor = [UIColor lightGrayColor];
                }
                addBtn.tag = 20001;
                [addBtn setTitle:btnTitle forState:UIControlStateNormal];
                [addBtn setTitleColor:btncolor forState:UIControlStateNormal];
                [addBtn addTarget:self action:@selector(pushCostDetailViewController:) forControlEvents:UIControlEventTouchDown];
                [cell.contentView addSubview:addBtn];
                
            }
            else if (indexPath.row == 1)
            {
                if (costDetailModel.entertain)
                {
                    tf.text = costDetailModel.entertain;
                }
            }
            else if (indexPath.row == 2)
            {
                if (costDetailModel.gift)
                {
                    tf.text = costDetailModel.gift;
                }
            }
            else if (indexPath.row == 3)
            {
                tf.hidden = YES; // pushCostDetailViewController
                if (model.FeeApplyTravelCount)
                {
                    tf.text = model.FeeApplyTravelCount;
                }
                UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                addBtn.frame = CGRectMake(ScreenWidth - 90,3,100,25);
                //                addBtn.backgroundColor = [UIColor redColor];
                addBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                addBtn.frame = CGRectMake(60,3,ScreenWidth - 60,25);
                //                addBtn.backgroundColor = [UIColor redColor];
                addBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                addBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                addBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
                NSString *btnTitle;
                UIColor *btncolor;
                if (model.FeeApplyOtherCount)
                {
                    btnTitle = [NSString stringWithFormat:@"其他费用共: %@",model.FeeApplyOtherCount];
                    btncolor = [UIColor orangeColor];
                }
                else
                {
                    btnTitle = @"填写其他费用";
                    btncolor = [UIColor lightGrayColor];
                }
                addBtn.tag = 20000;
                [addBtn setTitle:btnTitle forState:UIControlStateNormal];
                [addBtn setTitleColor:btncolor forState:UIControlStateNormal];
                [addBtn addTarget:self action:@selector(pushCostDetailViewController:) forControlEvents:UIControlEventTouchDown];
                [cell.contentView addSubview:addBtn];
                if (model.FeeApplyOtherCount)
                {
                    tf.text = model.FeeApplyOtherCount;
                }
            }
            tf.keyboardType = UIKeyboardTypeDecimalPad;
            
        }
            break;
        case 4:
        {
            tf.tag = 4000+indexPath.row;
            if (indexPath.row == 0)
            {
                if (model.signinContext)
                {
                    tf.text = model.signinContext;
                }
            }
        }
            
        default:
            break;
    }
    return cell;
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    switch (textField.tag)
    {
            
        case 4000:
        {
            model.signinContext = textField.text;
        }
            break;
        case 1001:
        {
            model.name = textField.text;
        }
            break;
        case 1002:
        {
            model.zhiwu = textField.text;
        }
            break;
        case 1003:
        {
            model.tel = textField.text;
        }
            break;
//        case 3000:
//        {
//            model.FeeApplyTravelCount = textField.text;
//        }
//            break;
//        case 3001:
//        {
//            model.FeeApplyAccommodationCount = textField.text;
//        }
//            break;
//        case 3002:
//        {
//            model.FeeApplyGiftCount = textField.text;
//        }
//            break;
//        case 3003:
//        {
//            model.FeeApplyOtherCount = textField.text;
//        }
//            break;
        case 3001://
        {
            costDetailModel.entertain = textField.text;
        }
            break;
        case 3002://
        {
            costDetailModel.gift = textField.text;
        }
            break;
            
        default:
            break;
    }
    return YES;
}
- (void)signin
{
    if (coustomerId.length == 0)
    {
        coustomerId = model.proID;
    }
    if (model.proName.length == 0)
    {
        model.proName = @"";
    }
    if (coustomerId.length == 0 || model.name.length == 0 || model.signinContext.length == 0 ||  model.tel.length == 0 || model.location.length == 0 || model.proID.length == 0 )
    {
        NSString *errorMsg;
        if (model.name.length == 0)
        {
            errorMsg = @"合作伙伴公司名为空,请补全";
        }
        else if (model.tel.length == 0)
        {
            errorMsg = @"联系电话为空,请补全";
        }
        else if (model.signinContext.length == 0)
        {
            errorMsg = @"此次拜访记录为空,请补全";
        }
        else if (model.proID.length == 0)
        {
            model.proID = @"0";
        }
//        else if (coustomerId.length == 0)
//        {
//            coustomerId = @"1";
//        }
        
        //初始化提示框；
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:errorMsg preferredStyle: UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //点击按钮的响应事件；
        }]];
        
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }
    else
    {
        NSString *feeApplyModelStr = @"";
        if (!costDetailModel.entertain)
        {
            costDetailModel.entertain = @"0";
        }
        if (!costDetailModel.gift)
        {
            costDetailModel.gift = @"0";
        }
        
        if (!costDetailModel.planeCost)
        {
            costDetailModel.planeCost = @"0";
        }
        if (!costDetailModel.longDistanceTransport)
        {
            costDetailModel.longDistanceTransport = @"0";
        }
        if (!costDetailModel.accommodation)
        {
            costDetailModel.accommodation = @"0";
        }
        if (!costDetailModel.luqiao)
        {
            costDetailModel.luqiao = @"0";
        }
        if (!costDetailModel.onAbusinessTripToTheTraffic)
        {
            costDetailModel.onAbusinessTripToTheTraffic = @"0";
        }
        if (!costDetailModel.onAbusinessTripAllowance)
        {
            costDetailModel.onAbusinessTripAllowance = @"0";
        }
        
        if (!costDetailModel.logistics)
        {
            costDetailModel.logistics = @"0";
        }
        if (!costDetailModel.print)
        {
            costDetailModel.print = @"0";
        }
        if (!costDetailModel.bidToMake)
        {
            costDetailModel.bidToMake = @"0";
        }
        if (!costDetailModel.officeSupplies)
        {
            costDetailModel.officeSupplies = @"0";
        }
        if (!costDetailModel.purchaseditems)
        {
            costDetailModel.purchaseditems = @"0";
        }
        if (!costDetailModel.communicationallowance)
        {
            costDetailModel.communicationallowance = @"0";
        }
        if (!costDetailModel.trafficSubsidies)
        {
            costDetailModel.trafficSubsidies = @"0";
        }
        if (!costDetailModel.housingSubsidies)
        {
            costDetailModel.housingSubsidies = @"0";
        }
        feeApplyModelStr = [self setFeeApplyDatas];

        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];

        manger.sigins = @[coustomerId, //客户ID CustID
                          model.name, // 联系人 CustLinkMan
                          [NSString stringWithFormat:@"%@",model.signinContext], // 标题 Title
                          [NSString stringWithFormat:@"%@",model.signinContext], // 拜访内容 Contents
                          [user objectForKey:@"userLat"], // Lat
                          [user objectForKey:@"userLon"], // Lon
                          model.tel,// 电话 LinkTel
                          model.location, //地址 LocationAddress
                          model.proID, // ProjectID
                          model.proName, // ProjectName
                          feeApplyModelStr, // FeeApplyModelStr
                          isPaterner, // IsPaterner
                          @"", // CustLinkManModelStr
                          @"", // ProjectModelStr
                          @""];
        NSLog(@"%@",manger.sigins);
        [manger loadData:RequestOfCustcontactsave];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popCtr) name:@"custcontactsave" object:nil];
    }
    
}
- (NSString *)setFeeApplyDatas
{
    NSArray *FeeApplyModels = @[@{
                                    @"ExpType": @"31", // 公共ID 飞机
                                    @"Amount": costDetailModel.planeCost,
                                    },
                                @{
                                    @"ExpType": @"32", // 公共ID 住宿
                                    @"Amount": costDetailModel.accommodation},
                                @{
                                    @"ExpType":@"37", // 公共ID 出差补助
                                    @"Amount": costDetailModel.onAbusinessTripAllowance},
                                @{
                                    @"ExpType":@"34", // 公共ID 长途车船
                                    @"Amount": costDetailModel.longDistanceTransport},
                                @{
                                    @"ExpType":@"35", // 公共ID // 路桥
                                    @"Amount": costDetailModel.luqiao},
                                @{
                                    @"ExpType":@"36", // 公共ID // 出差地交通
                                    @"Amount": costDetailModel.onAbusinessTripToTheTraffic},
                                @{
                                    @"ExpType": @"39", // 公共ID 快递
                                    @"Amount": costDetailModel.logistics,
                                    },
                                @{
                                    @"ExpType": @"40", // 公共ID 打印
                                    @"Amount": costDetailModel.print},
                                @{
                                    @"ExpType":@"41", // 公共ID 标书
                                    @"Amount": costDetailModel.bidToMake},
                                @{
                                    @"ExpType":@"42", // 公共ID 办公用品
                                    @"Amount": costDetailModel.officeSupplies},
                                @{
                                    @"ExpType":@"43", // 公共ID // 外购物品
                                    @"Amount": costDetailModel.purchaseditems},
                                @{
                                    @"ExpType":@"44", // 公共ID // 通讯补贴
                                    @"Amount": costDetailModel.communicationallowance},
                                @{
                                    @"ExpType":@"45", // 公共ID 交通补贴
                                    @"Amount": costDetailModel.trafficSubsidies},
                                @{
                                    @"ExpType":@"46", // 公共ID // 住房补贴
                                    @"Amount": costDetailModel.housingSubsidies},
                                @{
                                    @"ExpType":@"38", // 公共ID // 招待补贴
                                    @"Amount": costDetailModel.entertain},
                                @{
                                    @"ExpType":@"33", // 公共ID // 礼品补贴
                                    @"Amount": costDetailModel.gift}];
    
    
    
    NSDictionary *parameters = @{
                                 @"Details": FeeApplyModels,
                                 @"Title": [NSString stringWithFormat:@"拜访 %@ 项目的费用",model.proName],
                                 @"CustID": coustomerId,
                                 @"Reason": [NSString stringWithFormat:@"拜访 %@ 项目的费用",model.proName],
                                 @"ExpType": @"804",
                                 };
    NSString *detailstr = [parameters mj_JSONString];// 费用JSON
    return detailstr;
}
- (void)popCtr
{
    //初始化提示框；
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"拜访信息提交成功" preferredStyle: UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        HistoryInfoViewController *sub = [[HistoryInfoViewController alloc] init];
        // 标题 客户名 时间 拜访人 电话 地址 内容
        sub.title = @"拜访详情";
        sub.ID = coustomerId;
        [self.navigationController pushViewController:sub animated:YES];
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
    //    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - dateFun
- (NSArray *)getWeek
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    now=[NSDate date];
    comps = [calendar components:unitFlags fromDate:[NSDate date]];
    int year=[comps year];
    int week = [comps weekday];
    int month = [comps month];
    int day = [comps day];
    
    NSArray * arrWeek=[NSArray arrayWithObjects:@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    //    NSLog(@"dateString:%@",dateString);
    
    NSArray *dateInfo = @[[NSString stringWithFormat:@"%d",year],
                          [NSString stringWithFormat:@"%d",month],
                          [NSString stringWithFormat:@"%d",day],
                          dateString,
                          [arrWeek objectAtIndex:[comps weekday] - 1]];
    return dateInfo;
}
#pragma mark - MapDelegate
// Override
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    if(_mapview.isUserLocationVisible == YES)
    {
        return;
    }
    
    
    CLLocationCoordinate2D theCoordinate;
    CLLocationCoordinate2D theCenter;
    
    theCoordinate.latitude = userLocation.location.coordinate.latitude;
    theCoordinate.longitude= userLocation.location.coordinate.longitude;
    
    //将定位的点居中显示
    BMKCoordinateRegion theRegin;
    theCenter.latitude =userLocation.location.coordinate.latitude;
    theCenter.longitude = userLocation.location.coordinate.longitude;
    theRegin.center=theCenter;
    
    BMKCoordinateSpan theSpan;
    theSpan.latitudeDelta = 0.01;
    theSpan.longitudeDelta = 0.01;
    theRegin.span = theSpan;
    
    // 添加一个PointAnnotation
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    
    double lat = userLocation.location.coordinate.latitude;
    double lon = userLocation.location.coordinate.longitude;
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:[NSString stringWithFormat:@"%f",lat] forKey:@"userLat"];
    [user setObject:[NSString stringWithFormat:@"%f",lon]  forKey:@"userLon"];
    
    coor.latitude = userLocation.location.coordinate.latitude;
    coor.longitude = userLocation.location.coordinate.longitude;
    
    annotation.coordinate = coor;
    annotation.title = @"我在这里";
    [_mapview addAnnotation:annotation];
    
    BMKGeoCodeSearch *_geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
    _geoCodeSearch.delegate = self;
    //初始化逆地理编码类
    BMKReverseGeoCodeOption *reverseGeoCodeOption= [[BMKReverseGeoCodeOption alloc] init];
    //需要逆地理编码的坐标位置
    reverseGeoCodeOption.reverseGeoPoint = coor;
    [_geoCodeSearch reverseGeoCode:reverseGeoCodeOption];
    
    [_mapview setRegion:theRegin animated:YES];
    [_mapview regionThatFits:theRegin];
    [_locService stopUserLocationService];
}
/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    //BMKReverseGeoCodeResult是编码的结果，包括地理位置，道路名称，uid，城市名等信息
    if (error) {
        NSLog(@"%u",error);
    }
    else
    {
        NSLog(@" %@ %@ 详细地址：%@%@",result.address,result.addressDetail.city,result.addressDetail.district,result.addressDetail.streetName);
        UILabel *lb = (UILabel *)[_tableView viewWithTag:10010];
        lb.text = result.address;
        model.location = result.address;
    }
    
}
- (void)pushHistory
{
    HistoryViewController *sub = [[HistoryViewController alloc] init];
    sub.title = @"历史记录";
    [self.navigationController pushViewController:sub animated:YES];
    
}
- (void)enterInfoList
{
    TheNewCustomerListController *sub = [[TheNewCustomerListController alloc] init];
    sub.title = @"客户联系人";
    [self.navigationController pushViewController:sub animated:YES];
    
}
#pragma 跳转到费用填写页面
- (void)pushCostDetailViewController:(UIButton *)btn
{
    CostDetailViewController *sub = [[CostDetailViewController alloc] init];
    if (btn.tag == 20001)
    {
        sub.title = @"请输入差旅费用";
        sub.isTravelOrOther = NO;
    }
    else
    {
        sub.title = @"请输入其他费用";
        sub.isTravelOrOther = YES;
    }
    sub.costDetailblock = ^(CostDetailModel *costDetailModel2)
    {
        JCKLog(@"costDetailModel --- %@",costDetailModel2.planeCost);
        model.FeeApplyTravelCount = [NSString stringWithFormat:@"%ld",[costDetailModel.planeCost integerValue] + [costDetailModel.longDistanceTransport integerValue]  + [costDetailModel.accommodation integerValue]  + [costDetailModel.luqiao integerValue]  + [costDetailModel.onAbusinessTripToTheTraffic integerValue]  + [costDetailModel.onAbusinessTripAllowance integerValue]];
        model.FeeApplyOtherCount = [NSString stringWithFormat:@"%ld",[costDetailModel.logistics integerValue] + [costDetailModel.print integerValue]  + [costDetailModel.bidToMake integerValue]  + [costDetailModel.officeSupplies integerValue]  + [costDetailModel.purchaseditems integerValue]  + [costDetailModel.communicationallowance integerValue] + [costDetailModel.trafficSubsidies integerValue] + [costDetailModel.housingSubsidies integerValue]];
        [_tableView reloadData];
    };
    
    [self.navigationController pushViewController:sub animated:YES];
    
}
@end

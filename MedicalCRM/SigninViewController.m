
//
//  SigninViewController.m
//  MedicalCRM
//
//  Created by admin on 16/7/11.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "SigninViewController.h"
#import "TheNewSigninCell.h"

#import "SigninModel.h"
#import "NetManger.h"

#import "KeyboardToolBar.h"
//#import "TheNewSignin2Cell.h"
#import "CostDetailViewController.h"
#import "TheNewSignin3Cell.h"
#import "SigninSelectCustomerViewController.h"
#import "HistoryViewController.h"
#import "SigninSelectHospitalViewController.h"
#import "zySheetPickerView.h"
#import "SVProgressHUD.h"
#import "MJExtension.h"
#import "XFDaterView.h"
#import "CostDetailModel.h"

#import "ProjectInfoModel.h"

#import "HistoryInfoViewController.h"
// baiduMap
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件

#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件

#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

#import "SigninSelectProjectViewController.h"
#import "TheNewCustomerListController.h"
#import "EquipmentListViewController.h"

#import "ProductsSubmittedViewController.h"
@interface SigninViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UITextFieldDelegate,XFDaterViewDelegate>
{
    NSArray *datas;
    NSInteger l_hight;
    
    NSArray *rightSectionTitles;
    NSArray *leftTitles;
    NSArray *leftSectionTitles;
    NSArray *rightTitles;
    NSArray *rightContexts;
    UIView *footView;
    
    SigninModel *model;
    
    BMKMapView * _mapview;
    BMKLocationService *_locService;
    CLLocationCoordinate2D _touchMapCoordinate;  //  当前那一点的经纬度
    
    NetManger *manger;
    BOOL isSeclet;
    BOOL isSecletDemo;
    NSString *coustomerId;
    NSString *proSucess;
    
    NSInteger cellCount;
    NSInteger demoCellCount;
    
    BOOL isFeeApplyTravelOrOther;
    BOOL isFirstreload;
//    BOOL isFeeApplyGift;
//    BOOL isFeeApplyOther;
    CostDetailModel *costDetailModel;
    XFDaterView* daterTool;
    
    NSMutableArray *m_productNames;
}
@property (nonatomic, strong) NSMutableArray *m_arrs;
@property (nonatomic, strong) UITableView *tableViewLeft;
@end

@implementation SigninViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     _mapview.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapview viewWillDisappear];
    _mapview.delegate = nil; // 不用时，置nil
    _locService = nil;
    [SigninModel tearDown];
//    [CostDetailModel tearDown];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 初始化行
    isFirstreload = YES;
    cellCount = 3;
    demoCellCount = 3;
    // 单例对象初始化
    costDetailModel = [CostDetailModel shareInstance];
    daterTool=[[XFDaterView alloc]initWithFrame:CGRectZero];
    daterTool.delegate=self;
    model = [SigninModel shareInstance];// 存储单例
    
    manger = [NetManger shareInstance]; // 网络单例
// 标题数组
    leftTitles =@[@[@""],
                  @[@"医院名称",
//                    @"科室名称",
                    @"项目编号",
                    @"项目名称"],
                  @[@"样机",
                    @"产品型号",
                    @"数量"],
                  @[@"产品",
                    @"产品型号",
                    @"数量"],
                  @[@"联系人:",
                    @"联系电话:",
                    @"科室:",
                    @"职务:"],
                  @[@"",@"",@"",@""],
                  @[@"项目当前状态:",
                    @"项目成功率%:"],
                  @[@"差旅费",@"招待费",@"礼品费",@"其他费用"],
                  @[@"拜访记录:"],
                  ];
    // 题名数组
    leftSectionTitles = @[@"",
                          @"项目基本信息:",
                          @"项目具体内容:",
                          @"",
                          @"项目关键人:",
                          @"项目时间进度:",
                          @"项目状态:",
                          @"次拜费用:",
                          @"拜访内容"];
    /*-----------------------------------------------------------------------------*/
    // Do any additional setup after loading the view.

    _tableViewLeft = [[UITableView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight - 64) style:UITableViewStyleGrouped];
    _tableViewLeft.delegate = self;
    _tableViewLeft.dataSource = self;
    _tableViewLeft.tag = 6000;
//    self.tableViewLeft.scrollEnabled =NO; //设置tableview 不能滚动
    [_tableViewLeft setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableViewLeft];
//    [self createTopView];
    
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-65 - 64, ScreenWidth, 60)];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(40,10,ScreenWidth-80,40);
    btn.backgroundColor = [UIColor orangeColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.layer.cornerRadius = 5;
    [btn setTitle:@"提交我的拜访" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(signinNew) forControlEvents:UIControlEventTouchDown];
    [bg addSubview:btn];
//    [self.view addSubview:bg];
    _tableViewLeft.tableFooterView = bg;

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
    
    // 接收选择单个项目
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveData) name:@"getproject" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView // 一个表视图里面有多少组
{
    return 9;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section // 返回组的头宽
{
    if (section == 0)
    {
        return 1;
    }
//    if (section == 2) {
//        return  testCellHight;
//    }
    return 29;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section == 2)
//    {
//        return cellCount;
//    }
//    return [leftTitles[section] count];
    switch (section) {
        case 0:
        {
            return 1;
        }
            break;
        case 1:
        {
            return 3;
        }
            break;
        case 2:
        {
            return cellCount;

        }
            break;
        case 3:
        {
            return demoCellCount;
            
        }
            break;
        case 4:
        {
            return 4;
        }
            break;
        case 5:
        {
            return 4;
        }
            break;
        case 6:
        {
            return 2;
        }
            break;
        case 7:
        {
            return 4;
        }
            break;
        case 8:
        {
            return 1;
        }
            break;
        default:
            break;
    }
    return 0;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section// 返回组名
{
    return leftSectionTitles[section];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 105;
    }
    return 30;
    
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
    if (indexPath.section != 2 && indexPath.section != 3)
    {
        cell.textLabel.text = leftTitles[indexPath.section][indexPath.row];
    }
    
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(ScreenWidth*0.3, 0, ScreenWidth-ScreenWidth*0.3-10, 30)];
    tf.delegate = self;
    [KeyboardToolBar registerKeyboardToolBar:tf];
    tf.font = [UIFont systemFontOfSize:13];
    tf.placeholder = @"点击填写";
    tf.textAlignment = NSTextAlignmentRight;
    switch (indexPath.section)
    {
        case 0 :
        {
            TheNewSigninCell *topCell = [TheNewSigninCell selectedCell:tableView];
            // 地图
            //初始化BMKLocationService
            _locService = [[BMKLocationService alloc]init];
            _locService.delegate = self;
            //启动LocationService
            [_locService startUserLocationService];
            _mapview = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0,80, 60)];
            //        cell2.addressLab.text = _locationLab;
            topCell.addressLab.tag = 10010;
            [topCell.mapView addSubview: _mapview];
            // 时间
            NSArray *date = [self getWeek];
            topCell.dayLab.text = [NSString stringWithFormat:@"%@: %@-%@-%@",date[4],date[0],date[1],date[2]];
            topCell.timeLab.text = [NSString stringWithFormat:@"当前时间: %@",date[3]];
            return topCell;
        }
            break;
        case 1:
        {
            tf.tag = 1000+indexPath.row;
            if (indexPath.row == 0)
            {
                tf.hidden = YES;
                UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*0.35, 0, ScreenWidth-ScreenWidth*0.35-10, 30)];
                lb.font = [UIFont systemFontOfSize:13];
                lb.textAlignment = NSTextAlignmentRight;
                lb.textColor = [UIColor lightGrayColor];
                //                    lb.tag = 1010110;
                lb.text = @"请选择";
                if (model.cusName)
                {
                    lb.text = model.cusName;
                    lb.textColor = [UIColor blackColor];
                }
                else
                {
                    lb.textColor = [UIColor lightGrayColor];
                }
                [cell.contentView addSubview:lb];
            }

            else if (indexPath.row == 1)
            {
                tf.hidden = YES;
                UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*0.35, 0, ScreenWidth-ScreenWidth*0.35-10, 30)];
                lb.font = [UIFont systemFontOfSize:13];
                lb.textAlignment = NSTextAlignmentRight;
                lb.textColor = RGB(130, 130, 130);
                lb.text = @"系统自动匹配";
                if (model.proNo)
                {
                    lb.text = model.proNo;
                }
                [cell.contentView addSubview:lb];
                
            }
            else if (indexPath.row == 2)
            {
                if (model.proName) {
                    tf.text = model.proName;
                }
            }

        }
            break;
        case 2:
        {
            
            UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 60, 30)];

            if (indexPath.row == 0)
            {
                titleLab.text = @"产品";
                tf.hidden = YES;
                UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                
                addBtn.frame = CGRectMake(ScreenWidth - 85,3,100,25);
                //                addBtn.backgroundColor = [UIColor redColor];
                UIImageView *imagv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 15, 15)];
                imagv.image = [UIImage imageNamed:@"singinAdd"];
                [addBtn addSubview:imagv];
                addBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                addBtn.titleLabel.textAlignment = NSTextAlignmentRight;
                [addBtn setTitle:@"添加产品" forState:UIControlStateNormal];
                [addBtn setTitleColor:RGB(57, 173, 255) forState:UIControlStateNormal];
                [addBtn addTarget:self action:@selector(addProduct) forControlEvents:UIControlEventTouchDown];
                [cell.contentView addSubview:addBtn];
                if (isSeclet) {
                    addBtn.hidden = YES;
                }
            }
            else
            {
                if (indexPath.row % 2 != 0)
                {
                    titleLab.text = @"产品型号";
                    tf.hidden = YES;
                    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*0.35, 0, ScreenWidth-ScreenWidth*0.35-10, 30)];
                    lb.font = [UIFont systemFontOfSize:13];
                    lb.textAlignment = NSTextAlignmentRight;
                    lb.textColor = [UIColor lightGrayColor];
                    lb.text = @"点击选择";

                    if (indexPath.row == 1)
                    {
                        if (model.productNames)
                        {
                            lb.text = model.productNames;
                            lb.textColor = [UIColor blackColor];
                        }
                    }
                    if (indexPath.row == 3)
                    {
                        if (model.productNames2)
                        {
                            lb.text = model.productNames2;
                            lb.textColor = [UIColor blackColor];
                        }
                    }
                    if (indexPath.row == 5)
                    {
                        if (model.productNames3)
                        {
                            lb.text = model.productNames3;
                            lb.textColor = [UIColor blackColor];
                        }
                    }
                    if (indexPath.row == 7)
                    {
                        if (model.productNames4)
                        {
                            lb.text = model.productNames4;
                            lb.textColor = [UIColor blackColor];
                        }
                    }
                    if (indexPath.row == 9)
                    {
                        if (model.productNames5)
                        {
                            lb.text = model.productNames5;
                            lb.textColor = [UIColor blackColor];
                        }
                    }
                    [cell.contentView addSubview:lb];
                }
                else if (indexPath.row % 2 == 0)
                {
                    tf.tag = 2000+indexPath.row;
                    titleLab.text = @"产品数量";
//                    if (model.productPrice)
//                    {
//                        tf.text = model.productPrice;
//                    }
                    
                    if (indexPath.row == 2)
                    {
                        if (model.productPrice)
                        {
                            tf.text = model.productPrice;
                        }
                    }
                    if (indexPath.row == 4)
                    {
                        if (model.productPrice2)
                        {
                            tf.text = model.productPrice2;
                        }
                    }
                    if (indexPath.row == 6)
                    {
                        if (model.productPrice3)
                        {
                            tf.text = model.productPrice3;
                        }
                    }
                    if (indexPath.row == 8)
                    {
                        if (model.productPrice4)
                        {
                            tf.text = model.productPrice4;
                        }
                    }
                    if (indexPath.row == 10)
                    {
                        if (model.productPrice5)
                        {
                            tf.text = model.productPrice5;
                        }
                    }

                    
                    tf.frame = CGRectMake((ScreenWidth/2) +65, 0, ScreenWidth - ((ScreenWidth/2) +65) - 10, 30);
//                    tf.backgroundColor = [UIColor lightGrayColor];
                    tf.placeholder = @"填写单价";
                    tf.keyboardType = UIKeyboardTypeDecimalPad;
                    UILabel *priceLab = [[UILabel alloc] initWithFrame:CGRectMake(3 + ScreenWidth/2, 0, 60, 30)];
                    priceLab.text = @"产品单价";
                    priceLab.font = [UIFont systemFontOfSize:13];
                    [cell.contentView addSubview:priceLab];
                    
                    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/2 - 1, 5, 1, 20)];
                    line.backgroundColor = [UIColor lightGrayColor];
                    [cell.contentView addSubview:line];
                    
                    UITextField *pricetf = [[UITextField alloc] initWithFrame:CGRectMake(65, 0, ScreenWidth/2 - 70, 30)];
                    pricetf.delegate = self;
                    pricetf.tag = 2100 + indexPath.row;
//                    if (model.productCount)
//                    {
//                        pricetf.text = model.productCount;
//                    }
                    
                    if (indexPath.row == 2)
                    {
                        if (model.productCount)
                        {
                            pricetf.text = model.productCount;
                        }
                    }
                    if (indexPath.row == 4)
                    {
                        if (model.productCount2)
                        {
                            pricetf.text = model.productCount2;
                        }
                    }
                    if (indexPath.row == 6)
                    {
                        if (model.productCount3)
                        {
                            pricetf.text = model.productCount3;
                        }
                    }
                    if (indexPath.row == 8)
                    {
                        if (model.productCount4)
                        {
                            pricetf.text = model.productCount4;
                        }
                    }
                    if (indexPath.row == 10)
                    {
                        if (model.productCount5)
                        {
                            pricetf.text = model.productCount5;
                        }
                    }



                    
                    [KeyboardToolBar registerKeyboardToolBar:pricetf];
                    pricetf.font = [UIFont systemFontOfSize:13];
                    pricetf.placeholder = @"填写数量";
//                    pricetf.backgroundColor = [UIColor redColor];
                    pricetf.textAlignment = NSTextAlignmentRight;
                    pricetf.keyboardType = UIKeyboardTypeDecimalPad;
                    [cell.contentView addSubview:pricetf];
                   
                    
                }
            }
            
            titleLab.font = [UIFont systemFontOfSize:13];
            [cell.contentView addSubview:titleLab];

        }
            break;
            
        case 3:
        {
            UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 60, 30)];
            
            tf.tag = 3000+indexPath.row;
            if (indexPath.row == 0)
            {
                titleLab.text = @"样机";
                tf.hidden = YES;
                UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                addBtn.frame = CGRectMake(ScreenWidth - 85,3,100,25);
//                addBtn.backgroundColor = [UIColor redColor];
                addBtn.tag = 2222222;
                UIImageView *imagv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 15, 15)];
                imagv.image = [UIImage imageNamed:@"singinAdd"];
                [addBtn addSubview:imagv];
                addBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                addBtn.titleLabel.textAlignment = NSTextAlignmentRight;
                [addBtn setTitle:@"添加样机" forState:UIControlStateNormal];
                [addBtn setTitleColor:RGB(57, 173, 255) forState:UIControlStateNormal];
                [addBtn addTarget:self action:@selector(addDemo) forControlEvents:UIControlEventTouchDown];
                [cell.contentView addSubview:addBtn];
                if (isSecletDemo) {
                    addBtn.hidden = YES;
                }
            }
            else
            {
                if (indexPath.row % 2 != 0)
                {
                    titleLab.text = @"样机型号";
                    tf.hidden = YES;
                    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*0.35, 0, ScreenWidth-ScreenWidth*0.35-10, 30)];
                    lb.font = [UIFont systemFontOfSize:13];
                    lb.textAlignment = NSTextAlignmentRight;
                    lb.textColor = [UIColor lightGrayColor];
                    lb.text = @"点击选择";
                    if (indexPath.row == 1)
                    {
                        if (model.demoMachiNames)
                        {
                            lb.text = model.demoMachiNames;
                            lb.textColor = [UIColor blackColor];
                        }

                    }
                    else if (indexPath.row == 3)
                    {
                        if (model.demoMachiNames2)
                        {
                            lb.text = model.demoMachiNames2;
                            lb.textColor = [UIColor blackColor];
                        }
                        
                    }
                    else if (indexPath.row == 5)
                    {
                        if (model.demoMachiNames3)
                        {
                            lb.text = model.demoMachiNames3;
                            lb.textColor = [UIColor blackColor];
                        }
                        
                    }
                    
                    [cell.contentView addSubview:lb];
                }
                else if (indexPath.row % 2 == 0)
                {
                    titleLab.text = @"样机数量";
                    tf.keyboardType = UIKeyboardTypeDecimalPad;
                    if (indexPath.row == 2)
                    {
                        if (model.demoMaCount)
                        {
                            tf.text = model.demoMaCount;
                        }
                    }
                    if (indexPath.row == 4)
                    {
                        if (model.demoMaCount2)
                        {
                            tf.text = model.demoMaCount2;
                        }
                    }
                    if (indexPath.row == 5)
                    {
                        if (model.demoMaCount3)
                        {
                            tf.text = model.demoMaCount3;
                        }
                    }
                    
                    
                }
            }

            titleLab.font = [UIFont systemFontOfSize:13];
            [cell.contentView addSubview:titleLab];

        }
            break;
        case 4:
        {
            tf.tag = 4000+indexPath.row;
            if (indexPath.row == 0)
            {
                if (model.proLinkMan) {
                    tf.text = model.proLinkMan;
                }
            }
            else if (indexPath.row == 1)
            {
                UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 30/2 - 2, 4, 4)];
                tipLab.layer.cornerRadius = 2;
                tipLab.layer.masksToBounds = YES;
                tipLab.backgroundColor = [UIColor redColor];
                [cell.contentView addSubview:tipLab];

                tf.keyboardType = UIKeyboardTypeDecimalPad;
                if (model.proLinkTel)
                {
                    tf.text = model.proLinkTel;
                }
            }
            else if (indexPath.row == 2)
            {
                if (model.proLinkManDepart) {
                    tf.text = model.proLinkManDepart;
                }
            }
            else if (indexPath.row == 3)
            {
                if (model.proLinkManZhiwu) {
                    tf.text = model.proLinkManZhiwu;
                }
            }
        }
            break;
        case 5:
        {
            TheNewSignin3Cell *cell3 = [TheNewSignin3Cell selectedCell:tableView];
            switch (indexPath.row)
            {
                case 0:
                {
                    cell3.leftLab.text = @"样机";
                    cell3.rightLab.text = @"参数、方案";
                    
                }
                    break;
                case 1:
                {
                    cell3.leftLab.text = @"招标";
                    cell3.rightLab.text = @"合同";
                }
                    break;
                case 2:
                {
                    cell3.leftLab.text = @"交货";
                    cell3.rightLab.text = @"发票";
                }
                    break;
                case 3:
                {
                    cell3.leftLab.text = @"付款";
                    cell3.rightLab.hidden = YES;
                    cell3.rightBtn.hidden = YES;
                }
                    break;
                    
                default:
                    break;
            }
            cell3.leftBtn.tag   = indexPath.row +80000;
            cell3.rightBtn.tag  = indexPath.row +90000;
            [cell3.leftBtn setTitle:@"选择日期" forState:UIControlStateNormal];
            [cell3.rightBtn setTitle:@"选择日期" forState:UIControlStateNormal];
            switch (cell3.leftBtn.tag)
            {
                case 80000:
                {
                    if (model.plantPrototype)
                    {
                        [cell3.leftBtn setTitle:model.plantPrototype forState:UIControlStateNormal];
                    }
                    
                }
                    break;
                case 80001:
                {
                    if (model.plantTender)
                    {
                        [cell3.leftBtn setTitle:model.plantTender forState:UIControlStateNormal];
                    }
                }
                    break;
                case 80002:
                {
                    if (model.plantDelivery)
                    {
                        [cell3.leftBtn setTitle:model.plantDelivery forState:UIControlStateNormal];
                    }
                }
                    break;
                case 80003:
                {
                    if (model.plantPayment)
                    {
                        [cell3.leftBtn setTitle:model.plantPayment forState:UIControlStateNormal];
                    }
                }
                    break;
                    
                default:
                    break;
            }
            switch (cell3.rightBtn.tag)
            {
                case 90000:
                {
                    
                    if (model.plantParametersAndTheSolution)
                    {
                        [cell3.rightBtn setTitle:model.plantParametersAndTheSolution forState:UIControlStateNormal];
                    }
                }
                    break;
                case 90001:
                {
                    
                    if (model.plantContract)
                    {
                        [cell3.rightBtn setTitle:model.plantContract forState:UIControlStateNormal];
                    }
                }
                    break;

                case 90002:
                {
                    
                    if (model.plantInvoice)
                    {
                        [cell3.rightBtn setTitle:model.plantInvoice forState:UIControlStateNormal];
                    }
                }
                    break;
                    
                default:
                    break;
            }
            [cell3.leftBtn addTarget:self action:@selector(showDateTool:) forControlEvents:UIControlEventTouchDown];
            [cell3.rightBtn addTarget:self action:@selector(showDateTool:) forControlEvents:UIControlEventTouchDown];
            return cell3;
        }
            break;
        case 6:
        {
            if (indexPath.row == 0)
            {
                tf.hidden = YES;
                UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*0.35, 0, ScreenWidth-ScreenWidth*0.35-10, 30)];
                lb.font = [UIFont systemFontOfSize:13];
                lb.textAlignment = NSTextAlignmentRight;
                lb.textColor = [UIColor lightGrayColor];
                lb.text = @"点击选择";
                if (model.proState)
                {
                    lb.text = model.proState;
                    lb.textColor = [UIColor blackColor];
                }
                [cell.contentView addSubview:lb];

            }
            if (indexPath.row == 1)
            {
                tf.hidden = YES;
                UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*0.35, 0, ScreenWidth-ScreenWidth*0.35-10, 30)];
                lb.font = [UIFont systemFontOfSize:13];
                lb.textAlignment = NSTextAlignmentRight;
                lb.textColor = [UIColor lightGrayColor];
                lb.text = @"点击选择";
                if (model.proSucess)
                {
                    lb.text = model.proSucess;
                    lb.textColor = [UIColor blackColor];
                }
                [cell.contentView addSubview:lb];
            }
            
        }
            break;
        case 7:
        {
            tf.tag = 7000+indexPath.row;
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
        case 8:
        {
            UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 30/2 - 2, 4, 4)];
            tipLab.layer.cornerRadius = 2;
            tipLab.layer.masksToBounds = YES;
            tipLab.backgroundColor = [UIColor redColor];
            [cell.contentView addSubview:tipLab];
            tf.tag = 8000;
            if (model.signinContext) {
                tf.text = model.signinContext;
            }

        }
            break;
        default:
            break;
    }
    [cell.contentView addSubview:tf];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        if (indexPath.section == 1 && indexPath.row == 0)
        {
            SigninSelectHospitalViewController *sub = [[SigninSelectHospitalViewController alloc] init];
            sub.title = @"请选择拜访的医院";
            sub.sType = @"1";
            sub.block = ^(NSString *ProjectNo,NSString *ProjectName,NSString *CompanyName,NSString *Department,NSString *StatusName,NSString *successRate,NSString *ProjcetId,NSArray *linkMandatas,NSString *custID,NSString *ProductName,NSString *ProductCount)
            {
                JCKLog(@"ProjectNo-%@ ProjectName-%@ CompanyName-%@ Department-%@ StatusName-%@ successRate-%@ ProjcetId-%@ linkMandatas-%@ custID-%@ ProductName-%@ ProductCount-%@",ProjectNo,ProjectName,CompanyName,Department,StatusName,successRate,ProjcetId,linkMandatas,custID,ProductName,ProductCount);//
                model.proNo = ProjectNo;
                model.cusName = CompanyName;
                model.departName = Department;
                model.proID = [NSString stringWithFormat:@"%@",ProjcetId];
                model.proName = ProjectName;
                model.proLinkMan = linkMandatas[3];
                model.proLinkManDepart = linkMandatas[1];
                model.proLinkManZhiwu = linkMandatas[2];
                model.proLinkTel = linkMandatas[4];
                if (model.proID.length == 0)
                {
                    isSeclet = NO;
                    isSecletDemo = NO;
                    cellCount = 3;
                    model.productIDs = @"";
                    model.productIDs2 = @"";
                    model.productIDs3 = @"";
                    model.productIDs4 = @"";
                    model.productIDs5 = @"";
                    
                    model.productNames = @"";
                    model.productNames2 = @"";
                    model.productNames3 = @"";
                    model.productNames4 = @"";
                    model.productNames5 = @"";
                    
                    model.productCount = @"";
                    model.productCount2 = @"";
                    model.productCount3 = @"";
                    model.productCount4 = @"";
                    model.productCount5 = @"";
                    
                    model.productPrice = @"";
                    model.productPrice2 = @"";
                    model.productPrice3 = @"";
                    model.productPrice4 = @"";
                    model.productPrice5 = @"";
                    

                }
                if ([model.proLinkTel isKindOfClass:[NSNull class]])
                {
                    model.proLinkTel = @"";
                }
                if ([model.proLinkTel isEqualToString:@"无"])
                {
                    model.proLinkTel = @"";
                }
                model.proSucess = [NSString stringWithFormat:@"%.0f%%",[successRate floatValue]*100];
                proSucess = successRate;
                model.proState = StatusName;
                if ([model.proState isEqualToString:@"申报项目"] || [model.proState isEqualToString:@"提交项目"])
                {
                    model.proStateID = @"0";
                }
                if ([model.proState isEqualToString:@"样机申请"])
                {
                    model.proStateID = @"1";
                }
                if ([model.proState isEqualToString:@"招标参数准备"])
                {
                    model.proStateID = @"6";
                }
                if ([model.proState isEqualToString:@"中标"])
                {
                    model.proStateID = @"7";
                }
                if ([model.proState isEqualToString:@"合同"])
                {
                    model.proStateID = @"8";
                }
                if ([model.proState isEqualToString:@"备货"])
                {
                    model.proStateID = @"2";
                }
                if ([model.proState isEqualToString:@"发货"])
                {
                    model.proStateID = @"3";
                }
                if ([model.proState isEqualToString:@"付款"])
                {
                    model.proStateID = @"4";
                }
                if ([model.proState isEqualToString:@"完结"])
                {
                    model.proStateID = @"5";
                }
                if ([model.proState isEqualToString:@"终止"])
                {
                    model.proStateID = @"9";
                }
                coustomerId = [NSString stringWithFormat:@"%@",custID];
                model.ProlinkManID = linkMandatas[6];
//                model.demoMachiNames = ProductName;
//                model.demoMaCount = ProductCount;
                [_tableViewLeft reloadData];
            };
            
            [self.navigationController pushViewController:sub animated:YES];

        }
        if (indexPath.section == 2)
        {
            switch (indexPath.row) {
                case 1:
                {
                    EquipmentListViewController *sub = [[EquipmentListViewController alloc] init];
                    sub.title = @"选择产品名";
                    sub.block = ^(NSArray *demoName,NSArray *demoIDs)
                    {
                        NSString *ns=[demoName componentsJoinedByString:@","];
                        
                        model.productNames = ns;
                        model.productIDs = [NSString stringWithFormat:@"%@",demoIDs[0]];

                        [_tableViewLeft reloadData];
                    };
                    [self.navigationController pushViewController:sub animated:YES];
                }
                    break;
                case 3:
                {
                    EquipmentListViewController *sub = [[EquipmentListViewController alloc] init];
                    sub.title = @"选择产品名";
                    sub.block = ^(NSArray *demoName,NSArray *demoIDs)
                    {
                        NSString *ns=[demoName componentsJoinedByString:@","];
                        
                        model.productNames2 = ns;
                        model.productIDs2 = [NSString stringWithFormat:@"%@",demoIDs[0]];
                        
                        [_tableViewLeft reloadData];
                    };
                    [self.navigationController pushViewController:sub animated:YES];
                    
                }
                    break;
                case 5:
                {
                    EquipmentListViewController *sub = [[EquipmentListViewController alloc] init];
                    sub.title = @"选择产品名";
                    sub.block = ^(NSArray *demoName,NSArray *demoIDs)
                    {
                        NSString *ns=[demoName componentsJoinedByString:@","];
                        
                        model.productNames3 = ns;
                        model.productIDs3 = [NSString stringWithFormat:@"%@",demoIDs[0]];
                        
                        [_tableViewLeft reloadData];
                    };
                    [self.navigationController pushViewController:sub animated:YES];
                }
                    break;
                case 7:
                {
                    EquipmentListViewController *sub = [[EquipmentListViewController alloc] init];
                    sub.title = @"选择产品名";
                    sub.block = ^(NSArray *demoName,NSArray *demoIDs)
                    {
                        NSString *ns=[demoName componentsJoinedByString:@","];
                        
                        model.productNames4 = ns;
                        model.productIDs4 = [NSString stringWithFormat:@"%@",demoIDs[0]];
                        
                        [_tableViewLeft reloadData];
                    };
                    [self.navigationController pushViewController:sub animated:YES];
                }
                    break;
                case 9:
                {
                    EquipmentListViewController *sub = [[EquipmentListViewController alloc] init];
                    sub.title = @"选择产品名";
                    sub.block = ^(NSArray *demoName,NSArray *demoIDs)
                    {
                        NSString *ns=[demoName componentsJoinedByString:@","];
                        
                        model.productNames5 = ns;
                        model.productIDs5 = [NSString stringWithFormat:@"%@",demoIDs[0]];
                        
                        [_tableViewLeft reloadData];
                    };
                    [self.navigationController pushViewController:sub animated:YES];
                }
                    break;
                    
                default:
                    break;
            }

        }
    if (indexPath.section == 3 )
    {
        switch (indexPath.row) {
            case 1:
            {
                EquipmentListViewController *sub = [[EquipmentListViewController alloc] init];
                sub.title = @"选择样机名";
                sub.block = ^(NSArray *demoName,NSArray *demoIDs)
                {
                    NSString *ns=[demoName componentsJoinedByString:@","];
                    model.demoMachiNames = ns;
                    model.demoMachiIDs = demoIDs[0];
                    
                    [_tableViewLeft reloadData];
                };
                [self.navigationController pushViewController:sub animated:YES];
            }
                break;
            case 3:
            {
                EquipmentListViewController *sub = [[EquipmentListViewController alloc] init];
                sub.title = @"选择样机名";
                sub.block = ^(NSArray *demoName,NSArray *demoIDs)
                {
                    NSString *ns=[demoName componentsJoinedByString:@","];
                    model.demoMachiNames2 = ns;
                    model.demoMachiIDs2 = demoIDs[0];
                    
                    [_tableViewLeft reloadData];
                };
                [self.navigationController pushViewController:sub animated:YES];
            }
                break;
            case 5:
            {
                EquipmentListViewController *sub = [[EquipmentListViewController alloc] init];
                sub.title = @"选择样机名";
                sub.block = ^(NSArray *demoName,NSArray *demoIDs)
                {
                    NSString *ns=[demoName componentsJoinedByString:@","];
                    model.demoMachiNames3 = ns;
                    model.demoMachiIDs3 = demoIDs[0];
                    
                    [_tableViewLeft reloadData];
                };
                [self.navigationController pushViewController:sub animated:YES];
            }
                break;
                
            default:
                break;
        }
        
    }
    if (indexPath.section == 6 && indexPath.row == 1)
    {
        NSArray * str  = @[@"10%",@"20%",@"30%",@"40%",@"50%",@"60%",@"70%",@"80%",@"90%",@"100%"];
        zySheetPickerView *pickerView = [zySheetPickerView ZYSheetStringPickerWithTitle:str andHeadTitle:@"选择成功率" Andcall:^(zySheetPickerView *pickerView, NSString *choiceString) {
            float flo = [[choiceString substringToIndex:2] floatValue]*0.01;
            if ([choiceString isEqualToString:@"100%"])
            {
                flo = 1.0f;
            }
            JCKLog(@"%@",[NSString stringWithFormat:@"%.1f",flo]);
            proSucess = [NSString stringWithFormat:@"%.1f",flo];
            model.proSucess = choiceString;
            [pickerView dismissPicker];
            [_tableViewLeft reloadData];
        }];
        [pickerView show];
    }
    if (indexPath.section == 6 && indexPath.row ==0)
    {
        NSArray * str  = @[@"申报项目",@"样机申请",@"招标参数准备",@"中标",@"合同",@"备货",@"发货",@"付款",@"完结",@"终结"];
        zySheetPickerView *pickerView = [zySheetPickerView ZYSheetStringPickerWithTitle:str andHeadTitle:@"选择项目当前状态" Andcall:^(zySheetPickerView *pickerView, NSString *choiceString)
        {
            model.proState = choiceString;
            if ([choiceString isEqualToString:@"申报项目"])
            {
                model.proStateID = @"0";
            }
            if ([choiceString isEqualToString:@"样机申请"])
            {
                model.proStateID = @"1";
            }
            if ([choiceString isEqualToString:@"招标参数准备"])
            {
                model.proStateID = @"6";
            }
            if ([choiceString isEqualToString:@"中标"])
            {
                model.proStateID = @"7";
            }
            if ([choiceString isEqualToString:@"合同"])
            {
                model.proStateID = @"8";
            }
            if ([choiceString isEqualToString:@"备货"])
            {
                model.proStateID = @"2";
            }
            if ([choiceString isEqualToString:@"发货"])
            {
                model.proStateID = @"3";
            }
            if ([choiceString isEqualToString:@"付款"])
            {
                model.proStateID = @"4";
            }
            if ([choiceString isEqualToString:@"完结"])
            {
                model.proStateID = @"5";
            }
            if ([choiceString isEqualToString:@"终止"])
            {
                model.proStateID = @"9";
            }
            [pickerView dismissPicker];
            [_tableViewLeft reloadData];
        }];
        [pickerView show];
    }


}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    switch (textField.tag)
    {
//        case 1999:
//        {
//            model.productCount = textField.text;
//        }
//            break;
        case 1002:
        {
            model.proName = textField.text;
        }
            break;
        case 2002:
        {
            model.productPrice = textField.text;
        }
            break;
        case 2004:
        {
            model.productPrice2 = textField.text;
        }
            break;
        case 2006:
        {
            model.productPrice3 = textField.text;
        }
            break;
        case 2008:
        {
            model.productPrice4 = textField.text;
        }
            break;
        case 2010:
        {
            model.productPrice5 = textField.text;
        }
            break;
        case 2102:
        {
            model.productCount = textField.text;
        }
            break;
        case 2104:
        {
            model.productCount2 = textField.text;
        }
            break;
        case 2106:
        {
            model.productCount3 = textField.text;
        }
            break;
        case 2108:
        {
            model.productCount4 = textField.text;
        }
            break;
        case 2110:
        {
            model.productCount5 = textField.text;
        }
            break;
        case 3002:
        {
            model.demoMaCount = textField.text;
        }
            break;
        case 3004:
        {
            model.demoMaCount2 = textField.text;
        }
            break;
        case 3006:
        {
            model.demoMaCount3 = textField.text;
        }
            break;
        case 4000:
        {
            model.proLinkMan = textField.text;
        }
            break;
        case 4001:
        {
            model.proLinkTel = textField.text;
        }
            break;
        case 4002:
        {
            model.proLinkManDepart = textField.text;
        }
            break;
        case 4003:
        {
            model.proLinkManZhiwu = textField.text;
        }
            break;
        case 8000:
        {
            model.signinContext = textField.text;
        }
            break;
        case 7000:
        {
            model.FeeApplyTravelCount = textField.text;
        }
            break;
        case 7001://
        {
            costDetailModel.entertain = textField.text;
        }
            break;
        case 7002://
        {
            costDetailModel.gift = textField.text;
        }
            break;
        case 7003:
        {
            model.FeeApplyOtherCount = textField.text;
        }
            break;
            
        default:
            break;
    }
    return YES;
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
//    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
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
        UILabel *lb = (UILabel *)[_tableViewLeft viewWithTag:10010];
        lb.text = result.address;
        model.location = result.address;
    }
    
}
#pragma mark - 拜访事件
- (void)signinNew
{
    // 判断输入为空
    if (model.proName.length == 0 ||
        model.cusName.length == 0 ||
        model.proLinkMan.length == 0 ||
        [NSString stringWithFormat:@"%@",model.proLinkTel].length == 0 ||
        [NSString stringWithFormat:@"%@",proSucess].length == 0 ||
        model.signinContext.length == 0 ||
        model.location.length == 0 
        )
    {
        NSString *msgError;
        if (model.proName.length == 0)
        {
            msgError = @"项目名称";
        }
        else if (model.cusName.length == 0)
        {
            msgError = @"医院称城为空";
        }
        else if (model.proLinkMan.length == 0)
        {
            msgError = @"联系人名为空";
        }
        else if (model.proLinkTel.length == 0)
        {
            msgError = @"联系电话为空";
        }
        else if ([NSString stringWithFormat:@"%@",proSucess].length == 0)
        {
            msgError = @"项目成功率为空";
        }
        else if (model.signinContext.length == 0)
        {
            msgError = @"拜访记录为空";
        }
        else if (model.demoMaCount.length == 0)
        {
            msgError = @"样机数量为空";
        }
        else if (model.demoMachiNames.length == 0)
        {
            msgError = @"样机为空";
        }
        //初始化提示框；
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"%@请补全",msgError] preferredStyle: UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //点击按钮的响应事件；
        }]];
        
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
        
    }
    else // 输入不为空
    {

        NSString *feeApplyModelStr = @"";
        if (!costDetailModel.entertain || [costDetailModel.entertain isEqualToString:@""])
        {
            costDetailModel.entertain = @"0";
        }
        if (!costDetailModel.gift|| [costDetailModel.gift isEqualToString:@""])
        {
            costDetailModel.gift = @"0";
        }
        
        if (!costDetailModel.planeCost|| [costDetailModel.planeCost isEqualToString:@""])
        {
            costDetailModel.planeCost = @"0";
        }
        if (!costDetailModel.longDistanceTransport|| [costDetailModel.longDistanceTransport isEqualToString:@""])
        {
            costDetailModel.longDistanceTransport = @"0";
        }
        if (!costDetailModel.accommodation|| [costDetailModel.accommodation isEqualToString:@""])
        {
            costDetailModel.accommodation = @"0";
        }
        if (!costDetailModel.luqiao|| [costDetailModel.luqiao isEqualToString:@""])
        {
            costDetailModel.luqiao = @"0";
        }
        if (!costDetailModel.onAbusinessTripToTheTraffic|| [costDetailModel.onAbusinessTripToTheTraffic isEqualToString:@""])
        {
            costDetailModel.onAbusinessTripToTheTraffic = @"0";
        }
        if (!costDetailModel.onAbusinessTripAllowance|| [costDetailModel.onAbusinessTripAllowance isEqualToString:@""])
        {
            costDetailModel.onAbusinessTripAllowance = @"0";
        }
        
        if (!costDetailModel.logistics|| [costDetailModel.logistics isEqualToString:@""])
        {
            costDetailModel.logistics = @"0";
        }
        if (!costDetailModel.print|| [costDetailModel.print isEqualToString:@""])
        {
            costDetailModel.print = @"0";
        }
        if (!costDetailModel.bidToMake|| [costDetailModel.bidToMake isEqualToString:@""])
        {
            costDetailModel.bidToMake = @"0";
        }
        if (!costDetailModel.officeSupplies|| [costDetailModel.officeSupplies isEqualToString:@""])
        {
            costDetailModel.officeSupplies = @"0";
        }
        if (!costDetailModel.purchaseditems|| [costDetailModel.purchaseditems isEqualToString:@""])
        {
            costDetailModel.purchaseditems = @"0";
        }
        if (!costDetailModel.communicationallowance|| [costDetailModel.communicationallowance isEqualToString:@""])
        {
            costDetailModel.communicationallowance = @"0";
        }
        if (!costDetailModel.trafficSubsidies|| [costDetailModel.trafficSubsidies isEqualToString:@""])
        {
            costDetailModel.trafficSubsidies = @"0";
        }
        if (!costDetailModel.housingSubsidies|| [costDetailModel.housingSubsidies isEqualToString:@""])
        {
            costDetailModel.housingSubsidies = @"0";
        }

        if (!model.plantPrototype)
        {
            model.plantPrototype = @"";
        }
        if (!model.plantParametersAndTheSolution)
        {
            model.plantParametersAndTheSolution = @"";
        }
        if (!model.plantTender)
        {
            model.plantTender = @"";
        }
        if (!model.plantContract)
        {
            model.plantContract = @"";
        }
        if (!model.plantInvoice)
        {
            model.plantInvoice = @"";
        }
        if (!model.plantDelivery)
        {
            model.plantDelivery = @"";
        }
        if (!model.plantPayment)
        {
            model.plantPayment = @"";
        }
    
        feeApplyModelStr = [self setFeeApplyDatas];
        NSString *setProjectDatas = [self setProjectDatas];

        NSString *bulidLinkManData = @"";
        if (model.ProlinkManID == nil || model.ProlinkManID == NULL || [model.ProlinkManID isKindOfClass:[NSNull class]] || [[NSString stringWithFormat:@"%@",model.ProlinkManID ] isEqualToString:@""]) {
            JCKLog(@"新建联系人");
             bulidLinkManData = [self bulidLinkMan];
        }

        /*
         @"CustID": custcontactsaves[0],
         @"CustLinkMan": custcontactsaves[1],
         @"Title": custcontactsaves[2],
         @"LinkDate": [self getData],
         @"Contents":custcontactsaves[3],
         @"Lat": custcontactsaves[4],
         @"Lon": custcontactsaves[5],
         @"LinkTel":custcontactsaves[6],
         @"LocationAddress":custcontactsaves[7],
         @"ProjectID": custcontactsaves[8],
         @"ProjectName": custcontactsaves[9],
         @"FeeApplyModelStr": custcontactsaves[10],
         @"IsPaterner": custcontactsaves[11],
         @"CustLinkManModelStr" : custcontactsaves[12],
         @"ProjectModelStr" : custcontactsaves[13],
         @"Status": custcontactsaves[14],
         */
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        manger.sigins = @[[NSString stringWithFormat:@"%@",coustomerId], //客户ID CustID
                          model.proLinkMan, // 联系人 CustLinkMan
                          [NSString stringWithFormat:@"%@",model.signinContext], // 标题 Title
                          [NSString stringWithFormat:@"%@",model.signinContext], // 拜访内容 Contents
                          [user objectForKey:@"userLat"], // Lat
                          [user objectForKey:@"userLon"], // Lon
                          [NSString stringWithFormat:@"%@", model.proLinkTel],// 电话 LinkTel
                          model.location, //地址 LocationAddress
                          [NSString stringWithFormat:@"%@",model.proID], // ProjectID
                          model.proName, // ProjectName
                          feeApplyModelStr, // FeeApplyModelStr
                          @"0", // IsPaterner
                          bulidLinkManData, // CustLinkManModelStr
                          setProjectDatas, // ProjectModelStr
                          ];
        NSLog(@"%@",manger.sigins);
        [manger loadData:RequestOfCustcontactsave];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popCtr) name:@"custcontactsave" object:nil];
    }

}
// 项目
- (NSString *)setProjectDatas
{
//    NSString *OrderDetailsStr = @"";
    if (!model.productIDs || [model.productIDs isEqualToString:@""])
    {
        model.productIDs = @"0";
    }
    if (!model.productIDs2|| [model.productIDs2 isEqualToString:@""])
    {
        model.productIDs2 = @"0";
    }
    if (!model.productIDs3|| [model.productIDs3 isEqualToString:@""])
    {
        model.productIDs3 = @"0";
    }
    if (!model.productIDs4|| [model.productIDs4 isEqualToString:@""])
    {
        model.productIDs4 = @"0";
    }
    if (!model.productIDs5|| [model.productIDs5 isEqualToString:@""])
    {
        model.productIDs5 = @"0";
    }
    
    
    if (!model.productCount|| [model.productCount isEqualToString:@""])
    {
        model.productCount = @"0";
    }
    if (!model.productCount2|| [model.productCount2 isEqualToString:@""])
    {
        model.productCount2 = @"0";
    }
    if (!model.productCount3|| [model.productCount3 isEqualToString:@""])
    {
        model.productCount3 = @"0";
    }
    if (!model.productCount4|| [model.productCount4 isEqualToString:@""])
    {
        model.productCount4 = @"0";
    }
    if (!model.productCount5|| [model.productCount5 isEqualToString:@""])
    {
        model.productCount5 = @"0";
    }
    
    
    if (!model.productPrice|| [model.productPrice isEqualToString:@""])
    {
        model.productPrice = @"0";
    }
    if (!model.productPrice2|| [model.productPrice2 isEqualToString:@""])
    {
        model.productPrice2 = @"0";
    }
    if (!model.productPrice3|| [model.productPrice3 isEqualToString:@""])
    {
        model.productPrice3 = @"0";
    }
    if (!model.productPrice4|| [model.productPrice4 isEqualToString:@""])
    {
        model.productPrice4 = @"0";
    }
    if (!model.productPrice5|| [model.productPrice5 isEqualToString:@""])
    {
        model.productPrice5 = @"0";
    }
    
    
    
    if (!model.demoMaCount|| [model.demoMaCount isEqualToString:@""])
    {
        model.demoMaCount = @"0";
    }
    if (!model.demoMaCount2|| [model.demoMaCount2 isEqualToString:@""])
    {
        model.demoMaCount2 = @"0";
    }
    if (!model.demoMaCount3|| [model.demoMaCount3 isEqualToString:@""])
    {
        model.demoMaCount3 = @"0";
    }
    
    if (!model.demoMachiIDs)
    {
        model.demoMachiIDs = @"0";
    }
    if (!model.demoMachiIDs2)
    {
        model.demoMachiIDs2 = @"0";
    }
    if (!model.demoMachiIDs3)
    {
        model.demoMachiIDs3 = @"0";
    }
    
//    NSArray *demoproducts;
    JCKLog(@"%@ %@ %@",model.demoMachiIDs,model.demoMachiIDs2,model.demoMachiIDs3);
//    if (model.demoMachiIDs != nil || model.demoMachiIDs != NULL || ![model.demoMachiIDs isKindOfClass:[NSNull class]] || [[model.demoMachiIDs stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]!=0)
//    {
//            demoproducts = @[@{
//                                 @"productID":[NSString stringWithFormat:@"%@",model.demoMachiIDs],
//                                 @"productCount":model.demoMaCount
//                                     },
//                             @{
//                                 @"productID":[NSString stringWithFormat:@"%@",model.demoMachiIDs2],
//                                 @"productCount":model.demoMaCount2
//                                 },
//                             @{
//                                 @"productID":[NSString stringWithFormat:@"%@",model.demoMachiIDs3],
//                                 @"productCount":model.demoMaCount3
//                                 }];
////        productDicStr = [products mj_JSONString];
//    }
    NSArray *demoproducts = @[@{
                         @"productID":[NSString stringWithFormat:@"%@",model.demoMachiIDs],
                         @"productCount":model.demoMaCount
                         },
                     @{
                         @"productID":[NSString stringWithFormat:@"%@",model.demoMachiIDs2],
                         @"productCount":model.demoMaCount2
                         },
                     @{
                         @"productID":[NSString stringWithFormat:@"%@",model.demoMachiIDs3],
                         @"productCount":model.demoMaCount3
                         }];
    NSArray *productstest;
    JCKLog(@"%@",demoproducts);
    JCKLog(@"%@ %@ %@",model.productIDs,model.productIDs2,model.productIDs3);

    productstest = @[@{
                         @"ProductID":model.productIDs,
                         @"ProductCount":model.productCount,
                         @"UnitPrice":model.productPrice
                         },
                     @{
                         @"ProductID":model.productIDs2,
                         @"ProductCount":model.productCount2,
                         @"UnitPrice":model.productPrice2
                         },
                     @{
                         @"ProductID":model.productIDs3,
                         @"ProductCount":model.productCount3,
                         @"UnitPrice":model.productPrice3
                         }];
   JCKLog(@"%@",productstest);
    if (model.proID.length == 0)
    {
        model.proID = @"0";
    }

    JCKLog(@"%@",model);
    NSArray *ProjectDocs = @[@{
                        @"ProcessId":@"1",
                        @"PlanDateStr":model.plantPrototype,
                        
                        },
                    @{
                        @"ProcessId":@"6",
                        @"PlanDateStr":model.plantParametersAndTheSolution,
                        
                        }
                    ,
                    @{
                        @"ProcessId":@"7",
                        @"PlanDateStr":model.plantTender,
                        
                        }
                    ,
                    @{
                        @"ProcessId":@"8",
                        @"PlanDateStr":model.plantContract,
                        
                        }
                    ,
                    @{
                        @"ProcessId":@"3",
                        @"PlanDateStr":model.plantInvoice,
                        
                        }
                    ,
                    @{
                        @"ProcessId":@"10",
                        @"PlanDateStr":model.plantDelivery,
                        
                        }
                    ,
                    @{
                        @"ProcessId":@"4",
                        @"PlanDateStr":model.plantPayment,
                        
                        }];

    /*________________*/
    JCKLog(@"%@",ProjectDocs);
    if ([productstest count] != 0)
    {
        if ([demoproducts count] != 0) //有产品有样机
        {
            NSDictionary *parameters = @{
                                         @"ID":  model.proID,
                                         @"companyId": coustomerId,
                                         @"ProjectName": model.proName,
                                         @"CustLinkMan": model.proLinkMan,
                                         @"CustLinkTel":  model.proLinkTel,
                                         @"SuccessRate": proSucess,
                                         @"Details":demoproducts,
                                         @"Status":  model.proStateID ,// Status
                                         @"OrderDetails":productstest,
                                         @"ProjectDocs":ProjectDocs
                                         };
            NSString *detailstr = [parameters mj_JSONString];
            if (detailstr.length == 0)
            {
                detailstr = @"";
            }
            return detailstr;
        }
        else // 有产品无样机
        {
            NSDictionary *parameters = @{
                                         @"ID":  model.proID,
                                         @"companyId": coustomerId,
                                         @"ProjectName": model.proName,
                                         @"CustLinkMan": model.proLinkMan,
                                         @"CustLinkTel":  model.proLinkTel,
                                         @"SuccessRate": proSucess,
//                                         @"Details":demoproducts,
                                         @"Status":  model.proStateID ,// Status
                                         @"OrderDetails":productstest,
                                         @"ProjectDocs":ProjectDocs
                                         };
            NSString *detailstr = [parameters mj_JSONString];
            if (detailstr.length == 0)
            {
                detailstr = @"";
            }
            return detailstr;
        }

    }
    else
    {
        if ([demoproducts count] != 0) // 有样机，无产品
        {
            NSDictionary *parameters = @{
                                         @"ID":  model.proID,
                                         @"companyId": coustomerId,
                                         @"ProjectName": model.proName,
                                         @"CustLinkMan": model.proLinkMan,
                                         @"CustLinkTel":  model.proLinkTel,
                                         @"SuccessRate": proSucess,
                                         @"Details":demoproducts,
                                         @"Status":  model.proStateID ,// Status
                                         //                                     @"OrderDetails":productstest,
                                         @"ProjectDocs":ProjectDocs
                                         };
            NSString *detailstr = [parameters mj_JSONString];
            if (detailstr.length == 0)
            {
                detailstr = @"";
            }
            return detailstr;

        }
        else // 无产品无产品
        {
            NSDictionary *parameters = @{
                                         @"ID":  model.proID,
                                         @"companyId": coustomerId,
                                         @"ProjectName": model.proName,
                                         @"CustLinkMan": model.proLinkMan,
                                         @"CustLinkTel":  model.proLinkTel,
                                         @"SuccessRate": proSucess,
//                                         @"Details":demoproducts,
                                         @"Status":  model.proStateID ,// Status
                                         //                                     @"OrderDetails":productstest,
                                         @"ProjectDocs":ProjectDocs
                                         };
            NSString *detailstr = [parameters mj_JSONString];
            if (detailstr.length == 0)
            {
                detailstr = @"";
            }
            return detailstr;

        }
       
    }
    

}
// 费用
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
    if (detailstr.length == 0)
    {
        detailstr = @"";
    }
    return detailstr;
}
// 拜访成功后跳转到详细页面
- (void)popCtr
{
//    [self.navigationController popViewControllerAnimated:YES];
    //初始化提示框；
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"拜访信息提交成功" preferredStyle: UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        HistoryInfoViewController *sub = [[HistoryInfoViewController alloc] init];
        // 标题 客户名 时间 拜访人 电话 地址 内容
        sub.title = @"拜访详情";
        if (coustomerId.length == 0)
        {
            sub.ID = model.proID;
        }
        else
        {
            sub.ID = coustomerId;
        }
        [self.navigationController pushViewController:sub animated:YES];
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}
// 新建联系人
- (NSString *)bulidLinkMan
{
    if ([model.ProlinkManID length] == 0)
    {
        model.ProlinkManID = @"0";
    }
    NSDictionary *parameters = @{
                                 @"ID": model.ProlinkManID,
                                 @"CustNo": model.proNo,
                                 @"LinkManName": model.proLinkMan,
                                 @"Department": model.proLinkManDepart,
                                 @"Position":model.proLinkManZhiwu,
                                 @"WorkTel": model.proLinkTel,
                                 };
    NSString *detailstr = [parameters mj_JSONString];// 费用JSON
    if (detailstr.length == 0)
    {
        detailstr = @"";
    }
    return detailstr;

}

- (void)enterInfoList
{
    TheNewCustomerListController *sub = [[TheNewCustomerListController alloc] init];
    sub.title = @"客户联系人";
    [self.navigationController pushViewController:sub animated:YES];
    
}
// 添加产品cell
- (void)addProduct
{
/* 跳转到其他页面进行添加 未完成
    if (cellCount > 6)
    {
        return;
    }
    else
    {
        cellCount = cellCount + 2;
        //一个section刷新
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
        [_tableViewLeft reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    ProductsSubmittedViewController *sub = [[ProductsSubmittedViewController alloc] init];
    sub.title = @"填写产品信息";
    sub.productsblock = ^(NSString *productName,NSString *productID,NSString *productPrice,NSString *productCount,BOOL isAdd)
    {
        
    };
    [self.navigationController pushViewController:sub animated:YES];
*/
    if (cellCount > 10)
    {
        return;
    }
    else
    {
        cellCount = cellCount + 2;
        //一个section刷新
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
        [_tableViewLeft reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }
   
}
// 添加样机cell
- (void)addDemo
{
    if (demoCellCount > 6)
    {
        return;
    }
    else
    {
        demoCellCount = demoCellCount + 2;
        // 一个section刷新
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
        [_tableViewLeft reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }

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
        if ([model.FeeApplyTravelCount isEqualToString:@""] || [model.FeeApplyTravelCount isEqualToString:@"0"])
        {
            model.FeeApplyTravelCount = nil;
        }

        model.FeeApplyOtherCount = [NSString stringWithFormat:@"%ld",[costDetailModel.logistics integerValue] + [costDetailModel.print integerValue]  + [costDetailModel.bidToMake integerValue]  + [costDetailModel.officeSupplies integerValue]  + [costDetailModel.purchaseditems integerValue]  + [costDetailModel.communicationallowance integerValue] + [costDetailModel.trafficSubsidies integerValue] + [costDetailModel.housingSubsidies integerValue]];
        if ([model.FeeApplyOtherCount isEqualToString:@""] || [model.FeeApplyOtherCount isEqualToString:@"0"])
        {
            model.FeeApplyOtherCount = nil;
        }
        [_tableViewLeft reloadData];
    };
    
    [self.navigationController pushViewController:sub animated:YES];

}
#pragma 时间工具
- (void)showDateTool:(UIButton *)btn
{
    daterTool.tag = btn.tag;
    [daterTool showInView:self.view animated:YES];
}
#pragma mark - XFDaterViewDelegate
- (void)daterViewDidClicked:(XFDaterView *)daterView
{
    JCKLog(@"daterTool.tag - %ld %@",daterTool.tag,daterTool.dateString);
//    NSLog(@"dateString=%@ timeString=%@",daterTool.dateString,daterTool.timeString);

    if ([self compareDateWithSelectDate:daterTool.dateString] >= 0 )
    {
        switch (daterTool.tag)
        {
            case 80000:
            {
                model.plantPrototype = daterTool.dateString;
            }
                break;
            case 90000:
            {
                 model.plantParametersAndTheSolution = daterTool.dateString;
            }
                break;
            case 80001:
            {
                model.plantTender = daterTool.dateString;
            }
                break;
            case 90001:
            {
                 model.plantContract = daterTool.dateString;
            }
                break;
            case 80002:
            {
                model.plantDelivery = daterTool.dateString;
            }
                break;
            case 90002:
            {
                 model.plantInvoice = daterTool.dateString;
            }
                break;
            case 80003:
            {
                 model.plantPayment = daterTool.dateString;
            }
                break;
                
            default:
                break;
        }
        
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
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:5];
    [_tableViewLeft reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
//    [_tableViewLeft reloadData];
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
#pragma 查询单个项目回调
- (void)receiveData
{
    int j = 0;
    for (NSDictionary *dic in manger.ProductList)
    {
//        model.demoMachiNames = [NSString stringWithFormat:@"%@",dic[@"ProductName"]];
//        model.demoMaCount = [NSString stringWithFormat:@"%@",dic[@"ProductCount"]];
        switch (j) {
            case 0:
            {
                model.demoMachiNames =  [NSString stringWithFormat:@"%@",dic[@"ProductName"]];
                
                model.demoMaCount =  [NSString stringWithFormat:@"%@",dic[@"ProductCount"]];
            }
                break;
            case 1:
            {
                model.demoMachiNames2 =  [NSString stringWithFormat:@"%@",dic[@"ProductName"]];
                
                model.demoMaCount2 =  [NSString stringWithFormat:@"%@",dic[@"ProductCount"]];
            }
                break;
            case 2:
            {
                model.demoMachiNames3 =  [NSString stringWithFormat:@"%@",dic[@"ProductName"]];
                
                model.demoMaCount3 =  [NSString stringWithFormat:@"%@",dic[@"ProductCount"]];
            }
                break;
            case 3:
            {
                //初始化提示框；
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络繁忙请重新加载" preferredStyle: UIAlertControllerStyleAlert];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //点击按钮的响应事件；
                }]];
                
                //弹出提示框；
                [self presentViewController:alert animated:true completion:nil];
            }
                break;
                
            default:
                break;
        }
        j++;

    }
    if ([manger.ProductList count] == 0)
    {
        demoCellCount = 3;
    }
    else
    {
        isSecletDemo = YES;
        demoCellCount = ([manger.ProductList count]*2) + 1;
    }
    
    int i = 0;
    for (NSDictionary *dic in manger.sellOrders)
    {
        JCKLog(@"%@",dic[@"ProductName"]);
        switch (i) {
            case 0:
            {
                model.productNames =  [NSString stringWithFormat:@"%@",dic[@"ProductName"]];
                model.productCount =  [NSString stringWithFormat:@"%@",dic[@"ProductCount"]];
                model.productPrice =  [NSString stringWithFormat:@"%@",dic[@"UsedPrice"]];
            }
                break;
            case 1:
            {
                model.productNames2 =  [NSString stringWithFormat:@"%@",dic[@"ProductName"]];
                model.productCount2 =  [NSString stringWithFormat:@"%@",dic[@"ProductCount"]];
                model.productPrice2 =  [NSString stringWithFormat:@"%@",dic[@"UsedPrice"]];
            }
                break;
            case 2:
            {
                model.productNames3 =  [NSString stringWithFormat:@"%@",dic[@"ProductName"]];
                model.productCount3 =  [NSString stringWithFormat:@"%@",dic[@"ProductCount"]];
                model.productPrice3 =  [NSString stringWithFormat:@"%@",dic[@"UsedPrice"]];
            }
                break;
            case 3:
            {
                //初始化提示框；
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络繁忙请重新加载" preferredStyle: UIAlertControllerStyleAlert];

                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //点击按钮的响应事件；
                }]];

                //弹出提示框；
                [self presentViewController:alert animated:true completion:nil];
            }
                break;
                
            default:
                break;
        }
        i++;
    }
    JCKLog(@"%d",i);
//    if ([manger.sellOrders count] != 0)
//    {
//        isSeclet = YES;
//    }
    if ([manger.sellOrders count] == 0)
    {
        cellCount = 3;
    }
    else
    {
         isSeclet = YES;
        cellCount = ([manger.sellOrders count]*2) + 1;
    }
    
    
    for (NSDictionary *dic in manger.constructionDetails)
    {
        ProjectInfoModel *projectInfoModel = [ProjectInfoModel mj_objectWithKeyValues:dic];
        JCKLog(@"PlanDate%@ ProcessId%@ ProcessName%@",projectInfoModel.PlanDate,projectInfoModel.ProcessId,projectInfoModel.ProcessName);
        
        if ([projectInfoModel.ProcessId isEqualToString:@"1"] && projectInfoModel.PlanDate.length !=0) // 1样机
        {
            if (projectInfoModel.PlanDate)
            {
                model.plantPrototype = [projectInfoModel.PlanDate substringToIndex:10];//截取掉下标7之后的字符串;
            }
            
        }
        else if ([projectInfoModel.ProcessId isEqualToString:@"6"] && projectInfoModel.PlanDate.length !=0) // 6参数
        {
            if (projectInfoModel.PlanDate)
            {
                model.plantParametersAndTheSolution = [projectInfoModel.PlanDate substringToIndex:10];//截取掉下标7之后的字符串;
;
            }
        }
        else if ([projectInfoModel.ProcessId isEqualToString:@"7"] && projectInfoModel.PlanDate.length !=0) // 7招标
        {
            if (projectInfoModel.PlanDate)
            {
                model.plantTender = [projectInfoModel.PlanDate substringToIndex:10];//截取掉下标7之后的字符串;
;
            }
        }
        else if ([projectInfoModel.ProcessId isEqualToString:@"8"] && projectInfoModel.PlanDate.length !=0) // 合同
        {
            if (projectInfoModel.PlanDate)
            {
                model.plantContract = [projectInfoModel.PlanDate substringToIndex:10];//截取掉下标7之后的字符串;
;
            }
        }
        else if ([projectInfoModel.ProcessId isEqualToString:@"3"] && projectInfoModel.PlanDate.length !=0) // 交货
        {
            if (projectInfoModel.PlanDate)
            {
                model.plantDelivery = [projectInfoModel.PlanDate substringToIndex:10];//截取掉下标7之后的字符串;
;
            }
        }
        else if ([projectInfoModel.ProcessName isEqualToString:@"10"] && projectInfoModel.PlanDate.length !=0) // 10发票
        {
            if (projectInfoModel.PlanDate)
            {
                model.plantInvoice = [projectInfoModel.PlanDate substringToIndex:10];//截取掉下标7之后的字符串;
;
            }
        }
        else if ([projectInfoModel.ProcessName isEqualToString:@"4"] && projectInfoModel.PlanDate.length !=0) // 4付款
        {
            if (projectInfoModel.PlanDate)
            {
                model.plantPayment = [projectInfoModel.PlanDate substringToIndex:10];//截取掉下标7之后的字符串;
;
            }
        }
//        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:5];
//        [_tableViewLeft reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        [_tableViewLeft reloadData];
    }
}
@end

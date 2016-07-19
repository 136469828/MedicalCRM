
//
//  SigninViewController.m
//  MedicalCRM
//
//  Created by admin on 16/7/11.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "SigninViewController.h"
#import "PublishedController.h"
#import "HistoryViewController.h"
#import "MapViewController.h"
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
@interface SigninViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    BMKMapView * _mapview;
    BMKLocationService *_locService;
    CLLocationCoordinate2D _touchMapCoordinate;  //  当前那一点的经纬度

}
@end

@implementation SigninViewController
- (void)viewWillAppear:(BOOL)animated
{
    [_mapview viewWillAppear];
    _mapview.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_mapview viewWillDisappear];
    _mapview.delegate = nil; // 不用时，置nil
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *date = [self getWeek];
    self.dayLab.text = [NSString stringWithFormat:@"%@: %@-%@-%@",date[5],date[0],date[1],date[2]];
    self.timeLab.text = [NSString stringWithFormat:@"时间: %@:%@",date[3],date[4]];
    // Do any additional setup after loading the view from its nib.
    [self setMapView];
    self.contLab.text = @"99";
    self.siginBtn.layer.cornerRadius = 40;
    self.hearImg.layer.cornerRadius = 10;
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(25, (btnSizH/2), 30, 30)];
    img.image = [UIImage imageNamed:@"灯光提示"];
    [self.siginBtn addSubview:img];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(btnSizW/2-15, btnSizH+20, 60, 20)];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = @"一键拜访";
    lab.font = [UIFont systemFontOfSize:12];
    lab.textColor = [UIColor whiteColor];
    [self.siginBtn addSubview:lab];
#pragma mark - 设置navigationItem右侧按钮
    UIButton *meassageBut = ({
        UIButton *meassageBut = [UIButton buttonWithType:UIButtonTypeCustom];
        meassageBut.frame = CGRectMake(0, 0, 60, 20);
        [meassageBut addTarget:self action:@selector(pushHistory) forControlEvents:UIControlEventTouchDown];
        meassageBut.titleLabel.font = [UIFont systemFontOfSize:15];
        [meassageBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [meassageBut setTitle:@"拜访历史" forState:UIControlStateNormal];
        meassageBut;
    });
    
    UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithCustomView:meassageBut];
    self.navigationItem.rightBarButtonItem = rBtn;
    
    [self.siginBtn addTarget:self action:@selector(pushPSSCtr) forControlEvents:UIControlEventTouchDown];
    [self.addressBtn addTarget:self action:@selector(pushMapView) forControlEvents:UIControlEventTouchDown];
}
- (void)setMapView
{
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    _mapview = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth/2.5, ScreenHeight/4-50)];
    [self.mapView addSubview: _mapview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)pushMapView
{
    MapViewController *sub = [[MapViewController alloc] init];
    sub.title = @"地图微调";
    [self.navigationController pushViewController:sub animated:YES];

}
#pragma mark - btnAction
- (void)pushPSSCtr
{
    PublishedController *sub = [[PublishedController alloc] init];
    sub.title = @"确认拜访";
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    sub.lat = [user objectForKey:@"userLat"];
    sub.lon = [user objectForKey:@"userLon"];
    [self.navigationController pushViewController:sub animated:YES];

}
- (void)pushHistory
{
    HistoryViewController *sub = [[HistoryViewController alloc] init];
    sub.title = @"历史记录";
    [self.navigationController pushViewController:sub animated:YES];
    
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
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    double lat = userLocation.location.coordinate.latitude;
    double lon = userLocation.location.coordinate.longitude;
    [user setObject:[NSString stringWithFormat:@"%f",lat] forKey:@"userLat"];
    [user setObject:[NSString stringWithFormat:@"%f",lon]  forKey:@"userLon"];
    
    coor.latitude = userLocation.location.coordinate.latitude;
    coor.longitude = userLocation.location.coordinate.longitude;
    
//    NextManger *manger = [NextManger shareInstance];
//    manger.userLat = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
//    manger.userLon = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
    
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
        //        NSString *cccc = [result.addressDetail.city substringToIndex:[result.addressDetail.city length] - 1];
//        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//        [user setObject:result.addressDetail.city forKey:@"city"];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"city" object:nil];
//        
//        [user setObject:[NSString stringWithFormat:@"%@%@%@",result.addressDetail.city,result.addressDetail.district,result.addressDetail.streetName] forKey:@"ShippingAddress"];
        self.locationLab.text = result.address;
        self.addressLab.text = @"当前所在位置";
    }
    
}
#pragma mark - dateFun
- (NSArray *)getWeek
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    now=[NSDate date];
    comps = [calendar components:unitFlags fromDate:[NSDate date]];
    int year=[comps year];
    int week = [comps weekday];
    int month = [comps month];
    int day = [comps day];
    int hour = [comps hour];
    int min = [comps minute];
    
    NSArray * arrWeek=[NSArray arrayWithObjects:@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    
    NSLog(@"%d年 %d月 %d日 %d时 %d分%@",year,month,day,hour,min,[NSString stringWithFormat:@"%@",[arrWeek objectAtIndex:[comps weekday] - 1]]);
    NSArray *dateInfo = @[[NSString stringWithFormat:@"%d",year],
                          [NSString stringWithFormat:@"%d",month],
                          [NSString stringWithFormat:@"%d",day],
                          [NSString stringWithFormat:@"%d",hour],
                          [NSString stringWithFormat:@"%d",min],
                          [arrWeek objectAtIndex:[comps weekday] - 1]];
    return dateInfo;
}
@end

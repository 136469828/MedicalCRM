//
//  NetManger.m
//  MedicalCRM
//
//  Created by admin on 16/7/15.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "NetManger.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "SVProgressHUD.h"
#import "ProjectModel.h"
#import "Advertiselist.h"
#import "GetnoticepagelistModel.h"
#import "GetprojectpagelistModel.h"
#import "CustpagelistModel.h"
#import "CustlinkmanlistModel.h"
#import "CustcontactpagelistModel.h"
static NetManger *manger = nil;
static NSString *code;
@implementation NetManger

// 单例
+ (instancetype)shareInstance{
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        if (!manger) {
            manger = [[[self class] alloc] init];
            
        }
    });
    return manger;
}
- (instancetype)initWith:(RequestState)requet
{
    self = [super init];
    if (self) {
        [self loadData:requet];
    }
    return self;
}
- (void)loadData:(RequestState)requet
{
    switch (requet) {
        case RequestOfLogin:
        {
            [self login];
        }
            break;
        case RequestOfadvertise:
        {
            [self getadvertiselist];
        }
            break;
        case RequestOfGetarticlelist:
        {
            [self systemsetGetnoticepagelist];
        }
            break;
        case RequestOfgetprojectpagelist:
        {
            [self Getprojectpagelist];
        }
            break;
        case RequestOfAccountUpdate:
        {
            [self AccountUpdate:self.userInfos];
            [self Uploadphoto:self.photoData];
        }
            break;
        case RequestOfGetminecustpagelist:
        {
            [self Getminecustpagelist];
        }
            break;
        case RequestOfGetcustlinkmanlist:
        {
            [self Getcustlinkmanlist:self.customID];
        }
            break;
        case RequestOfCustcontactsave:
        {
            [self Custcontactsave:self.sigins];
        }
            break;
         
        default:
            break;
    }
    
    NSLog(@"userCode:%@",self.userCode);
}
#pragma mark - 登录
- (void)login
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"UserName": self.userName,
                                 @"Password": self.userPWD
                                 };
    NSString *url = [NSString stringWithFormat:@"%@systemset/account/login",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
//         NSLog(@"%@",responseObject[@"code"]);
         [self.logins removeAllObjects];
         NSString *str = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
         self.userCode = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"userCode"]];
         if ([str isEqualToString:@"101"]) {
             // 密码错误
             [SVProgressHUD showErrorWithStatus:@"账号或密码错误"];
             [self performSelector:@selector(dismiss) withObject:nil afterDelay:1];
         }
         else if ([str isEqualToString:@"0"])
         {
             code = responseObject[@"data"][@"Code"];
             ProjectModel *model = [ProjectModel mj_objectWithKeyValues:responseObject[@"data"]];
             if (self.logins.count == 0) {
                 self.logins = [[NSMutableArray alloc] initWithCapacity:0];
             }
             [self.logins addObject:model];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"login" object:responseObject[@"code"]];
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
         if (error.code == -1009)
         {
             [SVProgressHUD showErrorWithStatus:@"网络异常"];
             [self performSelector:@selector(dismiss) withObject:nil afterDelay:1];
         }
         else if (error.code == -1001)
         {
             [SVProgressHUD showErrorWithStatus:@"连接超时"];
             [self performSelector:@selector(dismiss) withObject:nil afterDelay:1];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:@"服务异常"];
             [self performSelector:@selector(dismiss) withObject:nil afterDelay:1];
         }
     }];
}
#pragma mark - 轮播广告
- (void)getadvertiselist
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 };
    NSString *url = [NSString stringWithFormat:@"%@systemset/getadvertiselist",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         [self.ads removeAllObjects];
         NSArray *datas = responseObject[@"data"];
         for (NSDictionary *dic in datas)
         {
             if (self.ads.count == 0)
             {
                 self.ads = [[NSMutableArray alloc] initWithCapacity:0];
             }
             [self.ads addObject: dic[@"Photo"]];
         }
         [[NSNotificationCenter defaultCenter] postNotificationName:@"getadvertiselist" object:responseObject];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
     }];
}
#pragma mark - 公告
- (void)systemsetGetnoticepagelist
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 };
    NSString *url = [NSString stringWithFormat:@"%@systemset/getnoticepagelist",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         [self.getnoticepagelist removeAllObjects];
         NSArray *datas = responseObject[@"data"][@"DataList"];
         for (NSDictionary *dic in datas)
         {
             GetnoticepagelistModel *model = [[GetnoticepagelistModel alloc] init];
             model.NewsTitle = dic[@"NewsTitle"];
             model.NewsContent = dic[@"NewsContent"];
             model.ComfirmDate = dic[@"ComfirmDate"];
             if (self.getnoticepagelist.count == 0)
             {
                 self.getnoticepagelist = [[NSMutableArray alloc] initWithCapacity:0];
             }
             [self.getnoticepagelist addObject: model];
         }
         [[NSNotificationCenter defaultCenter] postNotificationName:@"getnoticepagelist" object:responseObject];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
     }];
}
#pragma mark - 项目列表
// sType:(0:我的项目，1:公海沲项目)
- (void)Getprojectpagelist
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 @"sType": self.sType,
                                 };
    NSString *url = [NSString stringWithFormat:@"%@projects/getprojectpagelist",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         [self.getprojectpagelist removeAllObjects];
         NSArray *datas = responseObject[@"data"][@"DataList"];
         for (NSDictionary *dic in datas)
         {
             GetprojectpagelistModel *model = [[GetprojectpagelistModel alloc] init];
             model.ID = dic[@"NewsTitle"];
             model.ProjectNo = dic[@"ProjectNo"];
             model.ProjectName = dic[@"ProjectName"];
             model.CreateDate = dic[@"CreateDate"];
             model.Creator = dic[@"Creator"];
             model.CustID = dic[@"CustID"];
             model.CustLinkMan = dic[@"CustLinkMan"];
             model.LinkTel = dic[@"LinkTel"];
             model.SuccessRate = dic[@"SuccessRate"];
             if (self.getprojectpagelist.count == 0)
             {
                 self.getprojectpagelist = [[NSMutableArray alloc] initWithCapacity:0];
             }
             [self.getprojectpagelist addObject: model];
         }
         [[NSNotificationCenter defaultCenter] postNotificationName:@"getprojectpagelist" object:responseObject];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
     }];
}
#pragma mark - 更改个人信息
- (void)AccountUpdate:(NSArray *)userInfo
{
    [SVProgressHUD showWithStatus:@"正在修改"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 @"Mobile":userInfo[0],
                                 @"NickName":userInfo[1]
                                 };
    NSString *url = [NSString stringWithFormat:@"%@systemset/account/update",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject);
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
     }];
}
#pragma mark - 更改个人头像
- (void)Uploadphoto:(NSString *)photoData
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 @"PothoData":photoData,
                                 };
    NSString *url = [NSString stringWithFormat:@"%@systemset/account/uploadphoto",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject);
         [SVProgressHUD dismiss];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"update" object:responseObject];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
     }];
}
#pragma mark - 签到
- (void)Custcontactsave:(NSArray *)custcontactsaves
{
    // Contents：内容；CustID：客户ID，CustLinkMan：客户联系人，-Linker：我方联系人-，LinkDate：联系日期，        -LinkReasonID：我方联系人-，Title：标题
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
//                                 @"ID": 1,
//                                 @"CompanyCD": "sample string 2",
                                 @"CustID": custcontactsaves[0],
                                 @"CustLinkMan": custcontactsaves[1],
//                                 @"ContactNo": "sample string 3",
                                 @"Title": custcontactsaves[2],
//                                 @"LinkReasonID": 1,
//                                 @"LinkMode": 1,
                                 @"LinkDate": [self getData],
//                                 @"Linker": 1,
                                 @"Contents":custcontactsaves[3],
//                                 @"ModifiedDate": "sample string 7",
//                                 @"ModifiedUserID": "sample string 8",
//                                 @"CanViewUser": "sample string 9",
//                                 @"CanViewUserName": "sample string 10",
//                                 @"LinkTel": "sample string 11",
                                 @"Lat": custcontactsaves[4],
                                 @"Lon": custcontactsaves[5],
//                                 @"LocationAddress": "sample string 14"
                                 };
    NSString *url = [NSString stringWithFormat:@"%@crm/custcontact/custcontactsave",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"custcontactsave" object:responseObject];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
     }];
}

#pragma mark - 获取客户列表
- (void)Getminecustpagelist
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 };
    NSString *url = [NSString stringWithFormat:@"%@crm/getminecustpagelist",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
//         NSLog(@"%@",responseObject);
         [self.getminecustpagelist removeAllObjects];
         NSArray *datas = responseObject[@"data"][@"DataList"];
         for (NSDictionary *dic in datas)
         {
             CustpagelistModel *model = [[CustpagelistModel alloc] init];
             model.CustNo = dic[@"CustNo"];
             model.CustName = dic[@"CustName"];
             model.CustShort = dic[@"CustShort"];
             model.ID = dic[@"ID"];
 
             if (self.getminecustpagelist.count == 0)
             {
                 self.getminecustpagelist = [[NSMutableArray alloc] initWithCapacity:0];
             }
             [self.getminecustpagelist addObject: model];
         }
         [[NSNotificationCenter defaultCenter] postNotificationName:@"getminecustpagelist" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
     }];
}
#pragma mark - 获取客户联系人列表
- (void)Getcustlinkmanlist:(NSString *)custlinkID
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 @"Id": custlinkID
                                 };
    NSString *url = [NSString stringWithFormat:@"%@crm/getcustlinkmanlist",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         //         NSLog(@"%@",responseObject);
         [self.getcustlinkmanlist removeAllObjects];
         NSArray *datas = responseObject[@"data"];
         for (NSDictionary *dic in datas)
         {
             CustlinkmanlistModel *model = [[CustlinkmanlistModel alloc] init];
             model.ID = dic[@"ID"];
             model.CustNo = dic[@"CustNo"];
             model.CompanyCD = dic[@"CompanyCD"];
             model.ID = dic[@"ID"];
             model.LinkManName = dic[@"LinkManName"];
             model.Sex = dic[@"Sex"];
             model.Important = dic[@"Important"];
             if (self.getcustlinkmanlist.count == 0)
             {
                 self.getcustlinkmanlist = [[NSMutableArray alloc] initWithCapacity:0];
             }
             [self.getcustlinkmanlist addObject: model];
         }
         [[NSNotificationCenter defaultCenter] postNotificationName:@"getcustlinkmanlist" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
     }];
}

#pragma mark - 获取历史签到列表
- (void)Getcustcontactpagelist
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 };
    NSString *url = [NSString stringWithFormat:@"%@crm/custcontact/getcustcontactpagelist",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         //         NSLog(@"%@",responseObject);
         [self.getcustlinkmanlist removeAllObjects];
         NSArray *datas = responseObject[@"data"];
         for (NSDictionary *dic in datas)
         {
             CustlinkmanlistModel *model = [[CustlinkmanlistModel alloc] init];
             model.ID = dic[@"ID"];
             model.CustNo = dic[@"CustNo"];
             model.CompanyCD = dic[@"CompanyCD"];
             model.ID = dic[@"ID"];
             model.LinkManName = dic[@"LinkManName"];
             model.Sex = dic[@"Sex"];
             model.Important = dic[@"Important"];
             if (self.getcustlinkmanlist.count == 0)
             {
                 self.getcustlinkmanlist = [[NSMutableArray alloc] initWithCapacity:0];
             }
             [self.getcustlinkmanlist addObject: model];
         }
         [[NSNotificationCenter defaultCenter] postNotificationName:@"getcustcontactpagelist" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
     }];
}
- (NSString *)getData
{
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    
    NSLog(@"locationString:%@",locationString);
    return locationString;
}
- (void)dismiss
{
    [SVProgressHUD dismiss];
}
@end

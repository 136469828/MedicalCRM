//
//  NetManger.m
//  MedicalCRM
//
//  Created by admin on 16/7/15.
//  Copyright © 2016年 JCK. All rights reserved.
//@"Keyword": self.keywork,

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
#import "FuntionObj.h"
#import "FriendListModel.h"
#import "EquipmentListModel.h"
#import "ProjectInfoModel.h"
#import "PublictypelistModel.h"
#import "GroupListModel.h"
#import "FeetypelistModel.h"
#import "PerformanceModel.h"
#import "EnterpriseModel.h"
#import "NewFriendInfoModel.h"
#import "DemoChiInfoModel.h"
#import "LifeNavigationListModel.h"
#import "AddMyPartnerModel.h"
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
    [SVProgressHUD showWithStatus:@"正在加载数据"];
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
        case RequestOfGetcustcontactpagelist:
        {
            [self Getcustcontactpagelist];
        }
            break;
        case RequestOfProjectsave:
        {
            [self Projectsave:self.projectsaves];
        }
            break;
        case RequestOfGetrongclouduserpagelist:
        {
            [self Getrongclouduserpagelist];
        }
            break;
        case RequestOfCustinfosave:
        {
            [self Custinfosave:self.custinfoinfo];
        }
            break;
        case RequestOfCustlinkmansave:
        {
            [self Custlinkmansave:self.custlinkmaninfo];
        }
            break;
        case RequestOfGetproductpagelist:
        {
            [self Getproductpagelist];
        }
            break;
        case RequestOfGetproject:
        {
            [self Getproject];
        }
            break;
        case RequestOfProjecttranspub:
        {
            [self Projecttranspub];
        }
            break;
        case RequestOfProjectpubtransmine:
        {
            [self Projectpubtransmine];
        }
            break;
        case RequestOfGetcodepublictypelist:
        {
            [self Getcodepublictypelist];
        }
            break;
        case RequestOfGetminediscussionlist:
        {
            [self Getminediscussionlist];
        }
            break;
        case RequestOfProjectconstructiondetailssave:
        {
            [self Projectconstructiondetailssave:self.projectProcess];
        }
            break;
        case RequestOfGetcodefeetypelist:
        {
            [self Getcodefeetypelist];
        }
            break;
        case RequestOfSeachrongclouduserpagelist:
        {
            [self Seachrongclouduserpagelist];
        }
            break;
        case RequestOfFeeapplysave:
        {
            [self Feeapplysave:self.feeapplyDetails Feeapplys:self.feeapplys];
        }
            break;
        case RequestOfGetmyachievement:
        {
            [self Getmyachievement];
        }
            break;
        case RequestOfGetfeeapplypagelist:
        {
            [self Getfeeapplypagelist];
        }
            break;
        case RequestOfSellsamplesave:
        {
            [self Sellsamplesave:self.demoMachidetails Sellasmples:self.demoMachiSaves];
        }
            break;
        case RequestOfGetsellsamplepagelist:
        {
            [self Getsellsamplepagelist];
        }
            break;
        case RequestOfPlanaimsave:
        {
            [self Planaimsave:self.planaimsaves];
        }
            break;
        case RequestOfGetplanaimpagelist:
        {
            [self Getplanaimpagelist];
        }
            break;
        case RequestOfPersonaladvicesendsave:
        {
            [self Personaladvicesendsave];
        }
            break;
        case RequestOfGetculturedocpagelist:
        {
            [self Getculturedocpagelist];
        }
            break;
        case RequestOfGetsellsample:
        {
            [self Getsellsample];
        }
            break;
        case GetsellsamplepagelistforcheckGetsellsample:
        {
            [self Getsellsamplepagelistforcheck];
        }
            break;
        case RequestOfFlowstepcheck:
        {
            [self Flowstepcheck];
        }
            break;
        case RequestOfGetpersonaladvicesendpagelist:
        {
            [self Getpersonaladvicesendpagelist];
        }
            break;
        case RequestOfGetMyprojectpagelist:
        {
            [self GetMyprojectpagelist];
        }
            break;
        case RequestOfGetcustinfo:
        {
            [self Getcustinfo];
        }
            break;
        case RequestOfReadsave:
        {
            [self Readsave];
        }
            break;
        case RequestOfGetpublicprojectpagelist:
        {
            [self Getpublicprojectpagelist];
        }
            break;
        case RequestOfGetculturetypes:
        {
            [self Getculturetypes];
        }
            break;
        case RequestOfGetjpushpagelist:
        {
            [self Getjpushpagelist];
        }
            break;
        case RequestOfGetuser:
        {
            [self Getuser];
        }
            break;
        case RequestOfGetdeptusers:
        {
            [self Getdeptusers];
        }
            break;
        case RequestOfGetminelinkmanpagelist:
        {
            [self Getminelinkmanpagelist];
        }
            break;
        case RequestOfGetsellexhibitionpagelist:
        {
            [self Getsellexhibitionpagelist];
        }
            break;
        case RequestOfGetsellexhibition:
        {
            [self Getsellexhibition];
        }
            break;
        case RequestOfSellexhibitionsave:
        {
            [self Sellexhibitionsave];
        }
            break;
        case RequestOfGetemployeeteampagelist:
        {
            [self Getemployeeteampagelist];
        }
            break;
        case RequestOfGetemployeeteam:
        {
            [self Getemployeeteam];
        }
            break;
        case RequestOfEmployeeteamsave:
        {
            [self Employeeteamsave:self.myTeamBulids TeamName:self.myTeamBulidName];
        }
            break;
        case RequestOfGetfeeapply:
        {
            [self Getfeeapply];
        }
            break;
        case RequestOfGetemployeenav:
        {
            [self Getemployeenav];
        }
            break;
        case RequestOfGetpersonaldatearrangepagelist:
        {
            [self Getpersonaldatearrangepagelist];
        }
            break;
        case RequestOfSaveemployeenav:
        {
            [self Saveemployeenav];
        }
            break;
        case RequestOfPersonaldatearrangesave:
        {
            [self Personaldatearrangesave];
        }
            break;
        case RequestOfGetachievementtotal:
        {
            [self Getachievementtotal];
        }
            break;
        case RequestOfGetfeeapplypagelistforcheck:
        {
            [self Getfeeapplypagelistforcheck];
        }
            break;
        case RequestOfSellordersave:
        {
            [self Sellordersave:self.detailss Saves:self.sellordersaves];
        }
            break;
        case RequestOfGetsellorderpagelistforcheck:
        {
            [self Getsellorderpagelistforcheck];
        }
            break;
        case RequestOfGetsellorder:
        {
            [self Getsellorder];
        }
            break;
        case RequestOfGetlinkman:
        {
            [self Getlinkman];
        }
            break;
        case RequestOfJpushreadsave:
        {
            [self Jpushreadsave];
        }
            break;
        case RequestOfGetnochecktotal:
        {
            [self Getnochecktotal];
        }
            break;
        case RequestOfGetnoreadtotal:
        {
            [self Getnoreadtotal];
        }
            break;
        case RequestOfPersonallinkmansave:
        {
            [self Personallinkmansave];
        }
            break;
        case RequestOfGetpersonallinkmanpagelist:
        {
            [self Getpersonallinkmanpagelist];
        }
            break;
        case RequestOfUpdatepassword:
        {
            [self Updatepassword];
        }
            break;
        case RequestOfCreatediscussion:
        {
            [self Creatediscussion];
        }
            break;
        case RequestOfGetminelinkmanpagelists:
        {
            [self Getminelinkmanpagelists];
        }
            break;
        case RequestOfPersonallinkmansavebatch:
        {
            [self Personallinkmansavebatch];
        }
            break;
         
        default:
            break;
    }
    
    NSLog(@"userCode:%@",self.userCode);
}
#pragma mark - 批量保存我的一伙人
- (void)Personallinkmansavebatch
{
    JCKLog(@"%@",self.personallinkmansavebatchs);
    NSString *detailstr = [self.personallinkmansavebatchs mj_JSONString];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 @"Id": detailstr
                                 };
    JCKLog(@"%@",parameters);
    NSString *url = [NSString stringWithFormat:@"%@office/employee/personallinkmansavebatch",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject);
         [SVProgressHUD dismiss];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"personallinkmansavebatch" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
     }];
}
#pragma mark - 获取客户列表（包含解析）
- (void)Getminelinkmanpagelists
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 @"Keyword": self.keywork,
                                 @"sType": @"0",
                                 @"PageIndex": @"1",
                                 @"PageSize": _PageSize
                                 };
    JCKLog(@"%@",parameters);
    NSString *url = [NSString stringWithFormat:@"%@crm/getminelinkmanpagelist",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject);
         [SVProgressHUD dismiss];
         [_getminelinkmanpagelists removeAllObjects];
         NSArray *datas = responseObject[@"data"][@"DataList"];
         for (NSDictionary *dic in datas)
         {
             AddMyPartnerModel *model = [[AddMyPartnerModel alloc] init];
             if ([FuntionObj isNullDic:dic Key:@"LinkManName"]) {
                 model.LinkManName = dic[@"LinkManName"];
             }
             else
             {
                 model.LinkManName = dic[@""];
             }
             if ([FuntionObj isNullDic:dic Key:@"Department"]) {
                 model.Department = dic[@"Department"];
             }
             else
             {
                 model.Department = dic[@""];
             }
             model.ID = dic[@"ID"];
             if ([FuntionObj isNullDic:dic Key:@"Position"]) {
                 model.Position = dic[@"Position"];
             }
             else
             {
                 model.Position = dic[@""];
             }
             if ([FuntionObj isNullDic:dic Key:@"WorkTel"]) {
                 model.WorkTel = dic[@"WorkTel"];
             }
             else
             {
                 model.WorkTel = dic[@""];
             }
             if ([FuntionObj isNullDic:dic Key:@"CustName"]) {
                 model.CustName = dic[@"CustName"];
             }
             else
             {
                 model.CustName = dic[@""];
             }
             if ([FuntionObj isNullDic:dic Key:@"Operation"]) {
                 model.Operation = dic[@"Operation"];
             }
             else
             {
                 model.Operation = dic[@""];
             }
             if (!_getminelinkmanpagelists) {
                 _getminelinkmanpagelists = [NSMutableArray array];
             }
             [_getminelinkmanpagelists addObject:model];

         }
         [[NSNotificationCenter defaultCenter] postNotificationName:@"getminelinkmanpagelist" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
          [SVProgressHUD dismiss];
     }];

}
#pragma mark - 创建群组
- (void)Creatediscussion
{
//    NSArray *Detailss =  @[@{
//                                @"PhotoURL": _creatediscussionsDetails[0],
//                                @"EmployeeName": _creatediscussionsDetails[1],
//                                @"ID": _creatediscussionsDetails[2],
//                                @"UserID": _creatediscussionsDetails[3],
//                               }
//                           ];
//    NSString *detailstr = [Detailss mj_JSONString];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 @"IsRongRelease": @"1",
                                 @"userstrs": _creatediscussions[0],
                                 @"discussionId": _creatediscussions[1],
                                 @"discussionName": _creatediscussions[2],
                                 };
    JCKLog(@"%@",parameters);
    NSString *url = [NSString stringWithFormat:@"%@common/rongcloud/creatediscussion",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject);
         [SVProgressHUD dismiss];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"creatediscussion" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
     }];
}
#pragma mark - 修改密码
- (void)Updatepassword
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 @"OldPassword": self.oldPword,
                                 @"NewPassword": self.passwordOfnew
                                 };
    NSString *url = [NSString stringWithFormat:@"%@systemset/account/updatepassword",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"updatepassword" object:responseObject];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
         [SVProgressHUD showErrorWithStatus:@"修改失败"];
     }];
}
#pragma mark - 我的团队--查询我的联系人列表
- (void)Getpersonallinkmanpagelist
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 @"sType2": _sType2,
                                 @"sType": _sType,
                                 };
    NSString *url = [NSString stringWithFormat:@"%@office/employee/getpersonallinkmanpagelist",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject);
         [SVProgressHUD dismiss];
         NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
         if ([code isEqualToString:@"0"])
         {
             NSArray *datas = responseObject[@"data"][@"DataList"];
             if (datas) {
                 _getpersonallinkmanpagelists = datas;
             }
             [[NSNotificationCenter defaultCenter] postNotificationName:@"getpersonallinkmanpagelist" object:nil];
         }

         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
     }];
}
#pragma mark - 保存我的团队中--我的联系人
// CompanyName:公司名；CompanyPhone：公司电话；Email：邮箱；LinkmanName：联系人名；MobilePhone：联系人电话；Sex:性别（1:男；2：女）
- (void)Personallinkmansave
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 @"LinkmanName": _personallinkmansaves[0],
                                 @"Sex": _personallinkmansaves[1],
                                 @"CompanyName": _personallinkmansaves[2],
                                 @"MobilePhone": _personallinkmansaves[3],
                                 @"CompanyPhone": _personallinkmansaves[4],
                                 @"Email": _personallinkmansaves[5],
                                 @"Position":_personallinkmansaves[6]
                                };
    JCKLog(@"%@",parameters);
    NSString *url = [NSString stringWithFormat:@"%@office/employee/personallinkmansave",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject);
         [SVProgressHUD dismiss];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"personallinkmansave" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
     }];
}
#pragma mark - 获取所有审核分类及其未审核统计情况
- (void)Getnochecktotal
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                
                                 };
    NSString *url = [NSString stringWithFormat:@"%@common/mpublic/getnochecktotal",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject);
         _NoCheckTotalCount = responseObject[@"data"][@"NoCheckTotalCount"];
         [SVProgressHUD dismiss];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"getnochecktotal" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
     }];
}
#pragma mark - 标题推送消息为已读
- (void)Jpushreadsave
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 @"Id" :self.ID
                                 };
    NSString *url = [NSString stringWithFormat:@"%@common/mpublic/jpushreadsave",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject);
         [SVProgressHUD dismiss];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"jpushreadsave" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
     }];
}
#pragma mark - 获取我的备货申请单列表
- (void)Getsellorderpagelist
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 
                                 };
    NSString *url = [NSString stringWithFormat:@"%@order/getsellorderpagelist",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject);
         [SVProgressHUD dismiss];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"getsellorderpagelist" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
     }];
}
#pragma mark - 单个客户详情
- (void)Getlinkman
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 @"Id": self.ID
                                 };
    NSString *url = [NSString stringWithFormat:@"%@crm/getlinkman",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject);
         [SVProgressHUD dismiss];
         NSArray *datas = responseObject[@"data"];
         if (datas) {
             _getlinkmans = datas;
         }
         [[NSNotificationCenter defaultCenter] postNotificationName:@"getlinkman" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
     }];
}
#pragma mark - 获取待审核的备货单（供审核备货单使用）
- (void)Getsellorderpagelistforcheck
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.otherUserCode,
                                 @"sType": self.sType,
                                 @"Keyword": self.keywork,
                                 @"PageIndex": @"1",
                                 @"PageSize": _PageSize
                                 };
    NSString *url = [NSString stringWithFormat:@"%@order/getsellorderpagelistforcheck",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject);

         NSArray *datas = responseObject[@"data"][@"DataList"];
         _sellorderpagelistforcheck = nil;
         if (datas)
         {
             _sellorderpagelistforcheck = datas;
         }
         [[NSNotificationCenter defaultCenter] postNotificationName:@"getsellorderpagelistforcheck" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
     }];
}
#pragma mark - 获取备货单详情
- (void)Getsellorder
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.otherUserCode,
                                 @"Id": self.ID
                                 };
    NSString *url = [NSString stringWithFormat:@"%@order/getsellorder",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject);
         [SVProgressHUD dismiss];
         NSArray *datas = responseObject[@"data"];
         if (datas)
         {
             _getsellorders = datas;
         }
         [[NSNotificationCenter defaultCenter] postNotificationName:@"getsellorder" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
     }];
}
#pragma mark - 备货申请单（只传备注列表的属性值即可）
- (void)Sellordersave:(NSArray *)Details Saves:(NSArray *)sellordersaves
{
    NSArray *Detailss =  @[@{
                              @"ProductID": Details[0],
                              @"ProductCount": Details[1],
                              }
                          ];
    NSString *detailstr = [Detailss mj_JSONString];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 @"EndDateStr": @"",
                                 @"StartDateStr": @"",
                                 @"Title": sellordersaves[0],
                                 @"FromType": sellordersaves[1],
                                 @"FromBillID":sellordersaves[2],
                                 @"DetailStr" : detailstr
                                 };
    JCKLog(@"%@",parameters);
    NSString *url = [NSString stringWithFormat:@"%@order/sellordersave",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject);
         [SVProgressHUD dismiss];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"sellordersave" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
     }];
}
#pragma mark - 获取待审核的费用申请列表
- (void)Getfeeapplypagelistforcheck
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.otherUserCode,
                                 @"sType": self.sType,
                                 @"PageIndex": @"1",
                                 @"PageSize": @"10"
                                 };
    NSString *url = [NSString stringWithFormat:@"%@office/office/getfeeapplypagelistforcheck",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject);
         NSArray *datas = responseObject[@"data"][@"DataList"];
         _getfeeapplypagelistforchecks = nil;
         if (datas) {
             _getfeeapplypagelistforchecks = datas;
             [[NSNotificationCenter defaultCenter] postNotificationName:@"getfeeapplypagelistforcheck" object:nil];
             [SVProgressHUD dismiss];
         }

     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
     }];
}
#pragma mark - 业绩统计报表
- (void)Getachievementtotal
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.otherUserCode,
                                 
                                 };
    NSString *url = [NSString stringWithFormat:@"%@common/mpublic/getachievementtotal",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject);
         [SVProgressHUD dismiss];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"getachievementtotal" object:responseObject];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
     }];
}
#pragma mark - 保存重要事项
- (void)Personaldatearrangesave
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 @"ArrangeTItle":self.title,
                                 @"Content":self.context,
                                 @"CanViewUser":self.canViewUsers
                                 };
    NSString *url = [NSString stringWithFormat:@"%@office/office/personaldatearrangesave",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject);
         [SVProgressHUD dismiss];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"personaldatearrangesave" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
     }];
}
#pragma mark - 保存我的人生导航
- (void)Saveemployeenav
{
    LifeNavigationListModel *model = [LifeNavigationListModel shareInstance];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
//                                 "ID": 1,
//                                 "YearNav": "sample string 2",
//                                 "EmployeeID": 3,
                                 @"TotalMineMoneyByYear": model.TotalMineMoneyByYear,
                                 @"TotalMineMoneyByFuture": model.TotalMineMoneyByFuture,
                                 @"TeamCountByYear": model.TeamCountByYear,
                                 @"TeamCountByFuture": model.TeamCountByFuture,
                                 @"VisitCountByDay": model.VisitCountByDay,
                                 @"VisitCountByYear": model.VisitCountByYear,
                                 @"CustomCountByYear": model.CustomCountByYear,
                                 @"ProjectCountByYear": model.ProjectCountByYear,
                                 @"ProjectMoneyByYear": model.ProjectMoneyByYear,
                                 @"SaleMoneyByYear": model.SaleMoneyByYear,
                                 };
    JCKLog(@"%@",parameters);
    NSString *url = [NSString stringWithFormat:@"%@office/employee/saveemployeenav",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject);
         [SVProgressHUD dismiss];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"saveemployeenav" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
          [SVProgressHUD dismiss];
     }];
}
#pragma mark - 获取重要事项分布列表
- (void)Getpersonaldatearrangepagelist
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 
                                 };
    NSString *url = [NSString stringWithFormat:@"%@office/office/getpersonaldatearrangepagelist",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
//         NSLog(@"%@",responseObject);
         NSArray *datas = responseObject[@"data"][@"DataList"];
         if (datas)
         {
             _importantItemsLisr = datas;
         }
         [SVProgressHUD dismiss];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"getpersonaldatearrangepagelist" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
          [SVProgressHUD dismiss];
     }];
}
#pragma mark - 获取我的人生导航
- (void)Getemployeenav
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 
                                 };
    NSString *url = [NSString stringWithFormat:@"%@office/employee/getemployeenav",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject);
         [SVProgressHUD dismiss];
         NSDictionary *dic = responseObject;
         _lifeDic = nil;
         if (dic) {
             _lifeDic = dic;
         }
         [[NSNotificationCenter defaultCenter] postNotificationName:@"getemployeenav" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
          [SVProgressHUD dismiss];
     }];
}
#pragma mark - 获取费用申请详情
- (void)Getfeeapply
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 @"Id": self.ID
                                 };
    NSString *url = [NSString stringWithFormat:@"%@office/office/getfeeapply",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
//         NSLog(@"%@",responseObject);
         NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
         if ([code isEqualToString:@"0"])
         {
             [SVProgressHUD dismiss];
             _myPayInfos = nil;
             NSDictionary *data = responseObject[@"data"];
             if (data) {
                 _myPayInfos = data;
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"getfeeapply" object:nil];
             }
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
             UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"提示" message:responseObject[@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
             [al show];
         }
         
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
          [SVProgressHUD dismiss];
     }];
}
#pragma mark - 保存团队
- (void)Employeeteamsave:(NSArray *)Employees TeamName:(NSString *)teamName
{
    NSString *Employee=[Employees componentsJoinedByString:@","];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 @"TeamName": teamName,
                                 @"Employees": Employee,
//                                 "EmployeeNames": "sample string 10",
                                 };
    JCKLog(@"%@",parameters);
    NSString *url = [NSString stringWithFormat:@"%@office/employee/employeeteamsave",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject);
         [SVProgressHUD dismiss];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"employeeteamsave" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
          [SVProgressHUD dismiss];
     }];
}
#pragma mark - 获取团队详情
- (void)Getemployeeteam
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 @"Id": self.ID
                                 };
    NSString *url = [NSString stringWithFormat:@"%@office/employee/getemployeeteam",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject);
         [SVProgressHUD dismiss];
         _myTeamInfos = nil;
         NSArray *datas = responseObject[@"data"][@"users"];
         if (datas) {
             _myTeamInfos = datas;
         }

         [[NSNotificationCenter defaultCenter] postNotificationName:@"getemployeeteam" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
          [SVProgressHUD dismiss];
     }];
}
#pragma mark - 获取我的团队列表
- (void)Getemployeeteampagelist
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 };
    NSString *url = [NSString stringWithFormat:@"%@office/employee/getemployeeteampagelist",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject);
         [SVProgressHUD dismiss];
         _myTeamList = nil;
         NSArray *datas = responseObject[@"data"];
         if (datas) {
             _myTeamList = datas;
         }
         [[NSNotificationCenter defaultCenter] postNotificationName:@"getemployeeteampagelist" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
          [SVProgressHUD dismiss];
     }];
}
#pragma mark - 展会申请单保存
- (void)Sellexhibitionsave
{
  /*
   "ID": 1,
   "CompanyCD": "sample string 2",
   "ExhibitionNo": "sample string 3",
   "ExhibitionNature": 1,
   "LinkManName": "sample string 4",
   "LinkTel": "sample string 5",
   "Title": "sample string 6",
   "AttendPersons": 1,
   "TotalMoney": 1.0,
   "ExhibitionStartDate": "sample string 7",
   "ExhibitionEndDate": "sample string 8",
   "ExhibitionPlan": "sample string 9",
   "ExhibitionAim": "sample string 10",
   "UnionPartner": "sample string 11",
   "PlanFee": 1.0,
   "Competitors": "sample string 12",
   "Address": "sample string 13",
   "Creator": 1,
   "CreateDate": "sample string 14",
   "Confirmor": 1,
   "ConfirmDate": "sample string 15",
   "ModifiedDate": "sample string 16",
   "ModifiedUserID": "sample string 17",
   "CanViewUser": "sample string 18",
   "BillStatus": 1,
   "Details": [
   {
   "ID": 1,
   "CompanyCD": "sample string 2",
   "ExhibitionNo": "sample string 3",
   "ProductID": 1,
   "ProductCount": 1.0,
   "UnitID": 1,
   "TotalFee": 1.0,
   "Remark": "sample string 4",
   "ModifiedDate": "2016-08-11 23:08:08",
   "ModifiedUserID": "sample string 5",
   "UsedPrice": 1.0,
   "ExhibitionId": 6
   }
   */
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSArray *Details = @[@{@"ID":self.zhanhuiSave[13],@"ProductCount":@"1"}];
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
//                                 @"CompanyCD": self.zhanhuiSave[0],
//                                 @"ExhibitionNo": self.zhanhuiSave[1],
//                                 @"ExhibitionNature": self.zhanhuiSave[2],
                                 
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
                                 
//                                 "Creator": 1,
//                                 "CreateDate": "sample string 14",
//                                 "Confirmor": 1,
//                                 "ConfirmDate": "sample string 15",
//                                 "ModifiedDate": "sample string 16",
//                                 "ModifiedUserID": "sample string 17",
//                                 "CanViewUser": "sample string 18",
//                                 "BillStatus": 1,
                                 };
    JCKLog(@"%@",parameters);
    NSString *url = [NSString stringWithFormat:@"%@order/sellexhibitionsave",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject);
         [SVProgressHUD dismiss];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"sellexhibitionsave" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
          [SVProgressHUD dismiss];
     }];
}
#pragma mark - 登录
- (void)login
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"UserName": self.userName,
                                 @"Password": self.userPWD,
                                 @"IsRongRelease": @"1"
                                 };
    NSString *url = [NSString stringWithFormat:@"%@systemset/account/login",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
//         NSLog(@"%@",responseObject[@"code"]);
         [self.logins removeAllObjects];
         NSString *str = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
         if ([str isEqualToString:@"101"]) {
             // 密码错误
             [SVProgressHUD showErrorWithStatus:@"账号或密码错误"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"errorlogin" object:nil];
             [self performSelector:@selector(dismiss) withObject:nil afterDelay:1];
         }
         else if ([str isEqualToString:@"0"])
         {
            self.rongcloudToken = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"rongcloudToken"]];
            self.userCode = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"userCode"]];
            self.otherUserCode = self.userCode;
            self.DeptName = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"DeptName"]];
            self.pushID = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"UserID"]];
             code = responseObject[@"data"][@"Code"];
             self.userNewPhoto = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"PhotoURL"]];
             code = responseObject[@"data"][@"Code"];
             self.userID = responseObject[@"data"][@"UserID"];
             self.userOtherID = self.userID;
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
             [[NSNotificationCenter defaultCenter] postNotificationName:@"errorlogin" object:nil];
             [self performSelector:@selector(dismiss) withObject:nil afterDelay:1];
         }
         else if (error.code == -1001)
         {
             [SVProgressHUD showErrorWithStatus:@"连接超时"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"errorlogin" object:nil];
             [self performSelector:@selector(dismiss) withObject:nil afterDelay:1];
         }
         else
         {
              [SVProgressHUD dismiss];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"errorlogin" object:nil];
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
         [SVProgressHUD dismiss];
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
         [SVProgressHUD dismiss];
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
                                 @"Keyword": self.keywork,
                                 @"PageIndex": @"1",
                                 @"PageSize": @"99"
                                 };
    NSString *url = [NSString stringWithFormat:@"%@systemset/getnoticepagelist",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
                  [SVProgressHUD dismiss];
         [self.getnoticepagelist removeAllObjects];
         NSArray *datas = responseObject[@"data"][@"DataList"];
         for (NSDictionary *dic in datas)
         {
             GetnoticepagelistModel *model = [[GetnoticepagelistModel alloc] init];
             model.NewsTitle = dic[@"NewsTitle"];
             model.NewsContent = dic[@"NewsContent"];
             model.ComfirmDate = dic[@"ComfirmDate"];
             model.ID = dic[@"ID"];
             model.isRead = [NSString stringWithFormat:@"%@",dic[@"IsRead"] ];
             model.ReadCount = [NSString stringWithFormat:@"%@",dic[@"ReadCount"]];
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
         [SVProgressHUD dismiss];
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
                                 @"_code": self.otherUserCode,
                                 @"sType": self.sType,
                                 @"sType3": self.sType3,
                                 @"Keyword": self.keywork,
                                 @"PageIndex": @"1",
                                 @"PageSize": self.PageSize
                                 };
    NSString *url = [NSString stringWithFormat:@"%@projects/getprojectpagelist",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
            [SVProgressHUD dismiss];
         [self.getprojectpagelist removeAllObjects];
         NSArray *datas = responseObject[@"data"][@"DataList"];
         for (NSDictionary *dic in datas)
         {
             GetprojectpagelistModel *model = [[GetprojectpagelistModel alloc] init];
             model.ID = dic[@"ID"];
             model.ProjectNo = dic[@"ProjectNo"];
             model.ProjectName = dic[@"ProjectName"];
             model.CreateDate = dic[@"CreateDate"];
             model.Creator = dic[@"Creator"];
             model.CustID = dic[@"CustID"];
             model.CustLinkMan = dic[@"CustLinkMan"];
             model.LinkTel = dic[@"LinkTel"];
//             model.SuccessRate = dic[@"SuccessRate"];
             model.CreatorName = dic[@"CreatorName"];
             model.StatusName = dic[@"StatusName"];
             model.CustName = dic[@"CustName"];
             model.AcceptMoney = [NSString stringWithFormat:@"%@",dic[@"AcceptMoney"]];
             if ([FuntionObj isNullDic:dic Key:@"DepartmentName"])
             {
                model.DepartmentName = dic[@"DepartmentName"];
             }
             else
             {
                model.DepartmentName = @"";
             }
             if ([FuntionObj isNullDic:dic Key:@"SuccessRate"])
             {
                 model.SuccessRate = [NSString stringWithFormat:@"%@",dic[@"SuccessRate"]];
                 model.SuccessRateNum = [NSString stringWithFormat:@"%@",dic[@"SuccessRate"]];
                 model.SuccessRate = [NSString stringWithFormat:@"%.0f%%",[model.SuccessRate floatValue]*100];
             }
             else
             {
                 model.SuccessRate = @"";
             }
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
         [SVProgressHUD dismiss];
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
                                 @"Mobile":userInfo[1],
                                 @"NickName":userInfo[0]
                                 };
    JCKLog(@"%@",parameters);
    NSString *url = [NSString stringWithFormat:@"%@systemset/account/update",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject);
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
              [SVProgressHUD dismiss];
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
        [SVProgressHUD dismiss];
         NSLog(@"%@",responseObject[@"data"][@"PhotoURL"]);
         self.userNewPhoto = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"PhotoURL"]];
         [SVProgressHUD dismiss];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"update" object:responseObject];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
                       [SVProgressHUD dismiss];
     }];
}
#pragma mark - 签到
- (void)Custcontactsave:(NSArray *)custcontactsaves
{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
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
                                 
                                 };
    JCKLog(@"%@",parameters);
    NSString *url = [NSString stringWithFormat:@"%@crm/custcontact/custcontactsave",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
        [SVProgressHUD dismiss];
         NSLog(@"%@",responseObject);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"custcontactsave" object:responseObject];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
                       [SVProgressHUD dismiss];
     }];
}
// 解析过慢
#pragma mark - 获取客户列表
- (void)Getminecustpagelist
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 10;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 @"Keyword":self.keywork,
                                 @"sType" :self.sType,
                                 @"PageIndex": @"1",
                                 @"PageSize": self.PageSize
                                 };
    NSString *url = [NSString stringWithFormat:@"%@crm/getminecustpagelist",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
                  [SVProgressHUD dismiss];
//         NSLog(@"%@",responseObject);
         [self.getminecustpagelist removeAllObjects];
         [self.getminecustpagelistLinMans removeAllObjects];
         [self.getminecustpagelistProjects removeAllObjects];
         NSArray *datas = responseObject[@"data"][@"DataList"];
         for (NSDictionary *dic in datas)
         {
             CustpagelistModel *model = [CustpagelistModel mj_objectWithKeyValues:dic];

             if (!_getminecustpagelistLinMans) {
                 _getminecustpagelistLinMans = [NSMutableArray array];
             }
             if (!_getminecustpagelistProjects) {
                 _getminecustpagelistProjects = [NSMutableArray array];
             }
             model.ProjectsLinMans = dic[@"LinMans"];
             
             model.ProjectsProject = dic[@"Projects"];
//             for (NSDictionary *dic in _getminecustpagelistProjects)
//             {
//                 JCKLog(@"%@",[NSString stringWithFormat:@"%@",dic[@"ProjectName"]]);
//             }
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
                       [SVProgressHUD dismiss];
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
                                 @"Id": custlinkID,
                                 @"PageIndex": @"1",
                                 @"PageSize": @"99"
                                 };
    NSString *url = [NSString stringWithFormat:@"%@crm/getcustlinkmanlist",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
                  [SVProgressHUD dismiss];
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
             model.WorkTel = dic[@"WorkTel"];
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
         [SVProgressHUD dismiss];
     }];
}

#pragma mark - 获取历史签到列表
- (void)Getcustcontactpagelist
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.otherUserCode,
                                 @"PageIndex": @"1",
                                 @"PageSize": _PageSize,
                                 @"Keyword": self.keywork,
                                 };
    JCKLog(@"%@",parameters);
    NSString *url = [NSString stringWithFormat:@"%@crm/custcontact/getcustcontactpagelist",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
                  [SVProgressHUD dismiss];
                  NSLog(@"%@",responseObject);
         
         NSString *codestr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
         if ([codestr isEqualToString:@"0"]) {
             [self.getcustcontactpagelist removeAllObjects];
             NSArray *datas = responseObject[@"data"][@"DataList"];
             
             for (NSDictionary *dic in datas)
             {
                 CustcontactpagelistModel *model = [CustcontactpagelistModel mj_objectWithKeyValues:dic];
                 if (self.getcustcontactpagelist.count == 0)
                 {
                     self.getcustcontactpagelist = [[NSMutableArray alloc] initWithCapacity:0];
                 }
                 [self.getcustcontactpagelist addObject: model];
             }
             [[NSNotificationCenter defaultCenter] postNotificationName:@"getcustcontactpagelist" object:nil];
         }
         else
         {
             UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"提示" message:responseObject[@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
             [al show];
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
                       [SVProgressHUD dismiss];
     }];
}

#pragma mark - 获取融云好友列表
- (void)Getrongclouduserpagelist
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 @"sType":@"1",
                                 @"Keyword" :self.keywork,
                                 @"PageIndex": @"1",
                                 @"PageSize": @"500"
                                 };
    NSString *url = [NSString stringWithFormat:@"%@common/user/getrongclouduserpagelist",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
        [SVProgressHUD dismiss];
         NSLog(@"%@",responseObject);
         [self.clouduserpagelist removeAllObjects];
         NSArray *datas = responseObject[@"data"][@"DataList"];
         _theNewFriendLists = nil;
         if (datas)
         {
             _theNewFriendLists = datas;
         }
         for (NSDictionary *dic in datas)
         {
             FriendListModel *model = [[FriendListModel alloc] init];
             model.UserID = [NSString stringWithFormat:@"%@",dic[@"UserID"]];
             model.EmployeeID = [NSString stringWithFormat:@"%@",dic[@"EmployeeID"]];
             if ([FuntionObj isNullDic:dic Key:@"EmployeeName"])
             {
                 model.EmployeeName = dic[@"EmployeeName"];
             }
             else
             {
                 model.EmployeeName = @"无";
             }
             if ([FuntionObj isNullDic:dic Key:@"DeptName"])
             {
                 model.DeptName = dic[@"DeptName"];
             }
             else
             {
                 model.DeptName = @"无";
             }
             if ([FuntionObj isNullDic:dic Key:@"PhotoURL"])
             {
                 model.PhotoURL = dic[@"PhotoURL"];
             }
             else
             {
                 model.PhotoURL = @"";
             }
             if (self.clouduserpagelist.count == 0)
             {
                 self.clouduserpagelist = [[NSMutableArray alloc] initWithCapacity:0];
             }
             [self.clouduserpagelist addObject: model];
         }
         [[NSNotificationCenter defaultCenter] postNotificationName:@"getrongclouduserpagelist" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
         [SVProgressHUD dismiss];
     }];
}
#pragma mark - 搜索融云好友列表
- (void)Seachrongclouduserpagelist
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 @"sType":@"1",
                                 @"Keyword":self.keywork,
                                 @"PageIndex": @"1",
                                 @"PageSize": @"99"
                                 };
    NSString *url = [NSString stringWithFormat:@"%@common/user/getrongclouduserpagelist",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         [SVProgressHUD dismiss];
         //         NSLog(@"%@",responseObject);
         [self.clouduserpagelist removeAllObjects];
         NSArray *datas = responseObject[@"data"][@"DataList"];
         
         for (NSDictionary *dic in datas)
         {
             FriendListModel *model = [[FriendListModel alloc] init];
             model.UserID = [NSString stringWithFormat:@"%@",dic[@"UserID"]];
             model.EmployeeName = dic[@"EmployeeName"];
             
             if ([FuntionObj isNullDic:dic Key:@"PhotoURL"])
             {
                 model.PhotoURL = dic[@"PhotoURL"];
             }
             else
             {
                 model.PhotoURL = @"";
             }
             if (self.clouduserpagelist.count == 0)
             {
                 self.clouduserpagelist = [[NSMutableArray alloc] initWithCapacity:0];
             }
             [self.clouduserpagelist addObject: model];
         }
         [[NSNotificationCenter defaultCenter] postNotificationName:@"getrongclouduserpagelist" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
          [SVProgressHUD dismiss];
     }];
}
#pragma mark - 项目申请
/*
 ProjectName：项目名称，
 Address：地址，
 Creator：员工Id，
 CustID：客户ID，
 StartDate：项目开始时间，
 EndDate：项目结束时间，
 CustLinkMan：客户联系人
 ，CustLinkTel：客户联系人电话
 Tel：我方联系人电话，
 Investment：项目总价，
 LinkMan：我方联系人Id
 ，Remark：备注，
 SuccessRate：成功率
 */
- (void)Projectsave:(NSArray *)projectsaves
{
    NSArray *Detailstrs = projectsaves[11];
    NSString *detailstr = [Detailstrs mj_JSONString];
    JCKLog(@"%@",detailstr);

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 @"ProjectName": projectsaves[0],
                                 @"Address": projectsaves[1],
                                 @"CustLinkMan": projectsaves[2],
                                 @"CustLinkTel": projectsaves[3],
                                 @"Investment":projectsaves[4],
                                 @"SuccessRate": projectsaves[5],
                                 @"Remark":projectsaves[6],
                                 @"ProjectDirectionId": projectsaves[7],
                                 @"CustLinkManId":projectsaves[8],
                                 @"CanViewUser": projectsaves[9],
                                 @"DatePlanDesc": projectsaves[10],
                                 @"Detailstr": detailstr
                                 };
    JCKLog(@"%@",parameters);
    NSString *url = [NSString stringWithFormat:@"%@projects/projectsave",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         [SVProgressHUD dismiss];
         JCKLog(@"%@",responseObject);
         _projcetID = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"ID"]];
         JCKLog(@"%@",_projcetID);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"projectsave" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
                       [SVProgressHUD dismiss];
     }];
}
#pragma mark - 保存客户资料
// ContactName:联系人；SellArea:经营范围；City：所在城市--填写即可
- (void)Custinfosave:(NSArray *)custininfos
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                
                                 @"CustName": custininfos[0],
                                 @"City": custininfos[1],
                                 @"Tel": custininfos[2],
                                 @"Mobile": custininfos[3],
                                 @"SellArea": custininfos[4],
                                 @"email": custininfos[5],
                                 @"Address": custininfos[6],
                                 @"Remark": custininfos[7],
//                                 @"ID": 1,
//                                 @"CustNo": "sample string 2",
//                                 @"CustName": custininfos[0],
//                                 @"CustShort": "sample string 4",
//                                 @"Province": "sample string 6",
                                 };
    JCKLog(@"%@",parameters);
    NSString *url = [NSString stringWithFormat:@"%@crm/custinfosave",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
                  [SVProgressHUD dismiss];
         NSLog(@"%@",responseObject);
         
         [[NSNotificationCenter defaultCenter] postNotificationName:@"custinfosave" object:responseObject];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
                       [SVProgressHUD dismiss];
     }];
}
#pragma mark - 保存客户联系人
// CustNo，LinkManName，Sex，Company，Department，Position，WorkTel，MailAddress，QQ，Age,MailAddress
- (void)Custlinkmansave:(NSArray *)custlinkmaninfos
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 
                                 @"CustNo"      : custlinkmaninfos[0],
                                 @"LinkManName" : custlinkmaninfos[1],
                                 @"Sex"         : custlinkmaninfos[2],
//                                 @"Company"     : custlinkmaninfos[3],
                                 @"Remark": custlinkmaninfos[3],
                                 @"Department"  : custlinkmaninfos[4],
                                 @"Position"    : custlinkmaninfos[5],
                                 @"WorkTel"     : custlinkmaninfos[6],
                                 @"MailAddress" : custlinkmaninfos[7],
                                 @"QQ"          : custlinkmaninfos[8],
                                 @"Age"         : custlinkmaninfos[9],
//                                 "ID": 1,
//                                 "CompanyCD": "sample string 3",
//
//
//                                 "Important": "sample string 6",
//
//                                 "Appellation": "sample string 8",
//
//
//                                 "Operation": "sample string 11",
//
//                                 "Fax": "sample string 13",
//                                 "Handset": "sample string 14",
//
//                                 "HomeTel": "sample string 16",
//                                 "MSN": "sample string 17",
//
//                                 "Post": "sample string 19",
//                                 "HomeAddress": "sample string 20",
//
//                                 "Likes": "sample string 23",
//                                 "LinkType": 1,
//                                 "Birthday": "2016-07-22 09:10:27",
//                                 "PaperType": "sample string 24",
//                                 "PaperNum": "sample string 25",
//                                 "Photo": "sample string 26",
//                                 "ModifiedDate": "2016-07-22 09:10:27",
//                                 "ModifiedUserID": "sample string 27",
//                                 "CanViewUser": "sample string 28",
//                                 "CanViewUserName": "sample string 29",
//                                 "Creator": 1,
//                                 "CreatedDate": "2016-07-22 09:10:27",
//                                 "HomeTown": "sample string 30",
//                                 "NationalID": 1,
//                                 "birthcity": "sample string 31",
//                                 "CultureLevel": 1,
//                                 "Professional": 1,
//                                 "GraduateSchool": "sample string 32",
//                                 "IncomeYear": "sample string 33",
//                                 "FuoodDrink": "sample string 34",
//                                 "LoveMusic": "sample string 35",
//                                 "LoveColor": "sample string 36",
//                                 "LoveSmoke": "sample string 37",
//                                 "LoveDrink": "sample string 38",
//                                 "LoveTea": "sample string 39",
//                                 "LoveBook": "sample string 40",
//                                 "LoveSport": "sample string 41",
//                                 "LoveClothes": "sample string 42",
//                                 "Cosmetic": "sample string 43",
//                                 "Nature": "sample string 44",
//                                 "Appearance": "sample string 45",
//                                 "AdoutBody": "sample string 46",
//                                 "AboutFamily": "sample string 47",
//                                 "Car": "sample string 48",
//                                 "LiveHouse": "sample string 49",
//                                 "ProfessionalDes": "sample string 50"
                                 };
    NSLog(@"%@",parameters);
    NSString *url = [NSString stringWithFormat:@"%@crm/custlinkmansave",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
                  [SVProgressHUD dismiss];
         NSLog(@"%@",responseObject);
         [SVProgressHUD dismiss];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"custlinkmansave" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
                       [SVProgressHUD dismiss];
     }];
}
#pragma mark - 获取样机列表
- (void)Getproductpagelist
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 @"sType": @"1",
                                 @"PageIndex": @"1",
                                 @"PageSize": @"99"
                                 };
    NSString *url = [NSString stringWithFormat:@"%@product/getproductpagelist",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
//         NSLog(@"%@",responseObject);
         [SVProgressHUD dismiss];
          [self.equipmentLists removeAllObjects];
          NSArray *datas = responseObject[@"data"][@"DataList"];
          for (NSDictionary *dic in datas)
          {
              EquipmentListModel *model = [[EquipmentListModel alloc] init];
              model.ID = dic[@"ID"];
              model.UsedStatus = dic[@"UsedStatus"];
              model.ProductName = dic[@"ProductName"];
//              model.ID = dic[@"ID"];
//              model.LinkManName = dic[@"LinkManName"];
//              model.Sex = dic[@"Sex"];
//              model.Important = dic[@"Important"];
              if (self.equipmentLists.count == 0)
              {
                  self.equipmentLists = [[NSMutableArray alloc] initWithCapacity:0];
              }
              [self.equipmentLists addObject: model];
          }
         [[NSNotificationCenter defaultCenter] postNotificationName:@"getproductpagelist" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
                       [SVProgressHUD dismiss];
     }];
}
#pragma mark - 保存样机申请
// 保存样机申请--ApplyNo:申请编号--自动生成，@CustID：客户Id，@CustTel：客户电话，@Title：标题，Applyer：申请人（不传时为操作用户本身），TotalFee：总费用（系统计算），@Remark：备注，BillStatus：状态（添加时不传）， @ProjectID：项目Id；details(ProductCount:数量；ProductID：商品Id，ProdNo：商品编号，ProductName:商品名称,UsedPrice:单价)
- (void)Sellsamplesave:(NSArray *)details Sellasmples:(NSArray *)sellasmples
{
    NSArray *datas = @[@
    {
        @"ProductID": details[0],
        @"ProductCount": details[1],
//        @"Remark":details[2],
//        @"UsedPrice": details[3],
//        @"ProductName": details[4],
//        @"ProdNo": details[5]
    }];
    NSString *detailstr = [datas mj_JSONString];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 @"DetailStr": detailstr,
                                 @"Title": sellasmples[0],
                                 @"CustID": sellasmples[4],
                                 @"CustTel": sellasmples[2],
                                 @"ProjectID": sellasmples[3],
                                 @"CustLinkManId": sellasmples[1],
                                 };
    JCKLog(@"%@",parameters);
    NSString *url = [NSString stringWithFormat:@"%@order/sellsamplesave",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject);
         [SVProgressHUD dismiss];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"sellsamplesave" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
                       [SVProgressHUD dismiss];
     }];
}
#pragma mark - 查询单个项目
- (void)Getproject
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.otherUserCode,
                                 @"Id" : self.ID,
                                 @"ChildId": @"1"
                                 };
    NSString *url = [NSString stringWithFormat:@"%@projects/getproject",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
//        NSLog(@"%@",responseObject);
         if ([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"-1"])
         {
             [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
         }
         else
         {
             [SVProgressHUD dismiss];
             [self.projectinfos removeAllObjects];
             ProjectInfoModel *model = [ProjectInfoModel mj_objectWithKeyValues:responseObject[@"data"]];
             NSDictionary *sellOrderdic = responseObject[@"data"][@"sellOrder"];
             NSArray *Details = sellOrderdic[@"Details"];
             
             NSDictionary *ProductListdic = responseObject[@"data"][@"sellSample"];
              NSArray *ProductListdics = ProductListdic[@"details"];
             
             if (ProductListdics != nil && ![ProductListdics isKindOfClass:[NSNull class]] && ProductListdics.count !=0)
             {
                 self.ProductList = ProductListdics;
             }
             
             if (Details != nil && ![Details isKindOfClass:[NSNull class]] && Details.count !=0)
             {
                 self.sellOrders = Details;
             }
             
             if ( self.projectinfos.count == 0)
             {
                 self.projectinfos = [[NSMutableArray alloc] initWithCapacity:0];
             }
             [self.projectinfos addObject: model];
             self.constructionDetails = nil;
             NSArray *datas = responseObject[@"data"][@"ProcessList"];
             if (datas.count != 0)
             {
                 JCKLog(@"data = %@",datas);
                 self.constructionDetails = datas;
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"getproject" object:nil];
             }
//             self.sellOrder
             
             
         }


     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
          [SVProgressHUD dismiss];
     }];
}
#pragma mark - 将我的项目放入公海池
- (void)Projecttranspub
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 @"Id": self.ID
                                 };
    NSString *url = [NSString stringWithFormat:@"%@projects/projecttranspub",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject);
         if ([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"101"]) {
             [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
             [self performSelector:@selector(dismiss) withObject:nil afterDelay:2];
         }
         else
         {
          [[NSNotificationCenter defaultCenter] postNotificationName:@"projecttranspub" object:nil];
         }

         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
         [SVProgressHUD dismiss];
     }];
}
#pragma mark - 我来接放入公海池中的项目
- (void)Projectpubtransmine
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 @"Id": self.ID
                                 };
    NSString *url = [NSString stringWithFormat:@"%@projects/projectpubtransmine",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
//         NSLog(@"%@",responseObject);
         [SVProgressHUD dismiss];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"projectpubtransmine" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
          [SVProgressHUD dismiss];
     }];
}
#pragma mark - 获取公共分类（类别为断扩展中）
- (void)Getcodepublictypelist
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 @"ChildId": self.sType,
                                 @"Id": @"1",
                                 @"PageIndex": @"1",
                                 @"PageSize": @"99"
                                 };
    NSString *url = [NSString stringWithFormat:@"%@office/office/getcodepublictypelist",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject);
         [SVProgressHUD dismiss];
         [self.publictypelist removeAllObjects];
         NSArray *datas = responseObject[@"data"];
         for (NSDictionary *dic in datas)
         {
             PublictypelistModel *model = [[PublictypelistModel alloc] init];
             model.ID = dic[@"ID"];
             model.TypeName = dic[@"TypeName"];
//                model.ID = dic[@"ID"];
//                model.ID = dic[@"ID"];
//                model.ID = dic[@"ID"];
//                model.ID = dic[@"ID"];
             if (self.publictypelist.count == 0)
             {
                 self.publictypelist = [[NSMutableArray alloc] initWithCapacity:0];
             }
             [self.publictypelist addObject:model];
         }
         
         [[NSNotificationCenter defaultCenter] postNotificationName:@"getcodepublictypelist" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
          [SVProgressHUD dismiss];
     }];
}
#pragma mark - 获取我的群组
- (void)Getminediscussionlist
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 @"PageIndex": @"1",
                                 @"PageSize": @"99"
                                 };
    NSString *url = [NSString stringWithFormat:@"%@common/rongcloud/getminediscussionlist",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
//         NSLog(@"%@",responseObject);
         [SVProgressHUD dismiss];
         [self.minediscussionlist removeAllObjects];
         NSArray *datas = responseObject[@"data"];
         for (NSDictionary *dic in datas)
         {
             GroupListModel *model = [[GroupListModel alloc] init];
             model.ID = dic[@"ID"];
             model.discussionId = dic[@"discussionId"];
             model.discussionName = dic[@"discussionName"];
             if (self.minediscussionlist.count == 0)
             {
                 self.minediscussionlist = [[NSMutableArray alloc] initWithCapacity:0];
             }
             [self.minediscussionlist addObject:model];
         }
         [[NSNotificationCenter defaultCenter] postNotificationName:@"getminediscussionlist" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
          [SVProgressHUD dismiss];
     }];
}

#pragma mark - 保存项目进度
// SummaryName：进度摘要, DutyPerson：责任人（不传时为上传者本人）, CompanyCD：系统默认（不传), projectID：项目Id, ProcessScale：进度预算, PersonNum：预算人工数, Rate：进度占比（0~1）, ProessID：进度Id（不传）, BeginDate：当前进度开始时间, EndDate：当前进度结束时间, ProjectMemo：备注
- (void)Projectconstructiondetailssave:(NSArray *)projectProcess
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
//                                 @"ID": 1,
                                 @"SummaryName": projectProcess[0],
                                 @"projectID": projectProcess[1],
                                 @"ProcessScale": projectProcess[2],
                                 @"PersonNum": projectProcess[3],
                                 @"Rate": projectProcess[4],
                                 @"BeginDate": projectProcess[5],
                                 @"EndDate": projectProcess[6],
                                 @"ProjectMemo": projectProcess[7],
                                 };
    NSString *url = [NSString stringWithFormat:@"%@projects/projectconstructiondetailssave",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject);
         [SVProgressHUD dismiss];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"projectconstructiondetailssave" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
          [SVProgressHUD dismiss];
     }];
}
#pragma mark - 获取分类费用列表
- (void)Getcodefeetypelist
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 @"Id": self.ID,
                                 @"PageIndex": @"1",
                                 @"PageSize": @"99"
                                 };
    NSString *url = [NSString stringWithFormat:@"%@office/office/getcodefeetypelist",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {

         [SVProgressHUD dismiss];
         [self.getcodefeetypelist removeAllObjects];
         NSArray *datas = responseObject[@"data"];
         for (NSDictionary *dic in datas)
         {
             FeetypelistModel *model = [[FeetypelistModel alloc] init];
             model.ID = dic[@"ID"];
             model.CompanyCD = dic[@"CompanyCD"];
             model.CodeName = dic[@"CodeName"];
             model.FeeSubjectsNo = dic[@"FeeSubjectsNo"];
             if (self.getcodefeetypelist.count == 0)
             {
                 self.getcodefeetypelist = [[NSMutableArray alloc] initWithCapacity:0];
             }
             [self.getcodefeetypelist addObject:model];
         }
         [[NSNotificationCenter defaultCenter] postNotificationName:@"getcodefeetypelist" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
          [SVProgressHUD dismiss];
     }];
}

#pragma mark - 保存项目费用申请单
// 必填项（Title：名称，CustID:客户，ExpType:申请类别-公共分类Id,Details:费用清单）,选填项（Reason:原因；AriseDate：申请日期；NeedDate:需要日期）

- (void)Feeapplysave:(NSArray *)details Feeapplys:(NSArray *)feeapplys
{
//    JCKLog(@"%@ %@",details,feeapplys);
    
//    NSArray *detailss = @[@{
//                    @"ExpID": details[0], // 分类ID
//                    @"ExpType": details[1], // 公共ID
//                    @"Amount": details[2], // 数量
////                    @"ExpRemark": @"" // 备注
//                          }];
    NSString *detailstr = [details mj_JSONString];
    JCKLog(@"%@",detailstr);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 @"detailstr": detailstr,
                                 @"Title": feeapplys[0],
                                 @"CustID": feeapplys[1],
                                 @"AriseDate": feeapplys[2],
                                 @"NeedDate": feeapplys[3],
                                 @"Reason": feeapplys[4],
                                 @"ExpType": feeapplys[5],
                                 @"ProjectID":feeapplys[6],
                                 @"TotalAmount":details[2]
                               
                                 };
    JCKLog(@"%@",parameters);
    NSString *url = [NSString stringWithFormat:@"%@office/office/feeapplysave",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject[@"msg"]);
         NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
         if (![code isEqualToString:@"success"])
         {
//             [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
             UIAlertView *al  = [[UIAlertView alloc] initWithTitle:@"提示" message:code delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
             [al show];

         }
         else
         {
             [SVProgressHUD dismiss];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"feeapplysave" object:nil];
         }
         JCKLog(@"调用了费用");
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
         JCKLog(@"调用了费用返回错误");
          [SVProgressHUD dismiss];
     }];
}
#pragma mark - 我的业绩
// expenseTotal：总报销费用；sellTotal：总到款数
- (void)Getmyachievement
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 @"DateBeg": self.starDate,
                                 @"DateEnd": self.endDate
                                 };
    NSString *url = [NSString stringWithFormat:@"%@common/user/getmyachievement",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
//         NSLog(@"%@",responseObject);
         [SVProgressHUD dismiss];
         self.expenseTotal = responseObject[@"data"][@"expenseTotal"];
         self.sellTotal = responseObject[@"data"][@"sellTotal"];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"getmyachievement" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
          [SVProgressHUD dismiss];
     }];
}
#pragma mark - 获取我的费用申请列表
- (void)Getfeeapplypagelist
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.otherUserCode,
                                 @"sType": @"-1",
                                 @"PageIndex": @"1",
                                 @"Keyword" : _keywork,
                                 @"PageSize": _PageSize
                                 };
    NSString *url = [NSString stringWithFormat:@"%@office/office/getfeeapplypagelist",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject);
         self.feeapplypagelist = nil;
         NSArray *datas = responseObject[@"data"][@"DataList"];
         if (!datas) {
             [SVProgressHUD showWithStatus:@"没有更多数据"];
         }
         else
         {
             [SVProgressHUD dismiss];
             self.feeapplypagelist = datas;
         }
         [[NSNotificationCenter defaultCenter] postNotificationName:@"getfeeapplypagelist" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
          [SVProgressHUD dismiss];
     }];
}
#pragma mark - 获取我的样机列表
- (void)Getsellsamplepagelist
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.otherUserCode,
                                 @"sType": @"0",
                                 @"PageIndex": @"1",
                                 @"PageSize": @"30",
                                 @"Keyword" : _keywork
                                 };
    NSString *url = [NSString stringWithFormat:@"%@order/getsellsamplepagelist",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
//         NSLog(@"%@",responseObject);
         self.getsellsamplepagelist = nil;
         NSArray *datas = responseObject[@"data"][@"DataList"];
         if (!datas) {
             [SVProgressHUD showWithStatus:@"没有更多数据"];
         }
         else
         {
             [SVProgressHUD dismiss];
             self.getsellsamplepagelist = datas;
         }
         
         [[NSNotificationCenter defaultCenter] postNotificationName:@"getsellsamplepagelist" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
          [SVProgressHUD dismiss];
     }];
}
#pragma mark - 保存个人计划
// AimNo:计划编号(系统生成);AimTitle:计划标题；AimContent：计划内容；CreateDate：创建时间--系统生成；StartDate：计划开始时间；EndDate：计划结束时间；AimSortId：计划类别；AimFlag：计划周期（1：日计划；2：周计划；3：月计划；4：季计划；5：年计划）AimSortId：计划类别Id；AimDirectionId：方向类别Id；AimFlag：计划周期（1：日计划；2：周计划；3：月计划；4：季计划；5：年计划）
- (void)Planaimsave:(NSArray *)planaimsaves
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 @"AimTitle": planaimsaves[0],
                                 @"AimSortId": planaimsaves[1],
                                 @"AimDirectionId": planaimsaves[2],
                                 @"AimFlag": planaimsaves[3],
                                 @"StartDate": planaimsaves[4],
                                 @"EndDate": planaimsaves[5],
                                 @"AimContent": planaimsaves[6],
                                 @"Critical": planaimsaves[7],
                                 };
//    JCKLog(@"%@",parameters);
    NSString *url = [NSString stringWithFormat:@"%@office/office/planaimsave",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject);
         [SVProgressHUD dismiss];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"planaimsave" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
          [SVProgressHUD dismiss];
     }];
}
#pragma mark - 查询个人计划列表
- (void)Getplanaimpagelist
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 @"sType": self.sType,
                                 @"PageIndex": @"1",
                                 @"PageSize": @"99",
                                 @"CriticalType": self.keywork
                                 };
    NSString *url = [NSString stringWithFormat:@"%@office/office/getplanaimpagelist",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
//         NSLog(@"%@",responseObject);
         [SVProgressHUD dismiss];
         NSArray *datas = responseObject[@"data"][@"DataList"];
         self.getplanaimpagelist = nil;
         if (datas.count != 0)
         {
             self.getplanaimpagelist = datas;
         }
         [[NSNotificationCenter defaultCenter] postNotificationName:@"getplanaimpagelist" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
          [SVProgressHUD dismiss];
     }];
}
#pragma mark - 获取推送消息、公告等未读统计数
- (void)Getnoreadtotal
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 @"Id":self.ID
                                 };
    NSString *url = [NSString stringWithFormat:@"%@common/mpublic/getnoreadtotal",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         JCKLog(@"%@",responseObject[@"data"]);
         _getnoreadtotal = responseObject[@"data"];
         [SVProgressHUD dismiss];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"getnoreadtotal" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
         [SVProgressHUD dismiss];
     }];
}
#pragma mark - 保存我的建议
// DoUserID:发送的对象用户；Title：标题；Content:内容，其它可不传
- (void)Personaladvicesendsave
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 @"DoUserID": @"0",
                                 @"Title": _title,
                                 @"Content": _context,
                                 @"AdviceType": self.sType
                                 };
    NSString *url = [NSString stringWithFormat:@"%@office/office/personaladvicesendsave",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject);
         [SVProgressHUD showSuccessWithStatus:@"感谢您对公司的建设提供了宝贵的意见"];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"personaladvicesendsave" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
          [SVProgressHUD dismiss];
     }];
}
#pragma mark - 获取公司企业文化信息列表（我的知识）
- (void)Getculturedocpagelist
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.otherUserCode,
                                 @"sType":self.sType
                                 };
    NSString *url = [NSString stringWithFormat:@"%@office/office/getculturedocpagelist",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
//         NSLog(@"%@",responseObject);
         [_getculturedocpagelists removeAllObjects];
         [SVProgressHUD dismiss];
         [self.getculturedocpagelists removeAllObjects];
         NSArray *datas = responseObject[@"data"][@"DataList"];
         for (NSDictionary *dic in datas)
         {
             EnterpriseModel *model = [EnterpriseModel mj_objectWithKeyValues:dic];
             if (self.getculturedocpagelists.count == 0) {
                 self.getculturedocpagelists = [NSMutableArray array];
             }
             [self.getculturedocpagelists addObject:model];
         }
         [[NSNotificationCenter defaultCenter] postNotificationName:@"getculturedocpagelist" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
          [SVProgressHUD dismiss];
     }];
}
#pragma mark - 获取样机详情
- (void)Getsellsample
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.otherUserCode,
                                 @"Id": self.ID
                                 };
    NSString *url = [NSString stringWithFormat:@"%@order/getsellsample",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
//         NSLog(@"%@",responseObject);
         [SVProgressHUD dismiss];
         NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
         if ([code isEqualToString:@"0"])
         {
             DemoChiInfoModel *model = [[DemoChiInfoModel alloc] init];
             model.Title = responseObject[@"data"][@"Title"];
             model.CreateDate = responseObject[@"data"][@"CreateDate"];
             model.CustTel = responseObject[@"data"][@"CustTel"];
             model.details = responseObject[@"data"][@"details"];
             model.CustID = responseObject[@"data"][@"CustID"];
             model.ApplyNo = responseObject[@"data"][@"ID"];
             model.CreatorName = responseObject[@"data"][@"CreatorName"];
             model.FlowSteps = responseObject[@"data"][@"FlowSteps"];
             model.CustName = responseObject[@"data"][@"CustName"];
             model.TotalFee = responseObject[@"data"][@"TotalFee"];
             [self.getsellsamples removeAllObjects];
             if (!self.getsellsamples)
             {
                 self.getsellsamples = [NSMutableArray array];
             }
             [self.getsellsamples addObject:model];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"getsellsample" object:nil];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:@"访问错误"];
         }

         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
          [SVProgressHUD dismiss];
     }];
}
#pragma mark - 获取我的待审核列表
- (void)Getsellsamplepagelistforcheck
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.otherUserCode,
                                 @"sType": self.sType,
                                 @"PageIndex": @"1",
                                 @"PageSize": _PageSize
                                 };
    JCKLog(@"%@",parameters);
    NSString *url = [NSString stringWithFormat:@"%@order/getsellsamplepagelistforcheck",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
//         NSLog(@"%@",responseObject);
         NSArray *datas = responseObject[@"data"][@"DataList"];
         _getsellsamplepagelistforchecks = nil;
         if (datas)
         {
              _getsellsamplepagelistforchecks =datas;
             [[NSNotificationCenter defaultCenter] postNotificationName:@"getsellsamplepagelistforcheck" object:nil];
             [SVProgressHUD dismiss];
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
          [SVProgressHUD dismiss];
     }];
}
#pragma mark - 单据流程审核保存（包含费用申请、样机申请等）
//BillNo:单据编号；State（0:审核通过；2：审核不通过）；Note:备注;BillTypeFlag:模块（5：销售）；BillTypeCode：子模块（11：样机）

- (void)Flowstepcheck
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 @"BillNo": self.flowstepchecks[0],
                                 @"BillTypeFlag": self.flowstepchecks[2],
                                 @"BillTypeCode": self.flowstepchecks[3],
                                 @"State": self.flowstepchecks[1],
                                 @"Note": self.flowstepchecks[4]
                                 };
    JCKLog(@"%@",parameters);
    NSString *url = [NSString stringWithFormat:@"%@common/mpublic/flowstepcheck",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject);
//         [SVProgressHUD dismiss];
         [SVProgressHUD showInfoWithStatus:responseObject[@"msg"]];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"flowstepcheck" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
          [SVProgressHUD dismiss];
     }];
}
#pragma mark - 获取我的建议列表
- (void)Getpersonaladvicesendpagelist
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.otherUserCode,
                                 @"sType":@"2",
                                 @"sType2":self.sType
                                 };
    NSString *url = [NSString stringWithFormat:@"%@office/office/getpersonaladvicesendpagelist",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject);
         [SVProgressHUD dismiss];
         NSArray *datas = responseObject[@"data"][@"DataList"];
         self.getpersonaladvicesendpagelist = nil;
         if (datas) {
             self.getpersonaladvicesendpagelist = datas;
         }
         [[NSNotificationCenter defaultCenter] postNotificationName:@"getpersonaladvicesendpagelist" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
          [SVProgressHUD dismiss];
     }];
}
#pragma mark - 查询我的项目
- (void)GetMyprojectpagelist
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
//                                 @"sType2": self.sType,//成功率
//                                 @"Keyword": self.keywork,
//                                 @"sType": self.sType2,
                                 @"CustId" : self.ID,
                                 @"PageIndex": @"1",
                                 @"PageSize": @"99"
                                 };
    JCKLog(@"%@",parameters);
    NSString *url = [NSString stringWithFormat:@"%@projects/getprojectpagelist",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject);
         [SVProgressHUD dismiss];
         _myPorjectlists = nil;
         NSArray *datas = responseObject[@"data"][@"DataList"];
         if (datas) {
             _myPorjectlists = datas;
         }
         
         [[NSNotificationCenter defaultCenter] postNotificationName:@"getmyprojectpagelist" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
          [SVProgressHUD dismiss];
     }];
}
#pragma mark - 获取客户详情信息（包含客户联系人；最后20条拜访记录）
- (void)Getcustinfo
{
    JCKLog(@"%@",self.ID);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.otherUserCode,
                                 @"Id": self.ID
                                 };
    JCKLog(@"%@",parameters);
    NSString *url = [NSString stringWithFormat:@"%@crm/getcustinfo",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject);
         [SVProgressHUD dismiss];
         _getcustinfoDic = nil;
         NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
         if ([code isEqualToString:@"0"])
         {
             NSDictionary *dataDic = responseObject[@"data"];
             if (dataDic)
             {
                 _getcustinfoDic = dataDic;
             }
             [[NSNotificationCenter defaultCenter] postNotificationName:@"getcustinfo" object:nil];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:@"数据异常"];
         }

         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
          [SVProgressHUD dismiss];
     }];
}
#pragma mark - 阅读登记
- (void)Readsave
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 @"IdTwo": @"2",
                                 @"IdThree": @"24",
                                 @"Id": self.ID

                                 };
    NSString *url = [NSString stringWithFormat:@"%@common/mpublic/readsave",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject);
         [SVProgressHUD dismiss];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
          [SVProgressHUD dismiss];
     }];
}
#pragma mark - 查询公海沲项目
- (void)Getpublicprojectpagelist
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.otherUserCode,
                                 @"sType2": self.sType2,
                                 @"Keyword": self.keywork,
                                 @"sType": self.sType,
                                 @"PageIndex": @"1",
                                 @"PageSize": self.PageSize
                                 };
    NSString *url = [NSString stringWithFormat:@"%@projects/getpublicprojectpagelist",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject);
         [SVProgressHUD dismiss];
         [self.getprojectpagelist removeAllObjects];
         NSArray *datas = responseObject[@"data"][@"DataList"];
         for (NSDictionary *dic in datas)
         {
             GetprojectpagelistModel *model = [[GetprojectpagelistModel alloc] init];
             model.ID = dic[@"ID"];
             model.ProjectNo = dic[@"ProjectNo"];
             model.ProjectName = dic[@"ProjectName"];
             model.CreateDate = dic[@"CreateDate"];
             model.Creator = dic[@"Creator"];
             model.CustID = dic[@"CustID"];
             model.CustLinkMan = dic[@"CustLinkMan"];
             model.LinkTel = dic[@"LinkTel"];
             model.SuccessRate = dic[@"SuccessRate"];
             model.CreatorName = dic[@"CreatorName"];
             model.CustName = dic[@"CustName"];
             if (![FuntionObj isNullDic:dic Key:@"DepartmentName"])
             {
                 model.DepartmentName = @"";
             }
             else
             {
                 model.DepartmentName = dic[@"DepartmentName"];
             }
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
          [SVProgressHUD dismiss];
     }];
}
#pragma mark - 获取资讯分类以及未读统计
- (void)Getculturetypes
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 
                                 };
    NSString *url = [NSString stringWithFormat:@"%@office/office/getculturetypes",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         [SVProgressHUD dismiss];
         NSArray *datas = responseObject[@"data"];
         self.culturetypes = nil;
         if (datas.count != 0)
         {
             self.culturetypes = datas;
         }
         [[NSNotificationCenter defaultCenter] postNotificationName:@"getculturetypes" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
          [SVProgressHUD dismiss];
     }];
}
#pragma mark - 获取推送消息列表
- (void)Getjpushpagelist
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 @"sType": @"-1",
                                 @"Keyword":self.keywork,
                                 @"PageIndex": @"1",
                                 @"PageSize": @"50"
                                 };
    NSString *url = [NSString stringWithFormat:@"%@common/mpublic/getjpushpagelist",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
//         NSLog(@"%@",responseObject);
         [SVProgressHUD dismiss];
         _pushLists = nil;
         NSArray *datas = responseObject[@"data"][@"DataList"];
         if (datas) {
             _pushLists = datas;
         }
         [[NSNotificationCenter defaultCenter] postNotificationName:@"getjpushpagelist" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
          [SVProgressHUD dismiss];
     }];
}
#pragma mark - 根据用户Id获取用户信息
- (void)Getuser
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 @"Id": self.ID
                                 };
    NSString *url = [NSString stringWithFormat:@"%@systemset/account/getuser",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject);
         [SVProgressHUD dismiss];
         NewFriendInfoModel *model = [[NewFriendInfoModel alloc] init];
         model.EmployeeName = responseObject[@"data"][@"EmployeeName"];
         model.PhotoURL = responseObject[@"data"][@"PhotoURL"];
         model.UserID = responseObject[@"data"][@"UserID"];
         if (!_getusers)
         {
             _getusers = [NSMutableArray array];
             [_getusers addObject:model];
         }
         [[NSNotificationCenter defaultCenter] postNotificationName:@"getuser" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
          [SVProgressHUD dismiss];
     }];
}
#pragma mark - 获取部门及其及所有用户列表
- (void)Getdeptusers
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 
                                 };
    NSString *url = [NSString stringWithFormat:@"%@common/user/getdeptusers",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject);
         [SVProgressHUD dismiss];
         NSArray *datas = responseObject[@"data"];
         self.friendLists = nil;
         if (datas)
         {
             self.friendLists = datas;
         }
         [[NSNotificationCenter defaultCenter] postNotificationName:@"getdeptusers" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
          [SVProgressHUD dismiss];
     }];
}
#pragma mark - 查找我的客户联系人列表
- (void)Getminelinkmanpagelist
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.otherUserCode,
                                 @"Keyword": self.keywork,
                                 @"sType": @"0",
                                 @"PageIndex": @"1",
                                 @"PageSize": self.PageSize
                                 };
    NSString *url = [NSString stringWithFormat:@"%@crm/getminelinkmanpagelist",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject);
         [SVProgressHUD dismiss];
         NSArray *datas = responseObject[@"data"][@"DataList"];
         _theNewCustomList = nil;
         if (datas)
         {
             _theNewCustomList = datas;
         }
         [[NSNotificationCenter defaultCenter] postNotificationName:@"getminelinkmanpagelist" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
         [SVProgressHUD showErrorWithStatus:@"服务器暂无该数据"];
     }];
}
#pragma mark - 查询展会列表
- (void)Getsellexhibitionpagelist
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.otherUserCode,
                                 @"PageIndex": @"1",
                                 @"PageSize": @"99"
                                 };
    NSString *url = [NSString stringWithFormat:@"%@order/getsellexhibitionpagelist",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject);
         [SVProgressHUD dismiss];
         NSArray *dats = responseObject[@"data"][@"DataList"];
         _zhanhuis = nil;
         if (dats)
         {
             _zhanhuis = dats;
         }
         [[NSNotificationCenter defaultCenter] postNotificationName:@"getsellexhibitionpagelist" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
          [SVProgressHUD dismiss];
     }];
}
#pragma mark - 获取展会详情
- (void)Getsellexhibition
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code": self.userCode,
                                 @"Id": self.ID
                                 };
    NSString *url = [NSString stringWithFormat:@"%@order/getsellexhibition",ServerAddressURL];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject);
         [SVProgressHUD dismiss];

         NSArray *datas = responseObject[@"data"];
         if (datas)
         {
             _zhanhuiInfos = datas;
         }

         [[NSNotificationCenter defaultCenter] postNotificationName:@"getsellexhibition" object:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error %ld",error.code);
          [SVProgressHUD dismiss];
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

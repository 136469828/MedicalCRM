//
//  NetManger.h
//  MedicalCRM
//
//  Created by admin on 16/7/15.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum
{
    RequestOfGetarticlelist = 0,    // 获取内容列表
    RequestOfLogin, //登录
    RequestOfadvertise, // 广告
    RequestOfgetprojectpagelist, // 项目列表
    RequestOfAccountUpdate, // 更改资料
    RequestOfGetminecustpagelist, //  客户列表
    RequestOfGetcustlinkmanlist, //  联系人列表
    RequestOfCustcontactsave, //  签到
    RequestOfGetcustcontactpagelist, //  签到列表
    RequestOfProjectsave, //  项目新建
    RequestOfGetrongclouduserpagelist, //  好友列表
    RequestOfCustinfosave, //  登记客户信息
    RequestOfCustlinkmansave, //  登记客户联系人信息
    RequestOfGetproductpagelist, //  获取样机列表
    RequestOfGetproject, //  获取项目详细
    RequestOfProjecttranspub, //  将我的项目放入公海池
    RequestOfProjectpubtransmine, //  将公海池放入我的项目
    RequestOfGetcodepublictypelist, //  获取公共分类
    RequestOfGetminediscussionlist, //  获取群组列表
    RequestOfProjectconstructiondetailssave, //  保存项目进度
    RequestOfGetcodefeetypelist, // 获取分类费用列表
    RequestOfSeachrongclouduserpagelist, // 搜索好友列表
    RequestOfFeeapplysave, // 报销
    RequestOfGetmyachievement, // 我的业绩
    RequestOfGetfeeapplypagelist, // 样机申请列表
    RequestOfSellsamplesave, // 保存样机申请列表
    RequestOfGetsellsamplepagelist, // 我的样机申请列表
    RequestOfPlanaimsave, // 保存我的工作计划
    RequestOfGetplanaimpagelist, // 我的工作计划
    RequestOfPersonaladvicesendsave, // 保存我的建议
    RequestOfGetculturedocpagelist, // 企业文化
    RequestOfGetsellsample, // 样机详情
    GetsellsamplepagelistforcheckGetsellsample, //
    RequestOfFlowstepcheck,
    RequestOfGetpersonaladvicesendpagelist,
    RequestOfGetMyprojectpagelist,
    RequestOfGetcustinfo,
    RequestOfReadsave,
    RequestOfGetpublicprojectpagelist,
    RequestOfGetculturetypes,
    RequestOfGetjpushpagelist, // 消息推送
    RequestOfGetuser,
    RequestOfGetdeptusers,
    RequestOfGetminelinkmanpagelist,
    RequestOfGetsellexhibitionpagelist,
    RequestOfGetsellexhibition,
    RequestOfSellexhibitionsave,
    RequestOfGetemployeeteampagelist,
    RequestOfGetemployeeteam,
    RequestOfEmployeeteamsave,
    RequestOfGetfeeapply,
    RequestOfGetemployeenav,
    RequestOfGetpersonaldatearrangepagelist,
    RequestOfSaveemployeenav,
    RequestOfPersonaldatearrangesave,
    RequestOfGetachievementtotal,
    RequestOfGetfeeapplypagelistforcheck,
    RequestOfSellordersave,
    RequestOfGetsellorderpagelistforcheck,
    RequestOfGetsellorder,
    RequestOfGetlinkman,
    RequestOfJpushreadsave,
    RequestOfGetnochecktotal,
    RequestOfGetnoreadtotal,
    RequestOfPersonallinkmansave,
    RequestOfGetpersonallinkmanpagelist,
    RequestOfUpdatepassword,
    RequestOfCreatediscussion,
    RequestOfGetminelinkmanpagelists,
    RequestOfPersonallinkmansavebatch
}RequestState;
@interface NetManger : NSObject
#pragma mark - 注册
@property (nonatomic, copy)NSString *rongcloudToken;
@property (nonatomic, copy)NSString *userName;
@property (nonatomic, copy)NSString *userID;
@property (nonatomic, copy)NSString *userOtherID;
@property (nonatomic, copy)NSString *userPWD;
@property (nonatomic, copy) NSString *userCode;
@property (nonatomic, copy) NSString *otherUserCode;
@property (nonatomic, copy) NSString *otherUserName;
@property (nonatomic, copy) NSString *sType;
@property (nonatomic, copy) NSString *sType2;
@property (nonatomic, copy) NSString *sType3;
@property (nonatomic, copy) NSString *photoData;
@property (nonatomic, copy) NSString *customID;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *keywork;
@property (nonatomic, copy) NSString *starDate;
@property (nonatomic, copy) NSString *endDate;
@property (copy, nonatomic) NSString *expenseTotal;
@property (copy, nonatomic) NSString *sellTotal;
@property (copy, nonatomic) NSString *DeptName;
@property (copy, nonatomic) NSString *context;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *pushID;
@property (copy, nonatomic) NSString *oldPword;
@property (copy, nonatomic) NSString *passwordOfnew;
@property (copy,nonatomic) NSString *PageSize;

@property (nonatomic, copy) NSArray *temporaryProductName;
@property (nonatomic, copy) NSString *temporaryProductCount;

@property (nonatomic, copy) NSString *CustNo;
@property (nonatomic, copy) NSString *CustLinkManID;
@property (nonatomic, strong) NSDictionary *getcustinfoDic;
@property (nonatomic, copy) NSString *projcetID;
@property (nonatomic, strong) NSArray *personallinkmansavebatchs;
@property (nonatomic, strong) NSArray *creatediscussionsDetails;
@property (nonatomic, strong) NSArray *creatediscussions;
@property (nonatomic, strong) NSArray *personallinkmansaves;
@property (nonatomic, copy) NSString *getnoreadtotal;
@property (nonatomic, copy)  NSString *myTeamBulidName;
@property (nonatomic, copy)  NSString *NoCheckTotalCount;
@property (nonatomic ,copy) NSString *canViewUsers;
@property (nonatomic ,strong) NSArray *importantDatas;
@property (nonatomic, copy)  NSString *userNewPhoto;
@property (nonatomic, strong) NSArray *userInfos;
@property (nonatomic, strong) NSArray *sigins;
@property (nonatomic, strong) NSArray *projectsaves;
@property (nonatomic, strong) NSArray *custinfoinfo;
@property (nonatomic, strong) NSArray *custlinkmaninfo;
@property (nonatomic, strong) NSArray *projectProcess;
@property (nonatomic, strong) NSArray *feeapplys;
@property (nonatomic, strong) NSArray *feeapplyDetails;
@property (nonatomic, strong) NSArray *constructionDetails;
@property (nonatomic, strong) NSArray *sellOrders;
@property (nonatomic, strong) NSArray *ProductList;
@property (nonatomic, strong) NSArray *demoMachiSaves;
@property (nonatomic, strong) NSArray *demoMachidetails;
@property (nonatomic, strong) NSArray *planaimsaves;

@property (nonatomic, strong) NSMutableArray *getminecustpagelistLinMans;
@property (nonatomic, strong) NSMutableArray *getminecustpagelistProjects;
@property (nonatomic, strong) NSArray *getpersonallinkmanpagelists;
@property (nonatomic, strong) NSArray *getlinkmans;
@property (nonatomic, strong) NSArray *getsellorders;
@property (nonatomic, strong) NSArray *sellorderpagelistforcheck;
@property (nonatomic, strong) NSArray *detailss;
@property (nonatomic, strong) NSArray *sellordersaves;
@property (nonatomic, strong) NSArray *getfeeapplypagelistforchecks;
@property (nonatomic, strong) NSArray *importantItemsLisr;
@property (nonatomic, strong) NSDictionary *lifeDic;
@property (nonatomic, strong) NSDictionary *myPayInfos;
@property (nonatomic, strong) NSArray *myTeamBulids;
@property (nonatomic, strong) NSArray *myTeamInfos;
@property (nonatomic, strong) NSArray *myTeamList;
@property (nonatomic, strong) NSArray *zhanhuiSave;
@property (nonatomic, strong) NSArray *zhanhuiInfos;
@property (nonatomic, strong) NSArray *zhanhuis;
@property (nonatomic, strong) NSArray *theNewCustomList;
@property (nonatomic, strong) NSArray *friendLists;
@property (nonatomic, assign) BOOL isUpDatePhotoData;
@property (nonatomic, strong) NSMutableArray *getusers;
@property (nonatomic, strong) NSArray *pushLists;
@property (nonatomic, strong) NSArray *theNewFriendLists;
@property (nonatomic, strong) NSArray *culturetypes;
@property (nonatomic, strong) NSArray *myPorjectlists;
@property (nonatomic, strong) NSArray *getpersonaladvicesendpagelist;
@property (nonatomic, strong) NSArray *flowstepchecks;
@property (nonatomic, strong) NSArray *getsellsamplepagelistforchecks;
@property (nonatomic, strong) NSMutableArray *getsellsamples;
@property (nonatomic, strong) NSMutableArray *getculturedocpagelists;
@property (nonatomic, strong) NSArray *getsellsamplepagelist;
@property (nonatomic, strong) NSArray *feeapplypagelist;
@property (nonatomic, strong) NSArray *getplanaimpagelist;
@property (nonatomic, strong) NSMutableArray *departments;
@property (nonatomic, strong) NSMutableArray *getcodefeetypelist;
@property (nonatomic, strong) NSMutableArray *minediscussionlist;
@property (nonatomic, strong) NSMutableArray *publictypelist;
@property (nonatomic, strong) NSMutableArray *getminelinkmanpagelists;
@property (nonatomic, strong) NSMutableArray *projectinfos;
@property (nonatomic, strong) NSMutableArray *equipmentLists;
@property (nonatomic, strong)NSMutableArray *clouduserpagelist;
@property (nonatomic, strong)NSMutableArray *logins;
@property (nonatomic, strong)NSMutableArray *ads;
@property (nonatomic, strong)NSMutableArray *getcustcontactpagelist;
@property (nonatomic, strong)NSMutableArray *getminecustpagelist;
@property (nonatomic, strong)NSMutableArray *getnoticepagelist;
@property (nonatomic, strong)NSMutableArray *getprojectpagelist;
@property (nonatomic, strong)NSMutableArray *getcustlinkmanlist;
+ (instancetype)shareInstance;
- (void)loadData:(RequestState)requet;
@end

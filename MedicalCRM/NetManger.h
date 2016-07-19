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
    
}RequestState;
@interface NetManger : NSObject
#pragma mark - 注册
@property (nonatomic, copy)NSString *userName;
@property (nonatomic, copy)NSString *userPWD;
@property (nonatomic, copy) NSString *userCode;
@property (nonatomic, copy) NSString *sType;
@property (nonatomic, copy) NSString *photoData;
@property (nonatomic, copy) NSString *customID;
@property (nonatomic, strong) NSArray *userInfos;
@property (nonatomic, strong) NSArray *sigins;
@property (nonatomic, strong)NSMutableArray *logins;
@property (nonatomic, strong)NSMutableArray *ads;
@property (nonatomic, strong)NSMutableArray *getminecustpagelist;
@property (nonatomic, strong)NSMutableArray *getnoticepagelist;
@property (nonatomic, strong)NSMutableArray *getprojectpagelist;
@property (nonatomic, strong)NSMutableArray *getcustlinkmanlist;
+ (instancetype)shareInstance;
- (void)loadData:(RequestState)requet;
@end

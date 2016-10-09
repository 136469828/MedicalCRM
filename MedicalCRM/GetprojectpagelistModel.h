//
//  GetprojectpagelistModel.h
//  MedicalCRM
//
//  Created by admin on 16/7/18.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetprojectpagelistModel : NSObject
@property (nonatomic, copy) NSString *ID; // ID
@property (nonatomic, copy) NSString *ProjectNo; // 项目编号
@property (nonatomic, copy) NSString *ProjectName; // 名字
@property (nonatomic, copy) NSString *CreateDate; // 申请时间
@property (nonatomic, copy) NSString *Creator; // 创建人ID
@property (nonatomic, copy) NSString *CustID; // Creator
@property (nonatomic, copy) NSString *CustLinkMan; // 联系人人名字
@property (nonatomic, copy) NSString *LinkTel; // 联系电话
@property (nonatomic, copy) NSString *SuccessRate; // 成功率
@property (nonatomic, copy) NSString *SuccessRateNum; // 成功率
@property (nonatomic, copy) NSString *CreatorName; // 负责人名字
@property (nonatomic, copy) NSString *StatusName;
@property (nonatomic, copy) NSString *DepartmentName;
@property (nonatomic, copy) NSString *CustName;
@property (nonatomic, copy) NSString *AcceptMoney;
@end

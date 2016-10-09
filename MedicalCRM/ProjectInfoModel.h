//
//  ProjectInfoModel.h
//  MedicalCRM
//
//  Created by admin on 16/7/22.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectInfoModel : NSObject
@property (nonatomic, copy) NSString *ID; //
@property (nonatomic, copy) NSString *ProjectNo; //
@property (nonatomic, copy) NSString *ProjectName; //
@property (nonatomic, copy) NSString *CreateDate; //
@property (nonatomic, copy) NSString *Creator; //
@property (nonatomic, copy) NSString *CustLinkMan; //
@property (nonatomic, copy) NSString *LinkTel; //
@property (nonatomic, copy) NSString *SuccessRate; //
@property (nonatomic, copy) NSString *Remark; //
@property (nonatomic, copy) NSString *Investment; //
@property (nonatomic, copy) NSString *StatusName;
@property (nonatomic, copy) NSString *CanViewUserName;
@property (nonatomic, copy) NSString *ZhiWu;// 职务
@property (nonatomic, copy) NSString *DepartmentName; // 科室
@property (nonatomic, copy) NSString *CustName; //医院
@property (nonatomic, copy) NSString *CustID;

@property (nonatomic, copy) NSString *ProcessId;
@property (nonatomic, copy) NSString *ProcessName;
@property (nonatomic, copy) NSString *PlanDate;

@property (nonatomic, copy) NSString *productID;
@property (nonatomic, copy) NSString *ProductName;
@property (nonatomic, copy) NSString *ProductCount;
@property (nonatomic, copy) NSString *UsedPrice;

@end

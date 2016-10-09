//
//  GetsellsamplepagelistforcheckModel.h
//  MedicalCRM
//
//  Created by admin on 16/8/4.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetsellsamplepagelistforcheckModel : NSObject
@property (copy, nonatomic) NSString *Title;
@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *ProductName;
@property (copy, nonatomic) NSString *ProjectName;
@property (copy, nonatomic) NSString *CreateDate;
@property (copy, nonatomic) NSString *CheckStatusName;
@property (copy, nonatomic) NSString *CreatorName;
@property (copy, nonatomic) NSString *CustName;
@property (copy, nonatomic) NSString *ApplyNo;
@property (nonatomic, strong) NSArray *FlowSteps;


@property (copy, nonatomic) NSString *BillStatusName;
@property (copy, nonatomic) NSString *SendDateStr;
@property (copy, nonatomic) NSString *ExpireDateStr;
@property (copy, nonatomic) NSString *SaleDateStr;
@property (copy, nonatomic) NSString *ModifyDateStr;
@property (copy, nonatomic) NSString *IsDateOver;
@property (copy, nonatomic) NSString *IsDelayApply;
@end

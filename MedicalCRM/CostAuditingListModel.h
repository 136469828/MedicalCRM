//
//  CostAuditingListModel.h
//  MedicalCRM
//
//  Created by admin on 16/8/13.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CostAuditingListModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *Title;
@property (nonatomic, copy) NSString *AriseDate;
@property (nonatomic, copy) NSString *NeedDate;
@property (nonatomic, copy) NSString *TotalAmount;
@property (nonatomic, copy) NSString *Reason;
@property (nonatomic, copy) NSString *ProjectName;
@property (nonatomic, copy) NSString *CreatorName;
@property (nonatomic, copy) NSString *ExpCode;
@property (nonatomic, copy) NSString *FlowStatusName;
//@property (nonatomic, copy) NSString *FlowStatusName;

//@property (nonatomic, strong) NSMutableArray *Details;
//@property (nonatomic, strong) NSMutableArray *FlowSteps;
@property (nonatomic, copy) NSString *CheckStatusName;
@property (nonatomic, copy) NSString *StepName;
@property (nonatomic, copy) NSString *CreateDate;

@property (nonatomic, copy) NSString *ChenGuo;
@property (nonatomic, copy) NSString *BigAreaCheckMan;
@property (nonatomic, copy) NSString *BusinessCheckMan;
@property (nonatomic, copy) NSString *SaleManagerCheckMan;
@property (nonatomic, copy) NSString *CompanyLeaderCheckMan;
@property (nonatomic, copy) NSString *FinanceCheckMan;
@property (nonatomic, copy) NSString *AcceptMoneyDate;

@end


//
//  StopckUpListModel.h
//  MedicalCRM
//
//  Created by admin on 16/8/16.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StopckUpListModel : NSObject
@property (nonatomic, copy) NSString *CheckStatusName;
@property (nonatomic, copy) NSString *CreateDate;
@property (nonatomic, copy) NSString *ProductID;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *Title;
@property (nonatomic, copy) NSString *CreatorName;
@property (nonatomic, copy) NSString *TotalFee;
@property (nonatomic, copy) NSString *CustName;
@property (nonatomic, copy) NSString *CountTotal;
@property (nonatomic, copy) NSString *OrderNo;
@property (nonatomic, copy) NSString *ProjectName;
@property (nonatomic, strong) NSMutableArray *FlowSteps;
@end

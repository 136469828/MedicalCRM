//
//  DemoChiInfoModel.h
//  MedicalCRM
//
//  Created by admin on 16/8/4.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DemoChiInfoModel : NSObject
@property (nonatomic, copy) NSString *Title;
@property (nonatomic, copy) NSString *CustTel;
@property (nonatomic, copy) NSString *CreateDate;
@property (nonatomic, copy) NSString *CustID;
@property (nonatomic, strong) NSMutableArray *details;
@property (nonatomic, copy) NSString *ApplyNo;
@property (nonatomic, copy) NSString *CreatorName;
@property (nonatomic, strong) NSMutableArray *FlowSteps;
@property (nonatomic, strong) NSMutableArray *UsedPrice;
@property (nonatomic, copy) NSString *ProjectName;
@property (nonatomic, copy) NSString *CustName;
@property (nonatomic, copy) NSString *TotalFee;
@end

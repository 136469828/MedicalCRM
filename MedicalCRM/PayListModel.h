//
//  PayListModel.h
//  MedicalCRM
//
//  Created by admin on 16/7/30.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayListModel : NSObject
@property (nonatomic, copy) NSString *Title;
@property (nonatomic, copy) NSString *Reason;
@property (nonatomic, copy) NSString *Status;
@property (nonatomic, copy) NSString *CreateDate;
@property (nonatomic, copy) NSString *ExpType;
@property (nonatomic, copy) NSString *CustID;
@property (nonatomic, copy) NSString *TotalAmount;
@property (nonatomic, copy) NSString *AriseDate;
@property (nonatomic, copy) NSString *NeedDate;
@property (nonatomic, copy) NSString *CreatorName;
@property (nonatomic, copy) NSString *ProjectName;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *ExpCode;
@property (nonatomic, copy) NSString *FlowStatusName;
@end

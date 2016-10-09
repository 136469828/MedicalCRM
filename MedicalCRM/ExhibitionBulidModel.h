//
//  ExhibitionBulidModel.h
//  MedicalCRM
//
//  Created by admin on 16/8/12.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExhibitionBulidModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *LinkManName;
@property (nonatomic, copy) NSString *Title;
@property (nonatomic, copy) NSString *ExhibitionStartDate;
@property (nonatomic, copy) NSString *ExhibitionEndDate;
@property (nonatomic, copy) NSString *Address;
//@property (nonatomic, copy) NSString *CreateDate;
@property (nonatomic, copy) NSString *ExhibitionPlan;
@property (nonatomic, copy) NSString *ExhibitionAim;
@property (nonatomic, copy) NSString *UnionPartner;
//@property (nonatomic, copy) NSString *PlanFee;
@property (nonatomic, copy) NSString *Competitors;
@property (nonatomic, copy) NSString *AttendPersons;
@property (nonatomic, copy) NSString *PlanFee;
@property (nonatomic, copy) NSString *LinkTel;
+ (instancetype)shareInstance;
@end

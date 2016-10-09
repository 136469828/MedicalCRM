//
//  PartnersVisitModel.h
//  MedicalCRM
//
//  Created by admin on 16/9/6.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PartnersVisitModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *company;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *department;
@property (nonatomic, copy) NSString *zhiwu;
@property (nonatomic, copy) NSString *location;
@property (nonatomic ,assign) BOOL ispartner;
@property (nonatomic ,assign) BOOL isdealers;
@property (nonatomic, copy) NSString *signinContext;
@property (nonatomic, copy) NSString *proName;
@property (nonatomic, copy) NSString *proID;
// 费用
@property (nonatomic, copy) NSString *FeeApplyTravelCount;
@property (nonatomic, copy) NSString *FeeApplyAccommodationCount;
@property (nonatomic, copy) NSString *FeeApplyGiftCount;
@property (nonatomic, copy) NSString *FeeApplyOtherCount;
+ (instancetype)shareInstance;
+ (void)tearDown;
@end

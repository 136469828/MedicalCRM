//
//  CostDetailModel.h
//  MedicalCRM
//
//  Created by admin on 16/9/28.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CostDetailModel : NSObject
// 住宿费用
@property (nonatomic, copy) NSString *planeCost;
@property (nonatomic, copy) NSString *longDistanceTransport;
@property (nonatomic, copy) NSString *accommodation;
@property (nonatomic, copy) NSString *luqiao;
@property (nonatomic, copy) NSString *onAbusinessTripToTheTraffic;
@property (nonatomic, copy) NSString *onAbusinessTripAllowance;
// 其他费用
@property (nonatomic, copy) NSString *logistics;
@property (nonatomic, copy) NSString *print;
@property (nonatomic, copy) NSString *bidToMake;
@property (nonatomic, copy) NSString *officeSupplies;
@property (nonatomic, copy) NSString *purchaseditems;
@property (nonatomic, copy) NSString *communicationallowance;
@property (nonatomic, copy) NSString *trafficSubsidies;
@property (nonatomic, copy) NSString *housingSubsidies;
@property (nonatomic, copy) NSString *entertain;
@property (nonatomic, copy) NSString *gift;

+ (instancetype)shareInstance;
+ (void)tearDown;
@end

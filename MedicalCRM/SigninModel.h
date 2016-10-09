//
//  SigninModel.h
//  MedicalCRM
//
//  Created by admin on 16/9/5.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SigninModel : NSObject
@property (nonatomic, copy) NSString *cusID;
@property (nonatomic, copy) NSString *cusName;
@property (nonatomic, copy) NSString *departName;
@property (nonatomic, copy) NSString *proNo;
@property (nonatomic, copy) NSString *proName;
@property (nonatomic, copy) NSString *produName;
@property (nonatomic, copy) NSString *produCount;
@property (nonatomic, copy) NSString *proLinkMan;
@property (nonatomic, copy) NSString *proLinkTel;
@property (nonatomic, copy) NSString *proLinkManDepart;
@property (nonatomic, copy) NSString *proLinkManZhiwu;
@property (nonatomic, copy) NSString *proTimePlant;
@property (nonatomic, copy) NSString *proSucess;
@property (nonatomic, copy) NSString *proState;
@property (nonatomic, copy) NSString *proStateID;
@property (nonatomic, copy) NSString *signinContext;
@property (nonatomic, copy) NSString *proID;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *demoMachiNames;
@property (nonatomic, strong) NSString *demoMachiIDs;
@property (nonatomic, copy) NSString *demoMaCount;

@property (nonatomic, copy) NSString *demoMachiNames2;
@property (nonatomic, strong) NSString *demoMachiIDs2;
@property (nonatomic, copy) NSString *demoMaCount2;

@property (nonatomic, copy) NSString *demoMachiNames3;
@property (nonatomic, strong) NSString *demoMachiIDs3;
@property (nonatomic, copy) NSString *demoMaCount3;

@property (nonatomic, copy) NSString *ProlinkManID;
// 费用
@property (nonatomic, copy) NSString *FeeApplyTravelCount;
@property (nonatomic, copy) NSString *FeeApplyAccommodationCount;
@property (nonatomic, copy) NSString *FeeApplyGiftCount;
@property (nonatomic, copy) NSString *FeeApplyOtherCount;
// 计划
@property (nonatomic, copy) NSString *plantPrototype;
@property (nonatomic, copy) NSString *plantParametersAndTheSolution;
@property (nonatomic, copy) NSString *plantTender;
@property (nonatomic, copy) NSString *plantContract;
@property (nonatomic, copy) NSString *plantInvoice;
@property (nonatomic, copy) NSString *plantDelivery;
@property (nonatomic, copy) NSString *plantPayment;
// 产品
@property (nonatomic, copy) NSString *productNames;
@property (nonatomic, strong) NSString *productIDs;
@property (nonatomic, copy) NSString *productCount;
@property (nonatomic, copy) NSString *productPrice;

@property (nonatomic, copy) NSString *productNames2;
@property (nonatomic, strong) NSString *productIDs2;
@property (nonatomic, copy) NSString *productCount2;
@property (nonatomic, copy) NSString *productPrice2;

@property (nonatomic, copy) NSString *productNames3;
@property (nonatomic, strong) NSString *productIDs3;
@property (nonatomic, copy) NSString *productCount3;
@property (nonatomic, copy) NSString *productPrice3;

@property (nonatomic, copy) NSString *productNames4;
@property (nonatomic, strong) NSString *productIDs4;
@property (nonatomic, copy) NSString *productCount4;
@property (nonatomic, copy) NSString *productPrice4;

@property (nonatomic, copy) NSString *productNames5;
@property (nonatomic, strong) NSString *productIDs5;
@property (nonatomic, copy) NSString *productCount5;
@property (nonatomic, copy) NSString *productPrice5;
+ (instancetype)shareInstance;
+ (void)tearDown;
@end

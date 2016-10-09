//
//  ProBuildModel.h
//  MedicalCRM
//
//  Created by admin on 16/7/29.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProBuildModel : NSObject
@property (nonatomic, copy) NSString * name;// 名
@property (nonatomic, copy) NSString * adress;// 联系地址
@property (nonatomic, copy) NSString * liinkMan;// 联系人
@property (nonatomic, copy) NSString * tel;// 工作电话
@property (nonatomic, copy) NSString * price;// 金额
@property (nonatomic, copy) NSString * success;// 成功
@property (nonatomic, copy) NSString * remark;// 备注
@property (nonatomic, copy) NSString * cusId;//
@property (nonatomic, copy) NSString * ProjectDirectionId;
@property (nonatomic, copy) NSString * ProjectDirectionName;
@property (nonatomic, copy) NSString * phone;// 电话
@property (nonatomic, copy) NSString * hospital;// 
@property (nonatomic, copy) NSString * zhiwu;//
@property (nonatomic, copy) NSString * keshi;//
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *proName;
@property (nonatomic, copy) NSString *canViewUserName;
@property (nonatomic, copy) NSString *demoMachiName;
@property (nonatomic, copy) NSString *demoMachiId;
@property (nonatomic, copy) NSString *demoMaCount;
@property (nonatomic, copy) NSString *datePlanDesc;
@property (nonatomic, copy) NSString *ProlinkManID;
+ (instancetype)shareInstance;

@end

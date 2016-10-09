//
//  DayPlanModel.h
//  MedicalCRM
//
//  Created by admin on 16/8/2.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DayPlanModel : NSObject
@property (nonatomic, copy) NSString * starDate;// 开始时间
@property (nonatomic, copy) NSString * endDate;// 结束时间
@property (nonatomic, copy) NSString * plan;// 计划详情
@property (nonatomic, copy) NSString * title;// 计划详情
+ (instancetype)shareInstance;
@end

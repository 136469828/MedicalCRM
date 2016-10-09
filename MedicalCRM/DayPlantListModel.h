//
//  DayPlantListModel.h
//  MedicalCRM
//
//  Created by admin on 16/8/2.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DayPlantListModel : NSObject
@property (nonatomic, copy) NSString * AimTitle;// 计划标题
@property (nonatomic, copy) NSString * AimContent;// 计划详情
@property (nonatomic, copy) NSString * StartDate;// 计划开始时间
@property (nonatomic, copy) NSString * EndDate;// 计划结束时间
@property (nonatomic, copy) NSString * AimSortId;// 计划分类
@property (nonatomic, copy) NSString * AimFlag;// 计划周期
@property (nonatomic, copy) NSString * AimDirectionId;// 计划方向
@property (nonatomic, copy) NSString * AimSortName;// 计划方向
@property (nonatomic, copy) NSString * AimDirectionName;// 计划方向
@end

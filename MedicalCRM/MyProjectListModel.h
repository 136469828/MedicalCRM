//
//  MyProjectListModel.h
//  MedicalCRM
//
//  Created by admin on 16/8/5.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyProjectListModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *ProjectNo;
@property (nonatomic, copy) NSString *ProjectName;// 项目名
@property (nonatomic, copy) NSString *CreateDate;
@property (nonatomic, copy) NSString *CustLinkMan;
@property (nonatomic, copy) NSString *LinkTel;//电话
@property (nonatomic, copy) NSString *SuccessRate;
@property (nonatomic, copy) NSString *Remark;
@property (nonatomic, copy) NSString *ProjectDirectionName; //领域
@property (nonatomic, copy) NSString *CreatorName;
@property (nonatomic, copy) NSString *Investment;
@property (nonatomic, copy) NSString *CanViewUserName;// 关键人
@property (nonatomic, copy) NSString *ZhiWu; //职务
@property (nonatomic, copy) NSString *DepartmentName; //科室
@property (nonatomic, copy) NSString *CustName; //医院

//项目名 医院 科室 领域 机型 数量 时间计划 关键人 内容 联系人 电话
@end

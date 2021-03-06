//
//  AddMyTeamMenberModel.h
//  MedicalCRM
//
//  Created by admin on 16/8/22.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddMyTeamMenberModel : NSObject
@property (nonatomic, copy) NSString * linkManName;// 名
@property (nonatomic, copy) NSString * sex;// 性别
@property (nonatomic, copy) NSString * tel;// 电话
@property (nonatomic, copy) NSString * department;// 部门
@property (nonatomic, copy) NSString * Email;// 邮箱
@property (nonatomic, copy) NSString * QQ;// QQ
@property (nonatomic, copy) NSString * age;// 年龄
@property (nonatomic, copy) NSString * CompanyName;// 备注
@property (nonatomic, copy) NSString * position;// 职位

+ (instancetype)shareInstance;
@end

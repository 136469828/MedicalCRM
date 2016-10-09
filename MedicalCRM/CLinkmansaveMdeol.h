//
//  CLinkmansaveMdeol.h
//  MedicalCRM
//
//  Created by admin on 16/7/29.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLinkmansaveMdeol : NSObject
@property (nonatomic, copy) NSString * comName;// 公司名
@property (nonatomic, copy) NSString * cicy;// 所在城市
@property (nonatomic, copy) NSString * aress;// 经营范围
@property (nonatomic, copy) NSString * tel;// 工作电话
@property (nonatomic, copy) NSString * phone;// 手机
@property (nonatomic, copy) NSString * eMail;// 邮箱
@property (nonatomic, copy) NSString * adress;// 联系地址
@property (nonatomic, copy) NSString * remark;// 备注
+ (instancetype)shareInstance;
@end

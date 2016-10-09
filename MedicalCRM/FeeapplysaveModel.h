//
//  FeeapplysaveModel.h
//  MedicalCRM
//
//  Created by admin on 16/7/30.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeeapplysaveModel : NSObject
@property (nonatomic, copy) NSString * title;// 名
@property (nonatomic, copy) NSString * count;// 数量
@property (nonatomic, copy) NSString * reson;// 原因
@property (nonatomic, copy) NSString * remark;// 备注
+ (instancetype)shareInstance;
@end

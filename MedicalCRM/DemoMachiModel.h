//
//  DemoMachiModel.h
//  MedicalCRM
//
//  Created by admin on 16/7/30.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DemoMachiModel : NSObject
@property (nonatomic, copy) NSString * title;// 名
@property (nonatomic, copy) NSString * count;// 数量
@property (nonatomic, copy) NSString * tel;// 工作电话
@property (nonatomic, copy) NSString * price;// 金额
@property (nonatomic, copy) NSString * remark;// 备注

+ (instancetype)shareInstance;
@end

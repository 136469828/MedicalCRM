//
//  CustpagelistModel.h
//  MedicalCRM
//
//  Created by admin on 16/7/19.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustpagelistModel : NSObject
@property (nonatomic, copy) NSString *ID; // 客户ID
@property (nonatomic, copy) NSString *CustNo; // 客户编号
@property (nonatomic, copy) NSString *CustName; // 客户名
@property (nonatomic, copy) NSString *Tel; // 客户电话
@property (nonatomic, copy) NSString *SellArea; // 领域
@property (nonatomic, copy) NSMutableArray *ProjectsProject;
@property (nonatomic, copy) NSMutableArray *ProjectsLinMans;
@end

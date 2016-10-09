//
//  ProjectListModel.h
//  MedicalCRM
//
//  Created by admin on 16/8/6.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectListModel : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *ProjectNo;
@property (nonatomic, copy) NSString *ProjectName;
@property (nonatomic, copy) NSString *CreateDate;
@property (nonatomic, copy) NSString *CustLinkMan;
@property (nonatomic, copy) NSString *LinkTel;
@property (nonatomic, copy) NSString *SuccessRate;
@property (nonatomic, copy) NSString *Investment;
@property (nonatomic, copy) NSString *CreatorName;

@end

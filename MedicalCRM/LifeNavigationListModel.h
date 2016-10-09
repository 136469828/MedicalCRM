//
//  LifeNavigationListModel.h
//  MedicalCRM
//
//  Created by admin on 16/8/12.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LifeNavigationListModel : NSObject
@property (nonatomic, copy) NSString *TotalMineMoneyByYear;
@property (nonatomic, copy) NSString *TotalMineMoneyByFuture;
@property (nonatomic, copy) NSString *TeamCountByYear;
@property (nonatomic, copy) NSString *TeamCountByFuture;
@property (nonatomic, copy) NSString *VisitCountByDay;
@property (nonatomic, copy) NSString *VisitCountByYear;
@property (nonatomic, copy) NSString *CustomCountByYear;
@property (nonatomic, copy) NSString *ProjectCountByYear;
@property (nonatomic, copy) NSString *SaleMoneyByYear;
@property (nonatomic, copy) NSString *ProjectMoneyByYear;
@property (nonatomic, copy) NSString *CreateDate;
@property (nonatomic, strong) NSMutableArray *ChanceTypeList;
+ (instancetype)shareInstance;
@end

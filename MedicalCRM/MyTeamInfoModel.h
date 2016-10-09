//
//  MyTeamInfoModel.h
//  MedicalCRM
//
//  Created by admin on 16/8/12.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyTeamInfoModel : NSObject
@property (nonatomic, copy) NSString *UserID;
@property (nonatomic, copy) NSString *PersonName;
@property (nonatomic, copy) NSString *QuarterName;
@property (nonatomic, copy) NSString *DeptName;
@property (nonatomic, copy) NSString *PhotoURL;
@property (nonatomic, copy) NSMutableArray *users;
@end

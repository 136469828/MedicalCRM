//
//  MyTeamListModel.h
//  MedicalCRM
//
//  Created by admin on 16/8/12.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyTeamListModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *TeamName;
@property (nonatomic, copy) NSString *EmployeeNames;
@property (nonatomic, copy) NSMutableArray *users;
@property (nonatomic, copy) NSString *UserId;
@property (nonatomic, copy) NSString *LinkmanName;
@end

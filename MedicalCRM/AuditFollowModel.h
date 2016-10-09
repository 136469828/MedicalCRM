//
//  AuditFollowModel.h
//  MedicalCRM
//
//  Created by admin on 16/8/5.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuditFollowModel : NSObject
@property (nonatomic, copy) NSString *CheckStatusName;
@property (nonatomic, copy) NSString *StepName;
@property (nonatomic, copy) NSString *ModifiedDate;
@property (nonatomic, copy) NSString *Note;
@end

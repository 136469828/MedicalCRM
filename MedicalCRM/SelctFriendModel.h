//
//  SelctFriendModel.h
//  MedicalCRM
//
//  Created by admin on 16/8/26.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelctFriendModel : NSObject
@property (nonatomic, copy) NSString *m_nick;
@property (nonatomic, copy) NSString *UserID;
@property (nonatomic, copy) NSString *EmployeeName;
@property (nonatomic, copy) NSString *PhotoURL;
@property (nonatomic, copy) NSString *DeptName;
@property (nonatomic, copy) NSString *EmployeeID;

@property (nonatomic, assign, getter=isChooseBtn) BOOL m_chooseBtn;
@end
//
//  SigninSelectHospitalViewController.h
//  MedicalCRM
//
//  Created by admin on 16/9/5.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SelectHospital)(NSString *ProjectNo,NSString *ProjectName,NSString *CompanyName,NSString *Department,NSString *StatusName,NSString *successRate,NSString *ProjcetId,NSArray *linkMandatas,NSString *custID,NSString *ProductName,NSString *ProductCount);
@interface SigninSelectHospitalViewController : UIViewController
@property (nonatomic, copy) SelectHospital block;
@property (nonatomic, copy) NSString *sType;
@end

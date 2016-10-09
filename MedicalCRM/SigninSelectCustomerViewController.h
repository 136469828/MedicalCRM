//
//  SigninSelectCustomerViewController.h
//  MedicalCRM
//
//  Created by admin on 16/8/31.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^cosblock)(NSString *name,NSString *tel,NSString *CompanyName,NSString *department,NSString *position,NSString *ID);
@interface SigninSelectCustomerViewController : UIViewController
@property (nonatomic, copy) cosblock block;
@end

//
//  TheNewCustomerViewController.h
//  MedicalCRM
//
//  Created by admin on 16/8/11.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^costBlock)(NSString *str, NSString *ID , NSString *phone , NSString *hospitalName,NSString *cusId);
@interface TheNewCustomerViewController : UIViewController
@property (nonatomic, copy) costBlock block;
@end

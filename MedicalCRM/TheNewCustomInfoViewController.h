//
//  TheNewCustomInfoViewController.h
//  MedicalCRM
//
//  Created by admin on 16/8/11.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TheNewCustomer;
@interface TheNewCustomInfoViewController : UIViewController
@property (nonatomic ,strong) TheNewCustomer *model;
@property (nonatomic, copy) NSString *ID;
@end


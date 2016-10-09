//
//  TheNewSigninSelectCustorController.h
//  MedicalCRM
//
//  Created by admin on 16/8/25.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^costBlock)(NSString *name, NSString *phone , NSString *hospitalName,NSString *keshi,NSString *zhiwu, NSString *ID ,NSString *cusId);
@interface TheNewSigninSelectCustorController : UIViewController
@property (nonatomic, copy) costBlock block;
@end

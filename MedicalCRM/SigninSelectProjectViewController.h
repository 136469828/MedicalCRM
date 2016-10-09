//
//  SigninSelectProjectViewController.h
//  MedicalCRM
//
//  Created by admin on 16/8/25.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ablock)(NSString *name,NSString *projectDirectionName,NSString *custor,NSString *tel,NSString *success,NSString *price,NSString *canViewUserName,NSString *ID);
@interface SigninSelectProjectViewController : UIViewController
@property (nonatomic, copy) ablock block;
@property (nonatomic, copy) NSString *keywork;
@property (nonatomic, copy) NSString *CustId;
@end

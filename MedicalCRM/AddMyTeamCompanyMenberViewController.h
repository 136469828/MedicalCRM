//
//  AddMyTeamCompanyMenberViewController.h
//  MedicalCRM
//
//  Created by admin on 16/8/22.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^addblock)(NSString *dataStr);
@interface AddMyTeamCompanyMenberViewController : UIViewController
@property (nonatomic, copy) addblock block;
@end

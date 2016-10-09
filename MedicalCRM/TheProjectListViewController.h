//
//  TheProjectListViewController.h
//  MedicalCRM
//
//  Created by admin on 16/8/5.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^problock)(NSString *str, NSString *ID);
@interface TheProjectListViewController : UIViewController
@property (nonatomic, copy) problock block;
@end

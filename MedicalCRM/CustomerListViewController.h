//
//  CustomerListViewController.h
//  MedicalCRM
//
//  Created by admin on 16/7/19.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^cosBlock)(NSInteger ID, NSString *str , NSString *phone,NSString *num);
@interface CustomerListViewController : UIViewController
@property (nonatomic, copy) cosBlock block;
@end

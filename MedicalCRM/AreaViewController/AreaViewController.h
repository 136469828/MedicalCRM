//
//  AreaViewController.h
//  LoginTest
//
//  Created by Admin on 15/9/16.
//  Copyright (c) 2015年 葱. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^mblock)(NSString *str);
@interface AreaViewController : UIViewController
@property (nonatomic, copy) mblock block;
@end

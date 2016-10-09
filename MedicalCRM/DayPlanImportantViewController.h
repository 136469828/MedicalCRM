//
//  DayPlanImportantViewController.h
//  MedicalCRM
//
//  Created by admin on 16/8/3.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ablock)(NSString *str);
@interface DayPlanImportantViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) ablock block;

@end

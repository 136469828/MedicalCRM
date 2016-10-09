//
//  EquipmentListViewController.h
//  MedicalCRM
//
//  Created by admin on 16/7/22.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^Equipmentblock)(NSArray *names, NSArray *IDs);
@interface EquipmentListViewController : UIViewController
@property (nonatomic, copy) Equipmentblock block;
@end

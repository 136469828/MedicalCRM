//
//  CostDetailViewController.h
//  MedicalCRM
//
//  Created by admin on 16/9/28.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CostDetailModel;
typedef void (^CostDetailblock)(CostDetailModel *costDetailModel);
@interface CostDetailViewController : UIViewController
@property (nonatomic, assign) BOOL isTravelOrOther;
@property (nonatomic, copy) CostDetailblock costDetailblock;
@end

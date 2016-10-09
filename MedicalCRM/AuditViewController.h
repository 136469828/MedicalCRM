//
//  AuditViewController.h
//  MedicalCRM
//
//  Created by admin on 16/8/4.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GetsellsamplepagelistforcheckModel;
@class CostAuditingListModel;
@interface AuditViewController : UIViewController
@property (nonatomic, strong) GetsellsamplepagelistforcheckModel *model;
@property (nonatomic, strong) CostAuditingListModel *model2;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, assign) int stye;
@end

//
//  PayInfoViewController.h
//  MedicalCRM
//
//  Created by admin on 16/8/9.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayInfoViewController : UIViewController
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *FlowStatusName;
@property (nonatomic, assign) int isAdu;
@property (nonatomic, copy) NSString *ProjectName;
@end

//
//  PaymentCell.h
//  MedicalCRM
//
//  Created by admin on 16/7/14.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *stateImg;
+ (instancetype)selectedCell:(UITableView *)tableView;
@end

//
//  LifeNanvgation2Cell.h
//  MedicalCRM
//
//  Created by admin on 16/8/8.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LifeNanvgation2Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *tf21;
@property (weak, nonatomic) IBOutlet UIButton *bt21;
@property (weak, nonatomic) IBOutlet UIButton *bt22;

@property (weak, nonatomic) IBOutlet UITextView *tv21;

+ (instancetype)selectedCell:(UITableView *)tableView;
@end

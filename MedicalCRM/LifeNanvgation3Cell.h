//
//  LifeNanvgation3Cell.h
//  MedicalCRM
//
//  Created by admin on 16/8/8.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LifeNanvgation3Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *tf31;
@property (weak, nonatomic) IBOutlet UITextField *tf32;
@property (weak, nonatomic) IBOutlet UITextField *tf33;


+ (instancetype)selectedCell:(UITableView *)tableView;
@end

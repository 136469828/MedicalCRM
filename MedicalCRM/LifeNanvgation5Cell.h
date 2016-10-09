//
//  LifeNanvgation5Cell.h
//  MedicalCRM
//
//  Created by admin on 16/8/12.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LifeNanvgation5Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *tf5;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITextView *tv5;
+ (instancetype)selectedCell:(UITableView *)tableView;
@end

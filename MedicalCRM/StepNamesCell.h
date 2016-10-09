//
//  StepNamesCell.h
//  MedicalCRM
//
//  Created by admin on 16/8/18.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StepNamesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
+ (instancetype)selectedCell:(UITableView *)tableView;
@end

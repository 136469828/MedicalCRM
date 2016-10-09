//
//  ProjectBuildCell.h
//  MedicalCRM
//
//  Created by admin on 16/7/20.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ProjectBuildCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
+ (instancetype)selectedCell:(UITableView *)tableView;
@end

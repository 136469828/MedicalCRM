//
//  ProjectFollow1TableViewCell.h
//  MedicalCRM
//
//  Created by admin on 16/7/25.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectFollow1TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titles;
@property (weak, nonatomic) IBOutlet UITextField *textFild;
+ (instancetype)selectedCell:(UITableView *)tableView;
@end

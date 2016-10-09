//
//  ProjectMangerCell.h
//  MedicalCRM
//
//  Created by admin on 16/7/13.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectMangerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *stateLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *custorLab;
@property (weak, nonatomic) IBOutlet UILabel *ProjectNo;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *successLab;
+ (instancetype)selectedCell:(UITableView *)tableView;
@end

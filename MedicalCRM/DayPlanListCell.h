//
//  DayPlanListCell.h
//  MedicalCRM
//
//  Created by admin on 16/8/2.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DayPlantListModel;
@interface DayPlanListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *classLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *fangxiangLab;
+ (instancetype)selectedCell:(UITableView *)tableView DataModel:(DayPlantListModel *)model;
@end

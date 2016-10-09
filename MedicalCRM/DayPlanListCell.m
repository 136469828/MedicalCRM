//
//  DayPlanListCell.m
//  MedicalCRM
//
//  Created by admin on 16/8/2.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "DayPlanListCell.h"
#import "DayPlantListModel.h"
@implementation DayPlanListCell

- (void)awakeFromNib {
    // Initialization code
}
+ (instancetype)selectedCell:(UITableView *)tableView DataModel:(DayPlantListModel *)model
{
    static NSString *ID = @"DayPlanListCell";
    
    DayPlanListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DayPlanListCell" owner:self options:nil] firstObject];
    }
    cell.titleLab.text = model.AimTitle;
//    cell.contextLab.text = model.AimContent;
    cell.timeLab.text = model.EndDate;
    cell.classLab.text = model.AimSortName;
    cell.fangxiangLab.text = model.AimDirectionName;
    cell.selectionStyle = UITableViewCellAccessoryNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

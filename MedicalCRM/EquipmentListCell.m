//
//  EquipmentListCell.m
//  MedicalCRM
//
//  Created by admin on 16/9/1.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "EquipmentListCell.h"
#import "EquipmentListModel.h"
@implementation EquipmentListCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)rowSelected
{
    self.selectedBtn.selected = !self.selectedBtn.isSelected;
    [self.selectedBtn setBackgroundImage:[UIImage imageNamed:@"score_icon_select.png"] forState:UIControlStateSelected];
}
+ (instancetype)selectedCell:(UITableView *)tableView
{
    static NSString *ID = @"EquipmentListCell";
    
    EquipmentListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EquipmentListCell" owner:self options:nil] firstObject];
    }
    
    cell.selectionStyle = UITableViewCellAccessoryNone;
    return cell;
}
- (void)setM_model:(EquipmentListModel *)m_model
{
    _m_model = m_model;
    
    self.titleLab.text = _m_model.ProductName;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

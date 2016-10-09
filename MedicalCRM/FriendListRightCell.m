//
//  FriendListRightCell.m
//  MedicalCRM
//
//  Created by admin on 16/7/18.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "FriendListRightCell.h"
#import "FriendListModel.h"
@implementation FriendListRightCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)rowSelected
{
    self.selectedBtn.selected = !self.selectedBtn.isSelected;
    [self.selectedBtn setBackgroundImage:[UIImage imageNamed:@"score_icon_select.png"] forState:UIControlStateSelected];
}

- (void)setM_model:(FriendListModel *)m_model
{
    _m_model = m_model;
    
    self.nameLab.text = _m_model.EmployeeName;
}


+ (instancetype)selectedCell:(UITableView *)tableView
{
    static NSString *ID = @"FriendListRightCell";
    
    FriendListRightCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FriendListRightCell" owner:self options:nil] firstObject];
    }

    cell.selectionStyle = UITableViewCellAccessoryNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

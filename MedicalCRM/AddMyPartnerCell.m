//
//  AddMyPartnerCell.m
//  MedicalCRM
//
//  Created by admin on 16/8/30.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "AddMyPartnerCell.h"
#import "AddMyPartnerModel.h"
@implementation AddMyPartnerCell

- (void)awakeFromNib {
    // Initialization code
    self.bgView.layer.cornerRadius = 5;
}
- (void)rowSelected
{
    self.selectedBtn.selected = !self.selectedBtn.isSelected;
    [self.selectedBtn setBackgroundImage:[UIImage imageNamed:@"score_icon_select.png"] forState:UIControlStateSelected];
}
+ (instancetype)selectedCell:(UITableView *)tableView
{
    static NSString *ID = @"AddMyPartnerCell";
    
    AddMyPartnerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AddMyPartnerCell" owner:self options:nil] firstObject];
    }
    
    cell.selectionStyle = UITableViewCellAccessoryNone;
    return cell;
}
- (void)setM_model:(AddMyPartnerModel *)m_model
{
    _m_model = m_model;
    
    self.nameLab.text = _m_model.LinkManName;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

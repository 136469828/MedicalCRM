//
//  ProjectMangerCell.m
//  MedicalCRM
//
//  Created by admin on 16/7/13.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "ProjectMangerCell.h"

@implementation ProjectMangerCell

- (void)awakeFromNib {
    // Initialization code
    self.bgView.layer.cornerRadius = 2;
}
+ (instancetype)selectedCell:(UITableView *)tableView
{
    static NSString *ID = @"ProjectMangerCell";
    
    ProjectMangerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ProjectMangerCell" owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellAccessoryNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

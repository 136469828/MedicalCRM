//
//  StepNamesCell.m
//  MedicalCRM
//
//  Created by admin on 16/8/18.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "StepNamesCell.h"

@implementation StepNamesCell

- (void)awakeFromNib {
    // Initialization code
}
+ (instancetype)selectedCell:(UITableView *)tableView
{
    static NSString *ID = @"StepNamesCell";
    
    StepNamesCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"StepNamesCell" owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellAccessoryNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

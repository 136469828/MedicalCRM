//
//  ProjectBuildCell.m
//  MedicalCRM
//
//  Created by admin on 16/7/20.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "ProjectBuildCell.h"

@implementation ProjectBuildCell

- (void)awakeFromNib {
    // Initialization code
}

+ (instancetype)selectedCell:(UITableView *)tableView
{
    static NSString *ID = @"ProjectBuildCell";
    
    ProjectBuildCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ProjectBuildCell" owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellAccessoryNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end

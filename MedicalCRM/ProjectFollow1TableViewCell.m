//
//  ProjectFollow1TableViewCell.m
//  MedicalCRM
//
//  Created by admin on 16/7/25.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "ProjectFollow1TableViewCell.h"

@implementation ProjectFollow1TableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)selectedCell:(UITableView *)tableView
{
    static NSString *ID = @"ProjectFollow1TableViewCell";
    
    ProjectFollow1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ProjectFollow1TableViewCell" owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellAccessoryNone;
    return cell;
}

@end

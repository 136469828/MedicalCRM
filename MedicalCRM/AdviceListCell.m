//
//  AdviceListCell.m
//  MedicalCRM
//
//  Created by admin on 16/8/16.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "AdviceListCell.h"

@implementation AdviceListCell
+ (instancetype)selectedCell:(UITableView *)tableView
{
    static NSString *ID = @"AdviceListCell";
    
    AdviceListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AdviceListCell" owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellAccessoryNone;
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

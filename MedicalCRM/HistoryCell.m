//
//  HistoryCell.m
//  MedicalCRM
//
//  Created by admin on 16/7/14.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "HistoryCell.h"

@implementation HistoryCell

- (void)awakeFromNib {
    // Initialization code
}
+ (instancetype)selectedCell:(UITableView *)tableView
{
    static NSString *ID = @"HistoryCell";
    
    HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HistoryCell" owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellAccessoryNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

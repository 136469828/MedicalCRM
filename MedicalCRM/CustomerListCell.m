//
//  CustomerListCell.m
//  MedicalCRM
//
//  Created by admin on 16/8/12.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "CustomerListCell.h"

@implementation CustomerListCell

- (void)awakeFromNib {
    // Initialization code
}
+ (instancetype)selectedCell:(UITableView *)tableView
{
    static NSString *ID = @"CustomerListCell";
    
    CustomerListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CustomerListCell" owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellAccessoryNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  TheNewCustomerListCell.m
//  MedicalCRM
//
//  Created by admin on 16/8/11.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "TheNewCustomerListCell.h"

@implementation TheNewCustomerListCell

- (void)awakeFromNib {
    // Initialization code
    self.bgView.layer.cornerRadius = 5;
}
+ (instancetype)selectedCell:(UITableView *)tableView
{
    static NSString *ID = @"TheNewCustomerListCell";
    
    TheNewCustomerListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TheNewCustomerListCell" owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellAccessoryNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

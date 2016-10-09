//
//  ProInfoProcessCell.m
//  MedicalCRM
//
//  Created by admin on 16/8/31.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "ProInfoProcessCell.h"

@implementation ProInfoProcessCell

- (void)awakeFromNib {
    // Initialization code
    self.btn.layer.cornerRadius = 3;
}
+ (instancetype)selectedCell:(UITableView *)tableView
{
    static NSString *ID = @"ProInfoProcessCell";
    
    ProInfoProcessCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ProInfoProcessCell" owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellAccessoryNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

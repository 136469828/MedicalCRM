//
//  LifeNanvgation2Cell.m
//  MedicalCRM
//
//  Created by admin on 16/8/8.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "LifeNanvgation2Cell.h"

@implementation LifeNanvgation2Cell

- (void)awakeFromNib {
    // Initialization code
    self.tv21.layer.borderColor = RGB(178, 178, 178).CGColor;
    self.tv21.layer.cornerRadius = 5;
    self.tv21.layer.borderWidth = 1;
}
+ (instancetype)selectedCell:(UITableView *)tableView
{
    static NSString *ID = @"LifeNanvgation2Cell";
    
    LifeNanvgation2Cell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LifeNanvgation2Cell" owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellAccessoryNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

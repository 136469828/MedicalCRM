//
//  LifeNanvgation4Cell.m
//  MedicalCRM
//
//  Created by admin on 16/8/9.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "LifeNanvgation4Cell.h"

@implementation LifeNanvgation4Cell

- (void)awakeFromNib {
    // Initialization code
}
+ (instancetype)selectedCell:(UITableView *)tableView
{
    static NSString *ID = @"LifeNanvgation4Cell";
    
    LifeNanvgation4Cell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LifeNanvgation4Cell" owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellAccessoryNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

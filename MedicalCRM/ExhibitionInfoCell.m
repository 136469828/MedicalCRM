//
//  ExhibitionInfoCell.m
//  MedicalCRM
//
//  Created by admin on 16/8/11.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "ExhibitionInfoCell.h"

@implementation ExhibitionInfoCell

- (void)awakeFromNib {
    // Initialization code
}
+ (instancetype)selectedCell:(UITableView *)tableView
{
    static NSString *ID = @"ExhibitionInfoCell";
    
    ExhibitionInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ExhibitionInfoCell" owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellAccessoryNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

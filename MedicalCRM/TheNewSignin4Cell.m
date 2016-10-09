//
//  TheNewSignin4Cell.m
//  MedicalCRM
//
//  Created by admin on 16/9/28.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "TheNewSignin4Cell.h"

@implementation TheNewSignin4Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)selectedCell:(UITableView *)tableView
{
    static NSString *ID = @"TheNewSignin4Cell";
    
    TheNewSignin4Cell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TheNewSignin4Cell" owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellAccessoryNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

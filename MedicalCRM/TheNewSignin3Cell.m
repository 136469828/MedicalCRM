//
//  TheNewSignin3Cell.m
//  MedicalCRM
//
//  Created by admin on 16/9/27.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "TheNewSignin3Cell.h"

@implementation TheNewSignin3Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)selectedCell:(UITableView *)tableView
{
    static NSString *ID = @"TheNewSignin3Cell";
    
    TheNewSignin3Cell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TheNewSignin3Cell" owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellAccessoryNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

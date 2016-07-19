//
//  ProjectInfo2Cell.m
//  MedicalCRM
//
//  Created by admin on 16/7/15.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "ProjectInfo2Cell.h"

@implementation ProjectInfo2Cell

- (void)awakeFromNib {
    // Initialization code
}
+ (instancetype)selectedCell:(UITableView *)tableView
{
    static NSString *ID = @"ProjectInfo2Cell";
    
    ProjectInfo2Cell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ProjectInfo2Cell" owner:self options:nil] firstObject];
    }
    cell.nameLab.text = @"客户(公司)名字: P&G宝洁";
    cell.phoneLab.text = @"联系方式: 18575523716";
    cell.addressLab.text = @"广东省 深圳市 宝安区 宝安5区建安一路海雅缤纷城2层（星巴克楼上）近地铁灵芝站";
    cell.selectionStyle = UITableViewCellAccessoryNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

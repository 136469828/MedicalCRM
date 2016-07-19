//
//  ProjectInfoCell.m
//  MedicalCRM
//
//  Created by admin on 16/7/15.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "ProjectInfoCell.h"
#import "UIImageView+WebCache.h"
@implementation ProjectInfoCell

- (void)awakeFromNib {
    // Initialization code
}
+ (instancetype)selectedCell:(UITableView *)tableView
{
    static NSString *ID = @"ProjectInfoCell";
    
    ProjectInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ProjectInfoCell" owner:self options:nil] firstObject];
    }
    cell.nameLab.text = @"索尼LMD-2140MD（医疗用）LMD2140MD,索尼2140MD";
    cell.priceLab.text = @"￥20万";
    cell.timeLab.text = @"2010-10-10";
    [cell.imgV sd_setImageWithURL:[NSURL URLWithString:@"http://2b.zol-img.com.cn/product/77_280x210/49/cebKZSpHG2c.jpg"]];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

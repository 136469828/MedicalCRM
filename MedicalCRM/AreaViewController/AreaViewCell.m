//
//  AreaViewCell.m
//  MedicalCRM
//
//  Created by admin on 16/8/4.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "AreaViewCell.h"
//#import "GetsellsamplepagelistforcheckModel.h"
@implementation AreaViewCell

- (void)awakeFromNib {
    // Initialization code
}
+ (instancetype)selectedCell:(UITableView *)tableView
{
    static NSString *ID = @"AreaViewCell";
    
    AreaViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AreaViewCell" owner:self options:nil] firstObject];
    }
//    cell.titleLab.text = model.CustName;//model.Title;
//    cell.timeLab.text = [model.CreateDate substringToIndex:16];
//    cell.nameLab.text = model.CreatorName;
//    cell.sampleNo.text = model.ApplyNo;
//    cell.sampleName.text = model.ProductName;
//    cell.sentSampDate.text = @"";
//    cell.endTime.text = @"";
//    cell.isOutTime.text = @"";
//    cell.isAgain.text = @"";
//    cell.sendSell.text = @"";
//    cell.updateDate.text = @"";
//    cell.CustName.text = model.CustName;
//    cell.selectionStyle = UITableViewCellAccessoryNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

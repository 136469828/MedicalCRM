//
//  ProInfo3Cell.m
//  MedicalCRM
//
//  Created by admin on 16/7/29.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "ProInfo3Cell.h"
#import "ProInfoFollewModel.h"
@implementation ProInfo3Cell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)selectedCell:(UITableView *)tableView Data:(ProInfoFollewModel *)datas
{
    static NSString *ID = @"ProInfo3Cell";
    
    ProInfo3Cell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ProInfo3Cell" owner:self options:nil] firstObject];
    }
//    for (NSDictionary *dic in datas)
//    {
////        JCKLog(@"%@",dic[@"Rate"]);
        cell.rateLab.text = [NSString stringWithFormat:@"完成度: %@",datas.Rate];
        cell.timeLab.text = [NSString stringWithFormat:@"%@~%@",[self newStr:datas.BeginDate],[self newStr:datas.EndDate]];
        cell.priceLab.text = [NSString stringWithFormat:@"预计费用: %@",datas.ProcessScale];
        cell.manLab.text = [NSString stringWithFormat:@"预计人数: %@",datas.PersonNum];
        cell.remarkLab.text = [NSString stringWithFormat:@"备忘: %@",datas.SummaryName];
//    }
    cell.selectionStyle = UITableViewCellAccessoryNone;
    return cell;
}
+ (NSString *)newStr:(NSString *)str
{
    return [str substringToIndex:10];//截取掉下标7之后的字符串
}
@end

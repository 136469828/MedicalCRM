//
//  ProjectMangerCollectionViewCell.m
//  MedicalCRM
//
//  Created by admin on 16/7/26.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "ProjectMangerCollectionViewCell.h"
#import "GetprojectpagelistModel.h"
@implementation ProjectMangerCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}
//required
+ (UICollectionViewCell *)setCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath Datas:(NSArray *)datas
{
    GetprojectpagelistModel *model = datas[indexPath.row];
    static NSString *ID = @"ProjectMangerCollectionViewCell";
    ProjectMangerCollectionViewCell *cell = nil;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ProjectMangerCollectionViewCell" owner:self options:nil] firstObject];

    }
    cell.layer.cornerRadius = 5;
    cell.titleLab.text = model.ProjectName;
    cell.numbLab.text = model.ProjectNo;
    cell.timeLab.text = [self changDate:model.CreateDate];
    cell.nameLab.text = model.CustLinkMan;
    cell.success.text = [NSString stringWithFormat:@"%.2f%%",[model.SuccessRate floatValue]*100];
    if ([model.SuccessRate floatValue] >= 0.5)
    {
        cell.success.textColor = RGB(118, 223, 60);
    }
    else if (0.3 < [model.SuccessRate floatValue] < 0.5)
    {
        cell.success.textColor = [UIColor redColor];
    }
    else
    {
        cell.success.textColor = [UIColor orangeColor];
    }
    cell.tag = [model.ID integerValue];
    return cell;
}
+ (NSString *)changDate:(NSString *)date
{
    return [date substringToIndex:10];//截取掉下标7之后的字符串
}
@end

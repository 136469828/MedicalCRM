//
//  MyPerformanceTableViewCell.h
//  MedicalCRM
//
//  Created by admin on 16/8/5.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPerformanceTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *namelab;

@property (weak, nonatomic) IBOutlet UILabel *titmeLab;
@property (weak, nonatomic) IBOutlet UILabel *countLab;

@property (weak, nonatomic) IBOutlet UILabel *totlePrice;
+ (instancetype)selectedCell:(UITableView *)tableView;
@end

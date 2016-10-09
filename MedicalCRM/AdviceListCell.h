//
//  AdviceListCell.h
//  MedicalCRM
//
//  Created by admin on 16/8/16.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdviceListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak, nonatomic) IBOutlet UILabel *contextLab;
+ (instancetype)selectedCell:(UITableView *)tableView;
@end

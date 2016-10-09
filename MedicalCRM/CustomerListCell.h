//
//  CustomerListCell.h
//  MedicalCRM
//
//  Created by admin on 16/8/12.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UILabel *keshiLab;
@property (weak, nonatomic) IBOutlet UILabel *zhiwuLab;
@property (weak, nonatomic) IBOutlet UILabel *yiyuanLab;
+ (instancetype)selectedCell:(UITableView *)tableView;
@end

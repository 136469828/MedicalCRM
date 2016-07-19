//
//  MeTableViewCell.h
//  MedicalCRM
//
//  Created by admin on 16/7/8.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UILabel *zhiwuLab;
+ (instancetype)selectedCell:(UITableView *)tableView;
@end

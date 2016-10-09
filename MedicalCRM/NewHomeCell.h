//
//  NewHomeCell.h
//  MedicalCRM
//
//  Created by admin on 16/8/8.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewHomeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLab;
+ (instancetype)selectedCell:(UITableView *)tableView;
@end
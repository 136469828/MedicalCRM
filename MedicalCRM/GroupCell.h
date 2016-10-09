//
//  GroupCell.h
//  MedicalCRM
//
//  Created by admin on 16/8/6.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupCell : UITableViewCell
+ (instancetype)selectedCell:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *tagLab;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@end

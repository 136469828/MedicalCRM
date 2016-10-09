//
//  TheNewCell.h
//  MedicalCRM
//
//  Created by admin on 16/8/6.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TheNewCell : UITableViewCell
+ (instancetype)selectedCell:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contextLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@end

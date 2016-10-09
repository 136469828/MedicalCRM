//
//  ProInfoProcessCell.h
//  MedicalCRM
//
//  Created by admin on 16/8/31.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProInfoProcessCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contextLab;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIButton *btn;


+ (instancetype)selectedCell:(UITableView *)tableView;
@end

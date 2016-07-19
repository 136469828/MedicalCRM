//
//  ProjectInfo2Cell.h
//  MedicalCRM
//
//  Created by admin on 16/7/15.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectInfo2Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
+ (instancetype)selectedCell:(UITableView *)tableView;
@end

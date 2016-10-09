//
//  ExhibitionListCell.h
//  MedicalCRM
//
//  Created by admin on 16/8/5.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExhibitionListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *linkManLab;

@property (weak, nonatomic) IBOutlet UILabel *cTimeLab;

+ (instancetype)selectedCell:(UITableView *)tableView;
@end

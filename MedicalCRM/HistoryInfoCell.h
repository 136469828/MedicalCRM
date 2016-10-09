//
//  HistoryInfoCell.h
//  MedicalCRM
//
//  Created by admin on 16/8/5.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *feeapply1;
@property (weak, nonatomic) IBOutlet UILabel *feeapply2;
@property (weak, nonatomic) IBOutlet UILabel *feeapply3;
@property (weak, nonatomic) IBOutlet UILabel *feeapply4;
@property (weak, nonatomic) IBOutlet UILabel *totalLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;
+ (instancetype)selectedCell:(UITableView *)tableView;
@end

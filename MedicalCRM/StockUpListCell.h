//
//  StockUpListCell.h
//  MedicalCRM
//
//  Created by admin on 16/8/16.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StockUpListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *productNoLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *productNameLab;
@property (weak, nonatomic) IBOutlet UILabel *creName;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *cusLab;
@property (weak, nonatomic) IBOutlet UILabel *updateTimeLab;
+ (instancetype)selectedCell:(UITableView *)tableView;
@end

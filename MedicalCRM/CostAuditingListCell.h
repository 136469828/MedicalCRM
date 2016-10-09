//
//  CostAuditingListCell.h
//  MedicalCRM
//
//  Created by admin on 16/8/13.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CostAuditingListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *caiwu;
@property (weak, nonatomic) IBOutlet UILabel *projectLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *resonLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *lindao;
@property (weak, nonatomic) IBOutlet UILabel *paragraphLab;
@property (weak, nonatomic) IBOutlet UILabel *zongjingli;
@property (weak, nonatomic) IBOutlet UILabel *shangwu;
@property (weak, nonatomic) IBOutlet UILabel *chengguochi;
@property (weak, nonatomic) IBOutlet UILabel *costNo;

@property (weak, nonatomic) IBOutlet UILabel *daqu;

+ (instancetype)selectedCell:(UITableView *)tableView;
@end

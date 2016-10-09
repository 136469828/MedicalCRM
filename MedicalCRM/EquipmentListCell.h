//
//  EquipmentListCell.h
//  MedicalCRM
//
//  Created by admin on 16/9/1.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EquipmentListModel;
@interface EquipmentListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;

@property (nonatomic, strong) EquipmentListModel *m_model;
- (void)rowSelected;
+ (instancetype)selectedCell:(UITableView *)tableView;
@end

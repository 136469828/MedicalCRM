//
//  MyPayCell.h
//  MedicalCRM
//
//  Created by admin on 16/7/14.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PayListModel;
@interface MyPayCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *needTime;
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UIImageView *stateImg;
@property (weak, nonatomic) IBOutlet UILabel *resonLab;
@property (weak, nonatomic) IBOutlet UILabel *CreatorName;
@property (weak, nonatomic) IBOutlet UILabel *stateLab;

+ (instancetype)selectedCell:(UITableView *)tableView;
@end

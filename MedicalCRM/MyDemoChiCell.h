//
//  MyDemoChiCell.h
//  MedicalCRM
//
//  Created by admin on 16/7/30.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyDemoModel;
@interface MyDemoChiCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *productNo;
@property (weak, nonatomic) IBOutlet UILabel *cusName;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *CreatorName;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *productCount;

+ (instancetype)selectedCell:(UITableView *)tableView;
@end

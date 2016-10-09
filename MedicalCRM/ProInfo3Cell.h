//
//  ProInfo3Cell.h
//  MedicalCRM
//
//  Created by admin on 16/7/29.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProInfoFollewModel;
@interface ProInfo3Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *manLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *remarkLab;
@property (weak, nonatomic) IBOutlet UILabel *rateLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
+ (instancetype)selectedCell:(UITableView *)tableView Data:(ProInfoFollewModel *)datas;
@end

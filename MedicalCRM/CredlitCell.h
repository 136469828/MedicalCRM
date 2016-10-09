//
//  CredlitCell.h
//  MedicalCRM
//
//  Created by admin on 16/8/12.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CredlitCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *PrjectTotalCount;
@property (weak, nonatomic) IBOutlet UILabel *FinishProejct;
@property (weak, nonatomic) IBOutlet UILabel *ProjectTotalMoney;
@property (weak, nonatomic) IBOutlet UILabel *MyProperty;
@property (weak, nonatomic) IBOutlet UILabel *ProjectReimburse;
+ (instancetype)selectedCell:(UITableView *)tableView;
@end

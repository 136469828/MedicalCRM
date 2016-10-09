//
//  TheNewSignin2Cell.h
//  MedicalCRM
//
//  Created by admin on 16/8/24.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TheNewSignin2Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *leftTitleLab;
@property (weak, nonatomic) IBOutlet UITextField *leftTf;
@property (weak, nonatomic) IBOutlet UILabel *rightLab;
@property (weak, nonatomic) IBOutlet UITextField *rightTf;

+ (instancetype)selectedCell:(UITableView *)tableView;
@end

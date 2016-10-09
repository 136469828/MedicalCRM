//
//  TheNewSignin3Cell.h
//  MedicalCRM
//
//  Created by admin on 16/9/27.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TheNewSignin3Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftLab;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UILabel *rightLab;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
+ (instancetype)selectedCell:(UITableView *)tableView;
@end

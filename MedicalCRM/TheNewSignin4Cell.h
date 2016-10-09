//
//  TheNewSignin4Cell.h
//  MedicalCRM
//
//  Created by admin on 16/9/28.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TheNewSignin4Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITextField *costTf;
+ (instancetype)selectedCell:(UITableView *)tableView;
@end

//
//  LifeNanvigationCell.h
//  MedicalCRM
//
//  Created by admin on 16/8/8.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LifeNanvigationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *tf1;

@property (weak, nonatomic) IBOutlet UITextField *tf2;

@property (weak, nonatomic) IBOutlet UITextField *tf3;

@property (weak, nonatomic) IBOutlet UITextField *tf4;
@property (weak, nonatomic) IBOutlet UITextField *tf5;
+ (instancetype)selectedCell:(UITableView *)tableView;
@end

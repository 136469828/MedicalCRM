//
//  LifeNanvgation4Cell.h
//  MedicalCRM
//
//  Created by admin on 16/8/9.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LifeNanvgation4Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *tf31;
@property (weak, nonatomic) IBOutlet UITextField *tf33;
@property (weak, nonatomic) IBOutlet UITextField *tf32;
+ (instancetype)selectedCell:(UITableView *)tableView;
@end

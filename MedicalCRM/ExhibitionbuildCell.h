//
//  ExhibitionbuildCell.h
//  MedicalCRM
//
//  Created by admin on 16/8/13.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExhibitionbuildCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *textf;
+ (instancetype)selectedCell:(UITableView *)tableView;
@end

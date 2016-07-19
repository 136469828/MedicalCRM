//
//  PublicProjectCell.h
//  MedicalCRM
//
//  Created by admin on 16/7/14.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublicProjectCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contextLab;
+ (instancetype)selectedCell:(UITableView *)tableView;
@end

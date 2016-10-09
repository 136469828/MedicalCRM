//
//  AuditFollowCell.h
//  MedicalCRM
//
//  Created by admin on 16/8/5.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuditFollowCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *bumenLab;
@property (weak, nonatomic) IBOutlet UILabel *yijianLab;

@property (weak, nonatomic) IBOutlet UILabel *shijianLab;

+ (instancetype)selectedCell:(UITableView *)tableView;
@end

//
//  MsgListCell.h
//  MedicalCRM
//
//  Created by admin on 16/8/9.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MsgListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *msgImgV;
@property (weak, nonatomic) IBOutlet UILabel *contextLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *tagLab1;
@property (weak, nonatomic) IBOutlet UILabel *tagLab2;
@property (weak, nonatomic) IBOutlet UILabel *IdLab;

@property (weak, nonatomic) IBOutlet UILabel *tabLab3;
+ (instancetype)selectedCell:(UITableView *)tableView;
@end

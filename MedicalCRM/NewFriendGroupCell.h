//
//  NewFriendGroupCell.h
//  MedicalCRM
//
//  Created by admin on 16/8/6.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewFriendGroupCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgV;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *tagLab;
@property (weak, nonatomic) IBOutlet UIButton *phoneAction;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;

+ (instancetype)selectedCell:(UITableView *)tableView;
@end

//
//  FriendListRightCell.h
//  MedicalCRM
//
//  Created by admin on 16/7/18.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FriendListModel;
@interface FriendListRightCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *tagLab;
@property (weak, nonatomic) IBOutlet UIImageView *hearImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;

@property (nonatomic, strong) FriendListModel *m_model;
- (void)rowSelected;
+ (instancetype)selectedCell:(UITableView *)tableView;
@end

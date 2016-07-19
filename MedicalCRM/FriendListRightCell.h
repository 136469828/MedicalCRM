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
@property (nonatomic, strong) FriendListModel *m_model;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
- (void)rowSelected;

@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
+ (instancetype)selectedCell:(UITableView *)tableView;
@end

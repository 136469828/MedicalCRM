//
//  AddMyPartnerCell.h
//  MedicalCRM
//
//  Created by admin on 16/8/30.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddMyPartnerModel;
@interface AddMyPartnerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *zhiwuLab;
@property (weak, nonatomic) IBOutlet UILabel *partMentLab;
@property (weak, nonatomic) IBOutlet UILabel *companyLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UILabel *tagLab;
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;

@property (nonatomic, strong) AddMyPartnerModel *m_model;
- (void)rowSelected;
+ (instancetype)selectedCell:(UITableView *)tableView;
@end

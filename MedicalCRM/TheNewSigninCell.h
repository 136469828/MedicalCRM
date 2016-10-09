//
//  TheNewSigninCell.h
//  MedicalCRM
//
//  Created by admin on 16/8/24.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TheNewSigninCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *hearImg;
@property (weak, nonatomic) IBOutlet UIView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIButton *lookHistorBtn;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *dayLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

+ (instancetype)selectedCell:(UITableView *)tableView;
@end

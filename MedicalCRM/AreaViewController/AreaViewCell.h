//
//  AreaViewCell.h
//  MedicalCRM
//
//  Created by admin on 16/8/4.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class GetsellsamplepagelistforcheckModel;
@interface AreaViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak, nonatomic) IBOutlet UILabel *CustName;
@property (weak, nonatomic) IBOutlet UILabel *sampleNo;
@property (weak, nonatomic) IBOutlet UILabel *sampleName;
@property (weak, nonatomic) IBOutlet UILabel *sentSampDate;
@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet UILabel *isOutTime;
@property (weak, nonatomic) IBOutlet UILabel *isAgain;
@property (weak, nonatomic) IBOutlet UILabel *sendSell;
@property (weak, nonatomic) IBOutlet UILabel *updateDate;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

+ (instancetype)selectedCell:(UITableView *)tableView;
@end

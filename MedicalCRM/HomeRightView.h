//
//  HomeRightView.h
//  MedicalCRM
//
//  Created by admin on 16/9/7.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeRightView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
- (void)changeData:(NSInteger )index;
@end

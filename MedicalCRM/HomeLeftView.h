//
//  HomeLeftView.h
//  MedicalCRM
//
//  Created by admin on 16/9/7.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^BLOCK) (NSInteger);
@interface HomeLeftView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) BLOCK blk;

@property (nonatomic, strong) NSArray *leftTitles;
@property (assign, nonatomic) NSIndexPath *selIndex;//单选，当前选中的行
@end

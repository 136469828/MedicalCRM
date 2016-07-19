
//
//  PublicProjectViewController.m
//  MedicalCRM
//
//  Created by admin on 16/7/14.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "PublicProjectViewController.h"
#import "PublicProjectCell.h"
@interface PublicProjectViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation PublicProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTableView];
}

#pragma mark -
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 100;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PublicProjectCell *cell = [PublicProjectCell selectedCell:tableView];
    cell.contextLab.text = @"6月14日消息，在今天苹果WWDC开发者大会上，苹果带来了新的iOS系统——iOS 10。苹果为iOS 10带来了十大项更新。苹果高级副总裁Craig Federighi称此次对iOS的更新是“苹果史上最大的iOS更新";
    return cell;
//    static NSString *allCell = @"cell";
//    UITableViewCell *cell = nil;
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:allCell];
//        cell.selectionStyle = UITableViewCellAccessoryNone;
//    }
//    UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-150,25, 150, 20)];
//    timeLab.tintColor = [UIColor lightGrayColor];
//    timeLab.font = [UIFont systemFontOfSize:11];
//    timeLab.text = @"项目报备时间: 2010-10-10";
//    [cell.contentView addSubview:timeLab];
//    cell.textLabel.text = @"测试客户项目";
//    cell.textLabel.font = [UIFont systemFontOfSize:15];
//    cell.detailTextLabel.text = @"当前进度: 已报备";
//    return cell;
}
@end

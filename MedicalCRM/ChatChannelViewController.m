//
//  ChatChannelViewController.m
//  MedicalCRM
//
//  Created by admin on 16/7/21.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "ChatChannelViewController.h"
#import "ChatListViewController.h"
@interface ChatChannelViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *titles;
    NSArray *imgs;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ChatChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    titles = @[@"好友消息",@"群组消息"];
    imgs = @[@"chat_btn_action_email",@"chat_btn_action_email"];
    [self setTableView];
}
#pragma mark -
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //iOS 8开始的自适应高度，可以不需要实现定义高度的方法
    self.tableView.rowHeight = UITableViewAutomaticDimension;

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
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *allCell = @"cell";
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:allCell];
        cell.selectionStyle = UITableViewCellAccessoryNone;
    }
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imgs[indexPath.row]]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",titles[indexPath.row]];
    return cell;
}

@end
